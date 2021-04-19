Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF55C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 02:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20EFB610CB
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 02:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbhDSCFO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Apr 2021 22:05:14 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49149 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233117AbhDSCFO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Apr 2021 22:05:14 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7D7BF1042C5D;
        Mon, 19 Apr 2021 12:04:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lYJHG-00EfcN-54; Mon, 19 Apr 2021 12:04:42 +1000
Date:   Mon, 19 Apr 2021 12:04:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Eryu Guan <guan@eryu.me>, "Darrick J. Wong" <djwong@kernel.org>,
        guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 5/9] common/dmthin: make this work with external log
 devices
Message-ID: <20210419020442.GA1990290@dread.disaster.area>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836230182.2754991.16864806174255630147.stgit@magnolia>
 <YHwlTMySYgKuaw6Y@desktop>
 <YHxFuFvbAiiIrbIo@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHxFuFvbAiiIrbIo@mit.edu>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=7-415B0cAAAA:8
        a=8TaDeLIvRPNBCFSLHwwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 18, 2021 at 10:44:08AM -0400, Theodore Ts'o wrote:
> On Sun, Apr 18, 2021 at 08:25:48PM +0800, Eryu Guan wrote:
> > > diff --git a/tests/generic/223 b/tests/generic/223
> > > index 1f85efe5..a5ace82f 100755
> > > --- a/tests/generic/223
> > > +++ b/tests/generic/223
> > > @@ -43,6 +43,9 @@ for SUNIT_K in 8 16 32 64 128; do
> > >  	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
> > >  	_scratch_mount
> > >  
> > > +	# Make sure everything is on the data device
> > > +	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > 
> > What does this do for non-xfs filesystems? Do we need a FSTYP check and
> > do chattr only on XFS?
> 
> This clears the FS_NOTAIL_FL flag, which prevents tail merging, on the

No, this is not the 'chattr' CLI program. This is the xfs_io
'chattr' command, and they have different attribute namespaces. See
xfs_io for the definitions, but in this case:

	 t    inherit realtime flag (XFS_XFLAG_RTINHERIT)

And so clearing that flag ensures that all newly created files
are on the data device, as per the comment...

> I also have no idea why this helps for xfs --- I would think it's a
> no-op,

Because it's not what you think it is. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
