Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA0BC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 02:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 139BA64E83
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 02:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhBXCIW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 21:08:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhBXCIW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 21:08:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CA6F64E85;
        Wed, 24 Feb 2021 02:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614132461;
        bh=EP2Thve01BLr26z6Q8QsD7es7YpjPkTRzJRWWcz2u5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ram6m0Yt6pxHHe1UbeIUhBKPY2GrXGLoyjCQIrMUOmCbp2jZD5qI0RIWq3I6UOLUZ
         n0U+cS7ktANpUromqYjoHbdOGfUpi0uGEYcmvhAd5B/f1HMMi9kCrtfeptsMrsE1Fu
         /RcQuOrhwYbccY/6zyyRnIgNtHMaF2PWf33RAPS027NshuLhfp+w9Shi8C8Us8jwqM
         ZEr/ePH/+tmC+doilOc18uxq2WTdAWhSfrQE/r558w+C/JUDvMQ97xHk5X6yFmRpRF
         WDkYiAQIEACuTH/Kmojei6JKx2mUfHifVeBSoTz2DBiRTsbwvNZWr7Sof34j1Xss/K
         IGRrQfDU2/m+g==
Date:   Tue, 23 Feb 2021 18:07:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Subject: Re: [PATCH 1/5] man: mark all deprecated V4 format options
Message-ID: <20210224020740.GO7272@magnolia>
References: <161404928523.425731.7157248967184496592.stgit@magnolia>
 <161404929091.425731.465351236842105610.stgit@magnolia>
 <14656568-caf9-c931-2387-e06f171d1ead@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14656568-caf9-c931-2387-e06f171d1ead@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 06:26:05PM -0600, Eric Sandeen wrote:
> On 2/22/21 9:01 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Update the manual pages for the most popular tools to note which options
> > are only useful with the V4 XFS format, and that the V4 format is
> > deprecated and will be removed no later than September 2030.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  man/man8/mkfs.xfs.8  |   16 ++++++++++++++++
> >  man/man8/xfs_admin.8 |   10 ++++++++++
> >  2 files changed, 26 insertions(+)
> > 
> > 
> > diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> > index fac82d74..df25abaa 100644
> > --- a/man/man8/mkfs.xfs.8
> > +++ b/man/man8/mkfs.xfs.8
> > @@ -223,6 +223,11 @@ of calculating and checking the CRCs is not noticeable in normal operation.
> >  By default,
> >  .B mkfs.xfs
> >  will enable metadata CRCs.
> > +.IP
> > +Formatting a filesystem without CRCs selects the V4 format, which is deprecated
> > +and will be removed from upstream in September 2030.
> 
> Can I add:
> 
> + Several other options, noted below, are only tunable on V4 formats, and will
> + be removed along with the V4 format itself.

Ok.

> > +Distributors may choose to withdraw support for the V4 format earlier than
> > +this date.
> >  .TP
> >  .BI finobt= value
> >  This option enables the use of a separate free inode btree index in each
> > @@ -592,6 +597,8 @@ This option can be used to turn off inode alignment when the
> >  filesystem needs to be mountable by a version of IRIX
> >  that does not have the inode alignment feature
> >  (any release of IRIX before 6.2, and IRIX 6.2 without XFS patches).
> > +.IP
> > +This option only applies to the deprecated V4 format.
> 
> and can I change this (and other mkfs option notes) to:
> 
> + This option is only tunable on the deprecated V4 format.
> 
> because we actually do accept i.e. "-i attr=2" on a V5 format today.
> 
> so, "you can't tune it on v5, and it goes away when v4 does" seems to
> capture what you want the user to know.

Assuming we don't add an attr=3 in the meantime.

Though really, I think we should just introduce new feature flags from
now on, and not have these "versioned" features where every time I see
one I have to go look up what the number means.

