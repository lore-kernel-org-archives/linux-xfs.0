Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCF7C0015E
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jul 2023 15:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjGQP2b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jul 2023 11:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbjGQP1z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2023 11:27:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7533B1981;
        Mon, 17 Jul 2023 08:27:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D86B0610F4;
        Mon, 17 Jul 2023 15:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C35C433C9;
        Mon, 17 Jul 2023 15:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689607641;
        bh=vEkCPmlJXf55N+JwD1MFNsxxP9a3sITW3xFdPQpMDYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G6vxHdjVbShYLWwxDDd/kvmyLYlTvxoedfH/sYjmV0M1hDuPcumcOYjOeb97OPv5H
         IzSm1tDGkdq0enWdEURxkHCrVpA4DC62BSSYJhFHldwQCQKBIDPh0oOk+ri+/4VyuC
         3ryY69jFXu0o2Ck7haucKCwq3X77H/oRW17ns1v3aQBjlCen9FniKQXNYUEfpO+san
         Se2gXL2LU1uRcwvIJ8F+GVWzoa/ZLqs1x6xlcBvzPvHKiou43duPH/6MENAnVkoNJ5
         wP1KvFpF98Z/sTWtrTBxxfbbvslD9u6LYcB1mf2q/OutJzRGkGnVgwAW/UGupsHqdn
         Ms0V+P/X3jcVQ==
Date:   Mon, 17 Jul 2023 08:27:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        mpatocka@redhat.com
Subject: Re: [PATCH] generic/558: avoid forkbombs on filesystems with many
 free inodes
Message-ID: <20230717152720.GB11340@frogsfrogsfrogs>
References: <20230714145900.GM11442@frogsfrogsfrogs>
 <20230717030303.i3stvautu3oh55ao@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717030303.i3stvautu3oh55ao@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 17, 2023 at 11:03:03AM +0800, Zorro Lang wrote:
> On Fri, Jul 14, 2023 at 07:59:00AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Mikulas reported that this test became a forkbomb on his system when he
> > tested it with bcachefs.  Unlike XFS and ext4, which have large inodes
> > consuming hundreds of bytes, bcachefs has very tiny ones.  Therefore, it
> > reports a large number of free inodes on a freshly mounted 1GB fs (~15
> > million), which causes this test to try to create 15000 processes.
> > 
> > There's really no reason to do that -- all this test wanted to do was to
> > exhaust the number of inodes as quickly as possible using all available
> > CPUs, and then it ran xfs_repair to try to reproduce a bug.  Set the
> > number of subshells to 4x the CPU count and spread the work among them
> > instead of forking thousands of processes.
> > 
> > Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Tested-by: Mikulas Patocka <mpatocka@redhat.com>
> > ---
> >  tests/generic/558 |   18 ++++++++++++------
> >  1 file changed, 12 insertions(+), 6 deletions(-)
> > 
> > diff --git a/tests/generic/558 b/tests/generic/558
> > index 4e22ce656b..de5c28d00d 100755
> > --- a/tests/generic/558
> > +++ b/tests/generic/558
> > @@ -39,15 +39,21 @@ _scratch_mkfs_sized $((1024 * 1024 * 1024)) >>$seqres.full 2>&1
> >  _scratch_mount
> >  
> >  i=0
> > -free_inode=`_get_free_inode $SCRATCH_MNT`
> > -file_per_dir=1000
> > -loop=$((free_inode / file_per_dir + 1))
> > +free_inodes=$(_get_free_inode $SCRATCH_MNT)
> > +nr_cpus=$(( $($here/src/feature -o) * 4 * LOAD_FACTOR ))
> > +echo "free inodes: $free_inodes nr_cpus: $nr_cpus" >> $seqres.full
> > +
> > +if ((free_inodes <= nr_cpus)); then
> > +	nr_cpus=1
> > +	files_per_dir=$free_inodes
> > +else
> > +	files_per_dir=$(( (free_inodes + nr_cpus - 1) / nr_cpus ))
> > +fi
> >  mkdir -p $SCRATCH_MNT/testdir
> >  
> >  echo "Create $((loop * file_per_dir)) files in $SCRATCH_MNT/testdir" >>$seqres.full
> 
> Has the $loop been removed?

DOH.  v3 on the way.  I hate bash.

--D

> > -while [ $i -lt $loop ]; do
> > -	create_file $SCRATCH_MNT/testdir $file_per_dir $i >>$seqres.full 2>&1 &
> > -	let i=$i+1
> > +for ((i = 0; i < nr_cpus; i++)); do
> > +	create_file $SCRATCH_MNT/testdir $files_per_dir $i >>$seqres.full 2>&1 &
> >  done
> >  wait
> >  
> > 
> 
