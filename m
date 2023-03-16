Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D66FC6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 06:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCPGIx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 02:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCPGIw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 02:08:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E9A5FE4
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 23:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678946879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V//LGh9wLKO/AamrlpL73WrxUlPrMOZPEPMNvHPRKqk=;
        b=NTyuecsFwsBD3FD/AvK975YhYYkI0+DJoqXjijX0jvASi9KBk9wcSP6JSeTh9j0QJx7fRd
        Azr/vG64MlNRWu/zeeGleI3mx5AT0FnpDVTgTxktu6CHCsSFzy+1zEDNv9T+IKntliJMNw
        +xdLVbXfU1cxAKfydESZ5d+5tfOMA9k=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-LuY8P-gSNtKUlxlilVRSzg-1; Thu, 16 Mar 2023 02:07:57 -0400
X-MC-Unique: LuY8P-gSNtKUlxlilVRSzg-1
Received: by mail-pj1-f70.google.com with SMTP id d5-20020a17090a7bc500b0023d3366e005so309685pjl.6
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 23:07:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678946876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V//LGh9wLKO/AamrlpL73WrxUlPrMOZPEPMNvHPRKqk=;
        b=aapCjDYXmgruVy1fBY/BJU2QiXOigGnjgnGiH1mTwM3M64+Wm1+oN5uXbRpCoQ1MrW
         NpDh9idTjbJwaVF/UhE1BAX7vVJTflwRSpqVyGm3sbuBP4u9lLwlFfcSBU50W3W91fJ+
         NamJIEgZ6qmSL2Ww8QaJKuTadxj1oKFa4wAbVhdejVJvBmO8LFas89Yi1BPSLmrKk35e
         6RLT5bcn60ObAyI6ZCvungC7o27eMm6SVUP2PjdNm83uLwav9irQZjDY7ON6RJAWRtWK
         pKBOl0L8S7sz1neRY3nfLG7AsPeHM2qF5xgmMvmDvVMaDiGXLvFs0KNUo3vpLa5n0Isc
         j5Bg==
X-Gm-Message-State: AO0yUKX0TPcGscMl10wS4G1rX8tu8/2pbzurt0Cg0a8arGW8VEyEi707
        ltluOOYltJT2qjY8LPGQkX3bCyuEGk8MflKlf6DTswNJLS4I5sf3tfTZdm/NNc6Jl64jDAg3LB2
        Zo82x9rhj1drkbj5L4hI5dVGpzcKlpME=
X-Received: by 2002:a05:6a20:431c:b0:d3:e6c9:8f13 with SMTP id h28-20020a056a20431c00b000d3e6c98f13mr2378974pzk.10.1678946876269;
        Wed, 15 Mar 2023 23:07:56 -0700 (PDT)
X-Google-Smtp-Source: AK7set85CkYpg4rnp8sIvfLGhNsrDM20NqjS9Jk0Sn17VtAQLQVAxXHm68Aoous1MAzSh5XD3EGLTA==
X-Received: by 2002:a05:6a20:431c:b0:d3:e6c9:8f13 with SMTP id h28-20020a056a20431c00b000d3e6c98f13mr2378940pzk.10.1678946875760;
        Wed, 15 Mar 2023 23:07:55 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a11-20020aa780cb000000b0059435689e36sm4629383pfn.170.2023.03.15.23.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 23:07:55 -0700 (PDT)
Date:   Thu, 16 Mar 2023 14:07:51 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: stress test cycling parent pointers with online
 repair
Message-ID: <20230316060751.or7qi2i3qijprw6x@zlang-mailbox>
References: <20230315005817.GA11360@frogsfrogsfrogs>
 <20230315180206.3zqiiooqepiyg35c@zlang-mailbox>
 <20230315211730.GG11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315211730.GG11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 15, 2023 at 02:17:30PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 16, 2023 at 02:02:06AM +0800, Zorro Lang wrote:
