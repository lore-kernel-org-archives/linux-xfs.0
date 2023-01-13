Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EA1C677F1
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Jan 2023 21:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbjAMV2H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Jan 2023 16:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAMV2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2023 16:28:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B1377D34;
        Fri, 13 Jan 2023 13:28:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34B97B821EE;
        Fri, 13 Jan 2023 21:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52ABC433D2;
        Fri, 13 Jan 2023 21:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673645282;
        bh=cHnyDZ++hr31NhDefkvXl0HFSwaL36XHuIDO263YIY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HVh5+1rEGM79yA2CneH9pi7P1GvDC4ZJkO17mQXRwovhnpdkR6+LWo6qSZkA/RvlM
         yLybHWoV/68upx3xoNCh0QiOlirCDAkD7R9bj/OaEQc6XgnVK7p4mvOVGZ558a1Vli
         p29GkZokPJajz+85BXzi9qqNde5PIxRJZBQIKOg6QmHwFclPdz+sV9Ce/kUnC482d8
         hw+3/2khmKWEaVSQXmhYlR067RKJ07SGHrbMJe+4znYZXcabBfwjiKPUPduYQa1Otx
         S5Wem0YY0LBHUZGKPlCTTi81s96w8eK1OQ5Giu3kUQgfMyXsGrY2nMK8DJm0LtnF3W
         UQlE0jMi2khWQ==
Date:   Fri, 13 Jan 2023 13:28:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 12/16] fuzzy: increase operation count for each fsstress
 invocation
Message-ID: <Y8HM4skVE1Mxmh7u@magnolia>
References: <167243837296.694541.13203497631389630964.stgit@magnolia>
 <167243837460.694541.14076101650568669658.stgit@magnolia>
 <20230113195525.74tcppiq4cpf4mi5@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113195525.74tcppiq4cpf4mi5@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 14, 2023 at 03:55:25AM +0800, Zorro Lang wrote:
> On Fri, Dec 30, 2022 at 02:12:54PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > For online fsck stress testing, increase the number of filesystem
> > operations per fsstress run to 2 million, now that we have the ability
> > to kill fsstress if the user should push ^C to abort the test early.
> > This should guarantee a couple of hours of continuous stress testing in
> > between clearing the scratch filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/fuzzy |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/common/fuzzy b/common/fuzzy
> > index 01cf7f00d8..3e23edc9e4 100644
> > --- a/common/fuzzy
> > +++ b/common/fuzzy
> > @@ -399,7 +399,9 @@ __stress_scrub_fsstress_loop() {
> >  	local end="$1"
> >  	local runningfile="$2"
> >  
> > -	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000 $FSSTRESS_AVOID)
> > +	# As of March 2022, 2 million fsstress ops should be enough to keep
> > +	# any filesystem busy for a couple of hours.
> > +	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000000 $FSSTRESS_AVOID)
> 
> Can fsstress "-l 0" option help?

No.  -n determines the number of operations per loop, and -l determines
the number of loops:

$ fsstress -d dor/ -n 5 -v -s 1
0/0: mkdir d0 17
0/0: mkdir add id=0,parent=-1
0/1: link - no file
0/2: mkdir d1 17
0/2: mkdir add id=1,parent=-1
0/3: chown . 127/0 0
0/4: rename - no source filename

$ fsstress -d dor/ -n 5 -l 2 -v -s 1
0/0: mkdir d0 17
0/0: mkdir add id=0,parent=-1
0/1: link - no file
0/2: mkdir d1 17
0/2: mkdir add id=1,parent=-1
0/3: chown . 127/0 0
0/4: rename - no source filename
0/0: mkdir d2 0
0/0: mkdir add id=2,parent=-1
0/1: link - no file
0/2: mkdir d2/d3 0
0/2: mkdir add id=3,parent=2
0/3: chown d2 127/0 0
0/4: rename(REXCHANGE) d2/d3 and d2 have ancestor-descendant relationship

--D

> >  	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
> >  
> >  	while __stress_scrub_running "$end" "$runningfile"; do
> > 
> 
