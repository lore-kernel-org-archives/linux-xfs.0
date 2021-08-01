Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A5EC4320A
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 13:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AACDC610D1
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 13:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhHANKO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Aug 2021 09:10:14 -0400
Received: from out20-74.mail.aliyun.com ([115.124.20.74]:36042 "EHLO
        out20-74.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhHANKO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 09:10:14 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07443151|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.35296-0.0169022-0.630138;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047205;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.KtqrHvl_1627823404;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KtqrHvl_1627823404)
          by smtp.aliyun-inc.com(10.147.40.26);
          Sun, 01 Aug 2021 21:10:04 +0800
Date:   Sun, 1 Aug 2021 21:10:04 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org,
        guaneryu@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/530: Bail out if either of reflink or rmapbt is
 enabled
Message-ID: <YQadLPYDvDknRFU2@desktop>
References: <20210726064313.19153-1-chandanrlinux@gmail.com>
 <20210726064313.19153-3-chandanrlinux@gmail.com>
 <20210726171916.GV559212@magnolia>
 <87fsw0fjq0.fsf@garuda>
 <20210727183734.GD559142@magnolia>
 <YQaIVYSIwG5UmzS0@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQaIVYSIwG5UmzS0@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 01, 2021 at 07:41:09PM +0800, Eryu Guan wrote:
> On Tue, Jul 27, 2021 at 11:37:34AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 27, 2021 at 10:15:27AM +0530, Chandan Babu R wrote:
> > > On 26 Jul 2021 at 22:49, Darrick J. Wong wrote:
> > > > On Mon, Jul 26, 2021 at 12:13:13PM +0530, Chandan Babu R wrote:
> > > >> _scratch_do_mkfs constructs a mkfs command line by concatenating the values of
> > > >> 1. $mkfs_cmd
> > > >> 2. $MKFS_OPTIONS
> > > >> 3. $extra_mkfs_options
> > > >>
> > > >> The corresponding mkfs command line fails if $MKFS_OPTIONS enables either
> > > >> reflink or rmapbt feature. The failure occurs because the test tries to create
> > > >> a filesystem with realtime device enabled. In such a case, _scratch_do_mkfs()
> > > >> will construct and invoke an mkfs command line without including the value of
> > > >> $MKFS_OPTIONS.
> > > >>
> > > >> To prevent such silent failures, this commit causes the test to exit if it
> > > >> detects either reflink or rmapbt feature being enabled.
> > > >
> > > > Er, what combinations of mkfs.xfs and MKFS_OPTIONS cause this result?
> > > > What kind of fs configuration comes out of that?
> > > 
> > > With MKFS_OPTIONS set as shown below,
> > > 
> > > export MKFS_OPTIONS="-m reflink=1 -b size=1k"
> > > 
> > > _scratch_do_mkfs() invokes mkfs.xfs with both realtime and reflink options
> > > enabled. Such an invocation of mkfs.xfs fails causing _scratch_do_mkfs() to
> > > ignore the contents of $MKFS_OPTIONS while constructing and invoking mkfs.xfs
> > > once again.
> > > 
> > > This time, the fs block size will however be set to 4k (the default block
> > > size). At the beginning of the test we would have obtained the block size of
> > > the filesystem as 1k and used it to compute the size of the realtime device
> > > required to overflow realtime bitmap inode's max pseudo extent count.
> > > 
> > > Invocation of xfs_growfs (made later in the test) ends up succeeding since a
> > > 4k fs block can accommodate more bits than a 1k fs block.
> > 
> > OK, now I think I've finally put all the pieces together.  Both of these
> > patches are fixing weirdness when MKFS_OPTIONS="-m reflink=1 -b size=1k".
> > 
> > With current HEAD, we try to mkfs.xfs with double "-b size" arguments.
> > That fails with 'option respecified', so fstests tries again without
> > MKFS_OPTIONS, which means you don't get the filesystem that you want.
> > If, say, MKFS_OPTIONS also contained bigtime=1, you won't get a bigtime
> > filesystem.
> > 
> > So the first patch removes the double -bsize arguments.  But you still
> > have the problem that the reflink=1 in MKFS_OPTIONS still causes
> > mkfs.xfs to fail (because we don't do rt and reflink yet), so fstests
> > again drops MKFS_OPTIONS, and now you're testing the fs without a block
> > size option at all.  The test still regresses because the special rt
> > geometry depends on the blocksize, and we didn't get all the geometry
> > elements that we need to trip the growfs failure.
> > 
> > Does the following patch fix all that for you?
> 
> Do you have plan to post formal patch? I think both problems could be
> fixed in one patch like you did. I'll leave patch 1 for now.

Ah, I saw the patch now, thanks!

Eryu
