Return-Path: <SRS0=NVxF=XK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9721C4CEC6
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Sep 2019 03:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6630A20873
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Sep 2019 03:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pksdHGif"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfIODen (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Sep 2019 23:34:43 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34313 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfIODen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Sep 2019 23:34:43 -0400
Received: by mail-pf1-f195.google.com with SMTP id b128so1482331pfa.1;
        Sat, 14 Sep 2019 20:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zhqBgYpu6+2/fKm6m04zudcSA5tJNVZoqqZGnlOqVjc=;
        b=pksdHGifwGHk+EiqhAnNBymSzGJvuXNKnaV9bOY3nf8q5ar2d/ZbUVFa+oqCMF3/3p
         zR5+PziFMJZchM5zqFYzuO3r807UoEobvQbQA1+X/wKLorgXGwEknFgbzVvyMwckCeqr
         bmU8AQuRwyQToalDd2HFfrfyP108VL7+j+YAAHmTluo1NDuovy5Ggw8E5CHkiUY0uD0q
         gJmqxsKSSu30+5nTra67eJXQ3ID1WtujrjvCZn+WlBiS+QGXwA3eDNC9+d4lcOQoy7lf
         CUGLnA5qQ0mWpu+X7+Ow/k3M0dVPgmMElJjBxcHcC8VImTkCIlkqejuiEeCCxy2uFa0T
         rylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zhqBgYpu6+2/fKm6m04zudcSA5tJNVZoqqZGnlOqVjc=;
        b=Yi5qYK0crtqZcco6thqChOSiibM3TmR5BojyOnPGQUCM0AQYbmbDn8nPgomfUSt0Sf
         DitMWUjuCQdG0KHjOeWOvHfYqg9yNLCoS65dlRbgxiVMzLtME4GS39wVBeLljGpViQ3P
         9fFu7ZDjoiGyuT6pbFZUVxwCMx/sa97+9IuGVxOkz+T95mLTqTpCZ2tpVsdspZGQ8EcW
         jr8p+dz5VHCX4h1aZkki72Nuek0+DR9xrg3RwUc1lg99Hyl8wvHnD4uJ0DcSCZVA71nN
         JhjT7TaaMOCTI8sfsLaZHKsNVfiXyxaefrvouk6ZjrJLsx+bGcBWjAuq1uPfmM8QBsft
         Cb1Q==
X-Gm-Message-State: APjAAAWywwGpDpybj5+tjPzH/hpTlQH/M5Iix3pFsuATv2eBz/1H5BLO
        7FwGKfjoZIQOHQTeDMlva8w=
X-Google-Smtp-Source: APXvYqxRqY++3k3ZQ+HGDavflT5c/nHP8DBNck1gygpnv/6QGY87cWgRNbqDteCxV1VG6A78awt9hg==
X-Received: by 2002:a17:90a:a6e:: with SMTP id o101mr14107810pjo.71.1568518482093;
        Sat, 14 Sep 2019 20:34:42 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id bb15sm3480073pjb.2.2019.09.14.20.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 20:34:41 -0700 (PDT)
Date:   Sun, 15 Sep 2019 11:34:35 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH 2/2] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <20190915033353.GJ2622@desktop>
References: <58163375-dcd9-b954-c8d2-89fef20b8246@gmail.com>
 <20190913173624.GD28512@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913173624.GD28512@bfoster>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 13, 2019 at 01:36:24PM -0400, Brian Foster wrote:
> On Wed, Sep 11, 2019 at 09:17:08PM +0800, kaixuxia wrote:
> > There is ABBA deadlock bug between the AGI and AGF when performing
> > rename() with RENAME_WHITEOUT flag, and add this testcase to make
> > sure the rename() call works well.
> > 
> > Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> > ---
> >  tests/xfs/512     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/512.out |  2 ++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 102 insertions(+)
> >  create mode 100755 tests/xfs/512
> >  create mode 100644 tests/xfs/512.out
> > 
> > diff --git a/tests/xfs/512 b/tests/xfs/512
> > new file mode 100755
> > index 0000000..754f102
> > --- /dev/null
> > +++ b/tests/xfs/512
> > @@ -0,0 +1,99 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2019 Tencent.  All Rights Reserved.
> > +#
> > +# FS QA Test 512
> > +#
> > +# Test the ABBA deadlock case between the AGI and AGF When performing
> > +# rename operation with RENAME_WHITEOUT flag.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/renameat2
> > +
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_scratch_nocheck
> 
> Why _nocheck? AFAICT the filesystem shouldn't end up intentionally
> corrupted.

