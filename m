Return-Path: <SRS0=NVxF=XK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA02C4CEC7
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Sep 2019 13:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9B1E214C6
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Sep 2019 13:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pyqZZT0f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfION1i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Sep 2019 09:27:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40028 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731308AbfION1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Sep 2019 09:27:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so20842268pfb.7;
        Sun, 15 Sep 2019 06:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GBiACRoPRzgWijcctVRk+mfGCsihXLkUdEKYSyWQ4SU=;
        b=pyqZZT0fRKPGjoPj+3plf3rK0NJkVT+TYC8R9FiG9dNVi+6APsTanSsDQNVdCDAXk/
         e7Wu2xw951VNO8POQ2zPvBfyuORJTiQ/YR27SEuT+SLmFhfOJ34a/ew1PB8WSKkB8txc
         jOoHwtvmJgvFr/sAb/KGaoQmhfljy6pZHo62ichHOqgpY92EbQ7gmhQo9Ht+1o635lJ8
         VLY7KNDzGXb7z37sNcfZojQ0kdhBbT9DABYD3grFVBiMO1slzUNiKwjAy4tQ7uP5MDCD
         M+/eVlcAtSDMf6LvQhr1VVYCK+cPaD4zlyN0tw+DAQi8J10GubNo2jFOAsv3jljC3mh5
         kz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GBiACRoPRzgWijcctVRk+mfGCsihXLkUdEKYSyWQ4SU=;
        b=NRUEIm+CNbvgqs+l4WZJYdV918HZ5mJ4TIlqoS5tYaKFZnj1rHpckMJGn8yS3VxLab
         WuYlW1mEdvEo2NdfJqha3spehT5fvzhCWE17kKA1n9anPqulkPUWzZTCpkMlhieBW+vK
         UrJaBbPOX7ehooA6pgBDU6SMcIchvwK7fp9VAN+sm2OTz8DFMkX+LiDNV1uUibDSYJmJ
         xd077xC2YP4x4M4+sbI9/sHysxUwuJGQxzY363wXw7FSAXBYN3+XQFowY7zozDZZlXwo
         0d/lav/sns0YFINeCLiN38SLT8Kwy1St+kZd7ElcbY65ETEOWQfxEYuxBUKt3apOioM3
         gLIg==
X-Gm-Message-State: APjAAAWvSaqRGjUXQmWtDBwZQmeALHGvk6ULQUEZe19Qg5t5pIfnvrQZ
        xuVw65Gk48y3AjgCTW2tBI0=
X-Google-Smtp-Source: APXvYqxHU2ovQ1dVT5koLS3UcVbMFBv2l41wbVPbgGD9GXKiUrt1FC12xLETmXFZ+L25M69uRuZubg==
X-Received: by 2002:a17:90a:9ab:: with SMTP id 40mr15804860pjo.38.1568554057016;
        Sun, 15 Sep 2019 06:27:37 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id x13sm36283248pfm.157.2019.09.15.06.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2019 06:27:35 -0700 (PDT)
Date:   Sun, 15 Sep 2019 21:27:29 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH 2/2] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <20190915132708.GN2622@desktop>
References: <58163375-dcd9-b954-c8d2-89fef20b8246@gmail.com>
 <20190913173624.GD28512@bfoster>
 <20190915033353.GJ2622@desktop>
 <20190915114751.GA37752@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190915114751.GA37752@bfoster>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 15, 2019 at 07:47:51AM -0400, Brian Foster wrote:
