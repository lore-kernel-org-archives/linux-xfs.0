Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155F6C001DE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jul 2023 01:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjGRBCr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jul 2023 21:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjGRBCn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2023 21:02:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D249DE2;
        Mon, 17 Jul 2023 18:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FECD6136A;
        Tue, 18 Jul 2023 01:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFBAC433C8;
        Tue, 18 Jul 2023 01:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689642158;
        bh=FPYe57f7Bq6ZSPdNfnTBTNk/HEw6uH4qtAhkPRjB6ZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H+zlMy3pICI9z5mOEj/k4wv+/g5g3tNYmphUAfWLjVUP1Y1hhIrzOkSB1OLHEj4oP
         ulBGwu37QHZl9uJllRboW4tgiPik7uGBi5S3jxbJ2Jt8xdkrq8Bq37Zh+q7CMFSshr
         Xu6xrIbn+6RAG8f+dWvR4uyRYTRQZ2+FltElkLDGy4DhL+RPS1P4W7Gjg30vCZDeRa
         PoJS8tq4elLXN6geA3Qzdr67hERkagHv7TmglU0C37H3Z9SEH8iYswUasu76eFehoJ
         YMEyZ/iTY0680Y/v6HDM9vwK7zkHY41K+zbT++RPQeYF7e6kYvOJawhoOA1M7tDSck
         OqlTWjfTgwpTQ==
Date:   Mon, 17 Jul 2023 18:02:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        mpatocka@redhat.com
Subject: Re: [PATCH] generic/558: avoid forkbombs on filesystems with many
 free inodes
Message-ID: <20230718010238.GA11352@frogsfrogsfrogs>
References: <20230714145900.GM11442@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714145900.GM11442@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 14, 2023 at 07:59:00AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Mikulas reported that this test became a forkbomb on his system when he
> tested it with bcachefs.  Unlike XFS and ext4, which have large inodes
> consuming hundreds of bytes, bcachefs has very tiny ones.  Therefore, it
> reports a large number of free inodes on a freshly mounted 1GB fs (~15
> million), which causes this test to try to create 15000 processes.
> 
> There's really no reason to do that -- all this test wanted to do was to
> exhaust the number of inodes as quickly as possible using all available
> CPUs, and then it ran xfs_repair to try to reproduce a bug.  Set the
> number of subshells to 4x the CPU count and spread the work among them
> instead of forking thousands of processes.
> 
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Tested-by: Mikulas Patocka <mpatocka@redhat.com>
> ---
>  tests/generic/558 |   18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/tests/generic/558 b/tests/generic/558
> index 4e22ce656b..de5c28d00d 100755
> --- a/tests/generic/558
> +++ b/tests/generic/558
> @@ -39,15 +39,21 @@ _scratch_mkfs_sized $((1024 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>  
>  i=0
> -free_inode=`_get_free_inode $SCRATCH_MNT`
> -file_per_dir=1000
> -loop=$((free_inode / file_per_dir + 1))

NAK.  Here, the old code effectively does:

loop = howmany(free_inode, 1000);
for i in 0...loop:
	create_file ... 1000files... &

IOWs, it rounds the number of files to create up to the nearest 1000,
which I overlooked because I was overloaded and words are easier than
resurrecting mathematical concepts from raw formulae.

If, say, the 1G fs claims to have 524,288 free inodes, the test will
start *525* create_file subshells to create 1000 files each, or 525,000
files.

The /new/ code does this instead:

nr_cpus=(cpu count * 4)
files_per_dir = howmany(free_inodes, nr_cpus)
for i in 0..nr_cpus:
	create_file ... files_per_dir... &

If nr_cpu is a factor of free_inodes, we don't do /any/ roundup at all.
524,288 free inodes with 4 CPUs gets you 16 threads and 32768 files per
thread.

Apparently this is significant somehow, because on a lark I decided to
revert the referenced commit and the new code doesn't reliably
reproduce the failure when parent pointers are enabled.

Reintroducing the "rounding free_inodes up to the nearest 1000" does
make it trip, though.

Sooooo... I'll have a new version out tomorrow after some testing.
Please do not apply this patch until then, unless you are testing
bcachefs.

--D

> +free_inodes=$(_get_free_inode $SCRATCH_MNT)
> +nr_cpus=$(( $($here/src/feature -o) * 4 * LOAD_FACTOR ))
> +echo "free inodes: $free_inodes nr_cpus: $nr_cpus" >> $seqres.full
> +
> +if ((free_inodes <= nr_cpus)); then
> +	nr_cpus=1
> +	files_per_dir=$free_inodes
> +else
> +	files_per_dir=$(( (free_inodes + nr_cpus - 1) / nr_cpus ))
> +fi
>  mkdir -p $SCRATCH_MNT/testdir
>  
>  echo "Create $((loop * file_per_dir)) files in $SCRATCH_MNT/testdir" >>$seqres.full
> -while [ $i -lt $loop ]; do
> -	create_file $SCRATCH_MNT/testdir $file_per_dir $i >>$seqres.full 2>&1 &
> -	let i=$i+1
> +for ((i = 0; i < nr_cpus; i++)); do
> +	create_file $SCRATCH_MNT/testdir $files_per_dir $i >>$seqres.full 2>&1 &
>  done
>  wait
>  