There was a comment in v1, but not in this v2, we should keep that
comment.

> 
> > +_requires_renameat2 whiteout
> > +
> > +prepare_file()
> > +{
> > +	# create many small files for the rename with RENAME_WHITEOUT
> > +	i=0
> > +	while [ $i -le $files ]; do
> > +		file=$SCRATCH_MNT/f$i
> > +		echo > $file >/dev/null 2>&1
> > +		let i=$i+1
> > +	done
> 
> Something like the following is a bit more simple, IMO:
> 
> 	for i in $(seq 1 $files); do
> 		touch $SCRATCH_MNT/f.$i
> 	done
> 
> The same goes for the other while loops below that increment up to
> $files.

Agreed, but looks like echo (which is a bash builtin) is faster than
touch (which requires forking new process every loop).

> 
> > +}
> > +
> > +rename_whiteout()
> > +{
> > +	# create the rename targetdir
> > +	renamedir=$SCRATCH_MNT/renamedir
> > +	mkdir $renamedir
> > +
> > +	# a long filename could increase the possibility that target_dp
> > +	# allocate new blocks(acquire the AGF lock) to store the filename
> > +	longnamepre=FFFsafdsagafsadfagasdjfalskdgakdlsglkasdg
> > +
> 
> The max filename length is 256 bytes. You could do something like the
> following to increase name length (leaving room for the file index and
> terminating NULL) if it helps the test:
> 
> 	prefix=`for i in $(seq 0 245); do echo -n a; done`

Or

	prefix=`$PERL_PROG -e 'print "a"x256;'`

? Which seems a bit simpler to me.

> 
> > +	# now try to do rename with RENAME_WHITEOUT flag
> > +	i=0
> > +	while [ $i -le $files ]; do
> > +		src/renameat2 -w $SCRATCH_MNT/f$i $renamedir/$longnamepre$i >/dev/null 2>&1
> > +		let i=$i+1
> > +	done
> > +}
> > +
> > +create_file()
> > +{
> > +	# create the targetdir
> > +	createdir=$SCRATCH_MNT/createdir
> > +	mkdir $createdir
> > +
> > +	# try to create file at the same time to hit the deadlock
> > +	i=0
> > +	while [ $i -le $files ]; do
> > +		file=$createdir/f$i
> > +		echo > $file >/dev/null 2>&1
> > +		let i=$i+1
> > +	done
> > +}
> 
> You could generalize this function to take a target directory parameter
> and just call it twice (once to prepare and again for the create
> workload).
> 
> > +
> > +_scratch_mkfs_xfs -bsize=1024 -dagcount=1 >> $seqres.full 2>&1 ||
> > +	_fail "mkfs failed"
> 
> Why -bsize=1k? Does that make the reproducer more effective?
> 
> > +_scratch_mount
> > +
> > +files=250000
> > +
> 
> Have you tested effectiveness of reproducing the issue with smaller file
> counts? A brief comment here to document where the value comes from
> might be useful. Somewhat related, how long does this test take on fixed
> kernels?
> 
> > +prepare_file
> > +rename_whiteout &
> > +create_file &
> > +
> > +wait
> > +echo Silence is golden
> > +
> > +# Failure comes in the form of a deadlock.
> > +
> 
> I wonder if this should be in the dangerous group as well. I go back and
> forth on that though because I tend to filter out dangerous tests and
> the test won't be so risky once the fix proliferates. Perhaps that's
> just a matter of removing it from the dangerous group after a long
> enough period of time.

The deadlock has been fixed, so I think it's fine to leave dangerous
group.

> 
> Brian

Thanks a lot for the review!

Eryu

> 
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/512.out b/tests/xfs/512.out
> > new file mode 100644
> > index 0000000..0aabdef
> > --- /dev/null
> > +++ b/tests/xfs/512.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 512
> > +Silence is golden
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index a7ad300..ed250d6 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -509,3 +509,4 @@
> >  509 auto ioctl
> >  510 auto ioctl quick
> >  511 auto quick quota
> > +512 auto rename
> > -- 
> > 1.8.3.1
> > 
> > -- 
> > kaixuxia