> > On Tue, Mar 14, 2023 at 05:58:17PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Add a couple of new tests to exercise directory and parent pointer
> > > repair against rename() calls moving child subdirectories from one
> > > parent to another.  This is a useful test because it turns out that the
> > > VFS doesn't lock the child subdirectory (it does lock the parents), so
> > > repair must be more careful.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > This patchset looks good to me.
> > 
> > Two questions before acking this patch:
> > 1) The 2nd case fails [1] on mainline linux and xfsprogs, but test passed on
> > your djwong linux and xfsprogs repo. Is this expected? Is it a known issue
> > you've fixed in your repo?
> 
> Yes.  These two new 854/855 tests are a result of Jan Kara pointing out
> that if you do this:
> 
> mkdir -p /tmp/a
> mv /tmp/a /mnt/
> 
> The VFS won't lock /tmp/a while it does the rename.  The upstream parent
> pointer checking code (which is really a dotdot checker) assumes that
> holding *only* i_rwsem is sufficient to prevent directory updates, which
> isn't true, and so the parent pointer checker emits false corruption
> reports.

Oh, that's it. Thanks for your explanation.

> 
> All of that is fixed in djwong-dev.
> 
> > 2) I remember there was a patchset [1] (from your team too) about parent pointer
> > test half years ago. I've reviewed its 3rd version, but no more response anymore.
> > Just curious, do you drop that patchset ? Or you hope to send it again after
> > xfsprogs and kernel support that feature? If dropped, I'll remove it from my
> > pending list :)
> 
> It'll be back (soonish, I hope) once we finish nailing down the ondisk
> format and fixing up all the minor problems.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-ioctl-flexarray

Good to know that. No push, just ask the plan.

