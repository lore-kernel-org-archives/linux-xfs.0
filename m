Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC7BC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 21:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86A75207D4
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 21:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgESVP6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 17:15:58 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:50346 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgESVP6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 17:15:58 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id EA1A6D589D9;
        Wed, 20 May 2020 07:15:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jb9aX-0008RP-RG; Wed, 20 May 2020 07:15:49 +1000
Date:   Wed, 20 May 2020 07:15:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] mkfs: simplify the configured sector sizes setting in
 validate_sectorsize
Message-ID: <20200519211549.GQ2040@dread.disaster.area>
References: <1589870320-29475-1-git-send-email-kaixuxia@tencent.com>
 <BYAPR04MB49656AE414B13D704CCC6A6B86B90@BYAPR04MB4965.namprd04.prod.outlook.com>
 <1b6748ad-249a-dbf0-efbd-c13edd344aaa@sandeen.net>
 <64a8d225-1d55-e6f1-eed3-b9a04eb426d6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64a8d225-1d55-e6f1-eed3-b9a04eb426d6@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8
        a=7-415B0cAAAA:8 a=4v0zo-UC3V2FdUUC1c8A:9 a=CjuIK1q_8ugA:10
        a=IZKFYfNWVLfQsFoIDbx0:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 10:56:01PM +0800, kaixuxia wrote:
> On 2020/5/19 21:03, Eric Sandeen wrote:
> > On 5/19/20 3:38 AM, Chaitanya Kulkarni wrote:
> >> On 5/18/20 11:39 PM, xiakaixu1987@gmail.com wrote:
> >>> From: Kaixu Xia <kaixuxia@tencent.com>
> >>>
> >>> There are two places that set the configured sector sizes in validate_sectorsize,
> >>> actually we can simplify them and combine into one if statement.
> >>> Is it me or patch description seems to be longer than what is in the
> >> tree ?
> >>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> >>> ---
> >>>   mkfs/xfs_mkfs.c | 14 ++++----------
> >>>   1 file changed, 4 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> >>> index 039b1dcc..e1904d57 100644
> >>> --- a/mkfs/xfs_mkfs.c
> >>> +++ b/mkfs/xfs_mkfs.c
> >>> @@ -1696,14 +1696,6 @@ validate_sectorsize(
> >>>   	int			dry_run,
> >>>   	int			force_overwrite)
> >>>   {
> >>> -	/* set configured sector sizes in preparation for checks */
> >>> -	if (!cli->sectorsize) {
> >>> -		cfg->sectorsize = dft->sectorsize;
> >>> -	} else {
> >>> -		cfg->sectorsize = cli->sectorsize;
> >>> -	}
> >>> -	cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
> >>> -
> >>
> >> If above logic is correct which I've not looked into it, then dft is
> >> not used in validate_sectorsize(), how about something like this on
> >> the top of this this patch (totally untested):-
> > 
> > Honestly if not set via commandline, and probing fails, we should fall
> > back to dft->sectorsize so that all the defaults are still set in one place,
> > i.e. the defaults structure mkfs_default_params.
> 
> The original logic in validate_sectorsize() is:
> 
>   static void 
>   validate_sectorsize(
>     ...
>     if (!cli->sectorsize) {
> 	cfg->sectorsize = dft->sectorsize;
>     } else {
> 	cfg->sectorsize = cli->sectorsize;
>     }
>     ...
>     if (!cli->sectorsize) {
> 	if (!ft->lsectorsize)
> 	   ft->lsectorsize = XFS_MIN_SECTORSIZE;
> 	...
> 	cfg->sectorsize = ft->psectorsize;
> 	...
>     } 
>     ...
>   }
> 
> Firstly, if not set via commandline and probing fails, we will use the
> XFS_MIN_SECTORSIZE (actually equal to dft->sectorsize). 

Which is incorrect - this code should be using dft->sectorsize, not
hard coding a default value. Defaults are set in the default value
structure so they are all configured in one place, not strewn
randomly through the code and hence are impossible to find and
review.

With the added change to use dft->sectorsize, the rest of the patch
is fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