> On Sun, Sep 15, 2019 at 11:34:35AM +0800, Eryu Guan wrote:
> > On Fri, Sep 13, 2019 at 01:36:24PM -0400, Brian Foster wrote:
> > > On Wed, Sep 11, 2019 at 09:17:08PM +0800, kaixuxia wrote:
> > > > There is ABBA deadlock bug between the AGI and AGF when performing
> > > > rename() with RENAME_WHITEOUT flag, and add this testcase to make
> > > > sure the rename() call works well.
> > > > 
> > > > Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> > > > ---
> > > >  tests/xfs/512     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/512.out |  2 ++
> > > >  tests/xfs/group   |  1 +
> > > >  3 files changed, 102 insertions(+)
> > > >  create mode 100755 tests/xfs/512
> > > >  create mode 100644 tests/xfs/512.out
> > > > 
> > > > diff --git a/tests/xfs/512 b/tests/xfs/512
> > > > new file mode 100755
> > > > index 0000000..754f102
> > > > --- /dev/null
> > > > +++ b/tests/xfs/512
> > > > @@ -0,0 +1,99 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2019 Tencent.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test 512
> > > > +#
> > > > +# Test the ABBA deadlock case between the AGI and AGF When performing
> > > > +# rename operation with RENAME_WHITEOUT flag.
> > > > +#
> > > > +seq=`basename $0`
> > > > +seqres=$RESULT_DIR/$seq
> > > > +echo "QA output created by $seq"
> > > > +
> > > > +here=`pwd`
> > > > +tmp=/tmp/$$
> > > > +status=1	# failure is the default!
> > > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	cd /
> > > > +	rm -f $tmp.*
> > > > +}
> > > > +
> > > > +# get standard environment, filters and checks
> > > > +. ./common/rc
> > > > +. ./common/filter
> > > > +. ./common/renameat2
> > > > +
> > > > +rm -f $seqres.full
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs xfs
> > > > +_supported_os Linux
> > > > +_require_scratch_nocheck
> > > 
> > > Why _nocheck? AFAICT the filesystem shouldn't end up intentionally
> > > corrupted.
> > 
> > There was a comment in v1, but not in this v2, we should keep that
> > comment.
> > 
> > > 
> > > > +_requires_renameat2 whiteout
> > > > +
> > > > +prepare_file()
> > > > +{
> > > > +	# create many small files for the rename with RENAME_WHITEOUT
> > > > +	i=0
> > > > +	while [ $i -le $files ]; do
> > > > +		file=$SCRATCH_MNT/f$i
> > > > +		echo > $file >/dev/null 2>&1
> > > > +		let i=$i+1
> > > > +	done
> > > 
> > > Something like the following is a bit more simple, IMO:
> > > 
> > > 	for i in $(seq 1 $files); do
> > > 		touch $SCRATCH_MNT/f.$i
> > > 	done
> > > 
> > > The same goes for the other while loops below that increment up to
> > > $files.
> > 
> > Agreed, but looks like echo (which is a bash builtin) is faster than
> > touch (which requires forking new process every loop).
> > 
> 
> Ah, interesting. I suppose that makes sense if there's tangible benefit.
> Would that benefit stand if we created an internal _touch helper or some
> such instead of open-coding it everywhere?

IMHO, creating a _touch helper doesn't gain much than open-coding it,
it's probably just a one-liner helper anyway.

> 
> > > 
> > > > +}
> > > > +
> > > > +rename_whiteout()
> > > > +{
> > > > +	# create the rename targetdir
> > > > +	renamedir=$SCRATCH_MNT/renamedir
> > > > +	mkdir $renamedir
> > > > +
> > > > +	# a long filename could increase the possibility that target_dp
> > > > +	# allocate new blocks(acquire the AGF lock) to store the filename
> > > > +	longnamepre=FFFsafdsagafsadfagasdjfalskdgakdlsglkasdg
> > > > +
> > > 
> > > The max filename length is 256 bytes. You could do something like the
> > > following to increase name length (leaving room for the file index and
> > > terminating NULL) if it helps the test:
> > > 
> > > 	prefix=`for i in $(seq 0 245); do echo -n a; done`
> > 
> > Or
> > 
> > 	prefix=`$PERL_PROG -e 'print "a"x256;'`
> > 
> > ? Which seems a bit simpler to me.
> > 
> > > 
> > > > +	# now try to do rename with RENAME_WHITEOUT flag
> > > > +	i=0
> > > > +	while [ $i -le $files ]; do
> > > > +		src/renameat2 -w $SCRATCH_MNT/f$i $renamedir/$longnamepre$i >/dev/null 2>&1
> > > > +		let i=$i+1
> > > > +	done
> > > > +}
> > > > +
> > > > +create_file()
> > > > +{
> > > > +	# create the targetdir
> > > > +	createdir=$SCRATCH_MNT/createdir
> > > > +	mkdir $createdir
> > > > +
> > > > +	# try to create file at the same time to hit the deadlock
> > > > +	i=0
> > > > +	while [ $i -le $files ]; do
> > > > +		file=$createdir/f$i
> > > > +		echo > $file >/dev/null 2>&1
> > > > +		let i=$i+1
> > > > +	done
> > > > +}
> > > 
> > > You could generalize this function to take a target directory parameter
> > > and just call it twice (once to prepare and again for the create
> > > workload).
> > > 
> > > > +
> > > > +_scratch_mkfs_xfs -bsize=1024 -dagcount=1 >> $seqres.full 2>&1 ||
> > > > +	_fail "mkfs failed"
> > > 
> > > Why -bsize=1k? Does that make the reproducer more effective?
> > > 
> > > > +_scratch_mount
> > > > +
> > > > +files=250000
> > > > +
> > > 
> > > Have you tested effectiveness of reproducing the issue with smaller file
> > > counts? A brief comment here to document where the value comes from
> > > might be useful. Somewhat related, how long does this test take on fixed
> > > kernels?
> > > 
> > > > +prepare_file
> > > > +rename_whiteout &
> > > > +create_file &
> > > > +
> > > > +wait
> > > > +echo Silence is golden
> > > > +
> > > > +# Failure comes in the form of a deadlock.
> > > > +
> > > 
> > > I wonder if this should be in the dangerous group as well. I go back and
> > > forth on that though because I tend to filter out dangerous tests and
> > > the test won't be so risky once the fix proliferates. Perhaps that's
> > > just a matter of removing it from the dangerous group after a long
> > > enough period of time.
> > 
> > The deadlock has been fixed, so I think it's fine to leave dangerous
> > group.
> > 
> 
> Do you mean to leave it in or out?

Don't add 'dangerous' group.

> 
> In general, what's the approach for dealing with dangerous tests that
> are no longer dangerous? Leave them indefinitely or remove them after a
> period of time? I tend to skip dangerous tests on regression runs just
> because I'm not looking for a deadlock or crash to disrupt a long
> running test.

I think the definition of 'dangerous' group is a bit vague over time (at
least to me), I'd define it as 'would crash or hang the test machine and
cause tests to be interrupted & re-run'. So I'd remove them after the
problem is fixed in latest upstream kernel/userspace tools.

And I tend to not add new 'dangerous' tests, as we usually push such
tests to fstests upstream only after the fixes are upstreamed, and only
add new 'dangerous' tests when we know the fix is not going to be there
for the near future.

Thanks,
Eryu
