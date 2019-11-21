Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEE2C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 23:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB444206D7
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 23:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfKUXmJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 18:42:09 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36160 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726887AbfKUXmD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 18:42:03 -0500
Received: from dread.disaster.area (pa49-181-174-87.pa.nsw.optusnet.com.au [49.181.174.87])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A043D3A24A8;
        Fri, 22 Nov 2019 10:42:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iXw5H-00061o-Ek; Fri, 22 Nov 2019 10:41:59 +1100
Date:   Fri, 22 Nov 2019 10:41:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mkfs: Show progress during block discard
Message-ID: <20191121234159.GI4614@dread.disaster.area>
References: <20191121214445.282160-1-preichl@redhat.com>
 <20191121214445.282160-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121214445.282160-3-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3v0Do7u/0+cnL2zxahI5mg==:117 a=3v0Do7u/0+cnL2zxahI5mg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=_ML9PJGgM4TKY1cQpY8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 21, 2019 at 10:44:45PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a02d6f66..07b8bd78 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1248,6 +1248,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
>  	const uint64_t	step		= (uint64_t)2<<30;
>  	/* Sector size is 512 bytes */
>  	const uint64_t	count		= nsectors << 9;
> +	uint64_t	prev_done	= (uint64_t) ~0;
>  
>  	fd = libxfs_device_to_fd(dev);
>  	if (fd <= 0)
> @@ -1255,6 +1256,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
>  
>  	while (offset < count) {
>  		uint64_t	tmp_step = step;
> +		uint64_t	done = offset * 100 / count;

That will overflow on a EB-scale (2^60 bytes) filesystems, won't it?

>  
>  		if ((offset + step) > count)
>  			tmp_step = count - offset;
> @@ -1268,7 +1270,13 @@ discard_blocks(dev_t dev, uint64_t nsectors)
>  			return;
>  
>  		offset += tmp_step;
> +
> +		if (prev_done != done) {
> +			prev_done = done;
> +			fprintf(stderr, _("Discarding: %2lu%% done\n"), done);
> +		}
>  	}
> +	fprintf(stderr, _("Discarding is done.\n"));

Hmmm - this output doesn't get suppressed when the "quiet" (-q)
option is used. mkfs is supposed to be silent when this option is
specified.

I also suspect that it breaks a few fstests, too, as a some of them
capture and filter mkfs output. They'll need filters to drop these
new messages.

FWIW, a 100 lines of extra mkfs output is going to cause workflow
issues. I know it will cause me problems, because I often mkfs 500TB
filesystems tens of times a day on a discard enabled device. This
extra output will scroll all the context of the previous test run
I'm about to compare against off my terminal screen and so now I
will have to scroll the terminal to look at the results of
back-to-back runs. IOWs, I'm going to immediately want to turn this
output off and have it stay off permanently.

Hence I think that, by default, just outputting a single "Discard in
progress" line before starting the discard would be sufficient
indication of what mkfs is currently doing. If someone wants more
verbose progress output, then we should probably introduce a
"verbose" CLI option to go along with the "quiet" option that
suppresses all output.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