Now this patch is good to me, I'll merge it in next fstests release (this weekend).

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > [1]
> > xfs/855 33s ... _check_xfs_filesystem: filesystem on /dev/sda3 failed health check
> > (see /root/git/xfstests/results//simpledev/xfs/855.full for details)
> > - output mismatch (see /root/git/xfstests/results//simpledev/xfs/855.out.bad)
> >     --- tests/xfs/855.out       2023-03-16 00:47:28.256187590 +0800
> >     +++ /root/git/xfstests/results//simpledev/xfs/855.out.bad   2023-03-16 01:42:25.764902276 +0800
> >     @@ -1,2 +1,37 @@
> >      QA output created by 855
> >     +xfs_scrub reports uncorrected errors:
> >     +Corruption: inode 100663424 (12/128) parent pointer: Repairs are required. (scrub.c line 190)
> >     +Corruption: inode 125829312 (15/192) parent pointer: Repairs are required. (scrub.c line 190)
> >     +xfs_scrub reports uncorrected errors:
> >     +Corruption: inode 117440647 (14/135) parent pointer: Repairs are required. (scrub.c line 190)
> >     +xfs_scrub reports uncorrected errors:
> >     ...
> >     (Run 'diff -u /root/git/xfstests/tests/xfs/855.out /root/git/xfstests/results//simpledev/xfs/855.out.bad'  to see the entire diff)
> > Ran: xfs/854 xfs/855
> > Failures: xfs/855
> > Failed 1 of 2 tests
> > 
> > [2]
> > [PATCH v3 0/4] xfstests: add parent pointer tests
> > https://lore.kernel.org/fstests/20221028215605.17973-1-catherine.hoang@oracle.com/
> > 
> > 
> > 
> > >  common/fuzzy      |   15 +++++++++++++++
> > >  tests/xfs/854     |   38 ++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/854.out |    2 ++
> > >  tests/xfs/855     |   38 ++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/855.out |    2 ++
> > >  5 files changed, 95 insertions(+)
> > >  create mode 100755 tests/xfs/854
> > >  create mode 100644 tests/xfs/854.out
> > >  create mode 100755 tests/xfs/855
> > >  create mode 100644 tests/xfs/855.out
> > > 
> > > diff --git a/common/fuzzy b/common/fuzzy
> > > index 4609df4434..744d9ed65d 100644
> > > --- a/common/fuzzy
> > > +++ b/common/fuzzy
> > > @@ -995,6 +995,20 @@ __stress_scrub_fsstress_loop() {
> > >  	local focus=()
> > >  
> > >  	case "$stress_tgt" in
> > > +	"parent")
> > > +		focus+=('-z')
> > > +
> > > +		# Create a directory tree very gradually
> > > +		for op in creat link mkdir; do
> > > +			focus+=('-f' "${op}=2")
> > > +		done
> > > +		focus+=('-f' 'unlink=1' '-f' 'rmdir=1')
> > > +
> > > +		# But do a lot of renames to cycle parent pointers
> > > +		for op in rename rnoreplace rexchange; do
> > > +			focus+=('-f' "${op}=40")
> > > +		done
> > > +		;;
> > >  	"dir")
> > >  		focus+=('-z')
> > >  
> > > @@ -1285,6 +1299,7 @@ __stress_scrub_check_commands() {
> > >  #       'writeonly': Only perform fs updates, no reads.
> > >  #       'symlink': Only create symbolic links.
> > >  #       'mknod': Only create special files.
> > > +#       'parent': Focus on updating parent pointers
> > >  #
> > >  #       The default is 'default' unless XFS_SCRUB_STRESS_TARGET is set.
> > >  # -X	Run this program to exercise the filesystem.  Currently supported
> > > diff --git a/tests/xfs/854 b/tests/xfs/854
> > > new file mode 100755
> > > index 0000000000..0aa2c2ee4f
> > > --- /dev/null
> > > +++ b/tests/xfs/854
> > > @@ -0,0 +1,38 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2023 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 854
> > > +#
> > > +# Race fsstress doing mostly renames and xfs_scrub in force-repair mode for a
> > > +# while to see if we crash or livelock.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest online_repair dangerous_fsstress_repair
> > > +
> > > +_cleanup() {
> > > +	cd /
> > > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > > +	rm -r -f $tmp.*
> > > +}
> > > +_register_cleanup "_cleanup" BUS
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/fuzzy
> > > +. ./common/inject
> > > +. ./common/xfs
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_xfs_stress_online_repair
> > > +
> > > +_scratch_mkfs > "$seqres.full" 2>&1
> > > +_scratch_mount
> > > +_scratch_xfs_stress_online_repair -S '-k' -x 'parent'
> > > +
> > > +# success, all done
> > > +echo Silence is golden
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/854.out b/tests/xfs/854.out
> > > new file mode 100644
> > > index 0000000000..f8d9e27958
> > > --- /dev/null
> > > +++ b/tests/xfs/854.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 854
> > > +Silence is golden
> > > diff --git a/tests/xfs/855 b/tests/xfs/855
> > > new file mode 100755
> > > index 0000000000..6daff05995
> > > --- /dev/null
> > > +++ b/tests/xfs/855
> > > @@ -0,0 +1,38 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2023 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 855
> > > +#
> > > +# Race fsstress doing mostly renames and xfs_scrub in read-only mode for a
> > > +# while to see if we crash or livelock.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest scrub dangerous_fsstress_scrub
> > > +
> > > +_cleanup() {
> > > +	cd /
> > > +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> > > +	rm -r -f $tmp.*
> > > +}
> > > +_register_cleanup "_cleanup" BUS
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/fuzzy
> > > +. ./common/inject
> > > +. ./common/xfs
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_xfs_stress_scrub
> > > +
> > > +_scratch_mkfs > "$seqres.full" 2>&1
> > > +_scratch_mount
> > > +_scratch_xfs_stress_scrub -S '-n' -x 'parent'
> > > +
> > > +# success, all done
> > > +echo Silence is golden
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/855.out b/tests/xfs/855.out
> > > new file mode 100644
> > > index 0000000000..fa60f65432
> > > --- /dev/null
> > > +++ b/tests/xfs/855.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 855
> > > +Silence is golden
> > > 
> > 
> 