> >  .TP
> >  .BI attr= value
> >  This is used to specify the version of extended attribute inline
> > @@ -602,6 +609,8 @@ between attribute and extent data.
> >  The previous version 1, which has fixed regions for attribute and
> >  extent data, is kept for backwards compatibility with kernels older
> >  than version 2.6.16.
> > +.IP
> > +This option only applies to the deprecated V4 format.
> >  .TP
> >  .BI projid32bit[= value ]
> >  This is used to enable 32bit quota project identifiers. The
> > @@ -609,6 +618,8 @@ This is used to enable 32bit quota project identifiers. The
> >  is either 0 or 1, with 1 signifying that 32bit projid are to be enabled.
> >  If the value is omitted, 1 is assumed.  (This default changed
> >  in release version 3.2.0.)
> > +.IP
> > +This option only applies to the deprecated V4 format.
> >  .TP
> >  .BI sparse[= value ]
> >  Enable sparse inode chunk allocation. The
> > @@ -690,6 +701,7 @@ stripe-aligned log writes (see the sunit and su options, below).
> >  The previous version 1, which is limited to 32k log buffers and does
> >  not support stripe-aligned writes, is kept for backwards compatibility
> >  with very old 2.4 kernels.
> > +This option only applies to the deprecated V4 format.
> >  .TP
> >  .BI sunit= value
> >  This specifies the alignment to be used for log writes. The
> > @@ -744,6 +756,8 @@ is 1 (on) so you must specify
> >  .B lazy-count=0
> >  if you want to disable this feature for older kernels which don't support
> >  it.
> > +.IP
> > +This option only applies to the deprecated V4 format.
> >  .RE
> >  .PP
> >  .PD 0
> > @@ -803,6 +817,8 @@ will be stored in the directory structure.  The default value is 1.
> >  When CRCs are enabled (the default), the ftype functionality is always
> >  enabled, and cannot be turned off.
> >  .IP
> > +This option only applies to the deprecated V4 format.
> > +.IP
> >  .RE
> >  .TP
> >  .BI \-p " protofile"
> > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > index cccbb224..5ef99316 100644
> > --- a/man/man8/xfs_admin.8
> > +++ b/man/man8/xfs_admin.8
> > @@ -54,6 +54,8 @@ for a detailed description of the XFS log.
> >  Enables unwritten extent support on a filesystem that does not
> >  already have this enabled (for legacy filesystems, it can't be
> >  disabled anymore at mkfs time).
> > +.IP
> > +This option only applies to the deprecated V4 format.
> >  .TP
> >  .B \-f
> >  Specifies that the filesystem image to be processed is stored in a
> > @@ -67,12 +69,16 @@ option).
> >  .B \-j
> >  Enables version 2 log format (journal format supporting larger
> >  log buffers).
> > +.IP
> > +This option only applies to the deprecated V4 format.
> >  .TP
> >  .B \-l
> >  Print the current filesystem label.
> >  .TP
> >  .B \-p
> >  Enable 32bit project identifier support (PROJID32BIT feature).
> > +.IP
> > +This option only applies to the deprecated V4 format.
> >  .TP
> >  .B \-u
> >  Print the current filesystem UUID (Universally Unique IDentifier).
> > @@ -83,6 +89,8 @@ Enable (1) or disable (0) lazy-counters in the filesystem.
> >  Lazy-counters may not be disabled on Version 5 superblock filesystems
> >  (i.e. those with metadata CRCs enabled).
> >  .IP
> > +In other words, this option only applies to the deprecated V4 format.
> > +.IP
> >  This operation may take quite a bit of time on large filesystems as the
> >  entire filesystem needs to be scanned when this option is changed.
> >  .IP
> > @@ -92,6 +100,8 @@ information is kept in other parts of the filesystem to be able to
> >  maintain the counter values without needing to keep them in the
> >  superblock. This gives significant improvements in performance on some
> >  configurations and metadata intensive workloads.
> > +.IP
> > +This option only applies to the deprecated V4 format.
> 
> I think you're restated it here in the same section; I can just drop this extra
> one if you concur.

Ok, yes, thanks. :)

--D

> >  .TP
> >  .BI \-L " label"
> >  Set the filesystem label to
> > 
