Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535C4EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 15:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbjGNPO4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 11:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjGNPOx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 11:14:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6675B2D43
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 08:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689347651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q3cA2UOOcR2TLL5+UN6pVf6RDBYDy7np+BK24tgmfA0=;
        b=GC7+82M/OtTA8Zfq8m3CrCKkeM8zfBJW1bOgx2qtgteM9EyZXJHU8AlDTzPML4tAwoVwMx
        1Ja4qpVkADr2Qde/W4ZNiX6luN0mnJQSahw2UeqK6PQMFm8+8wirVx5XD3Dz381ZBAi8yK
        PhPYUfhc9IhUzGAX/LGsNZGg9Po4t4w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-_qZjBJ_SMV6p-8lEhXPYuw-1; Fri, 14 Jul 2023 11:14:10 -0400
X-MC-Unique: _qZjBJ_SMV6p-8lEhXPYuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85D0580027F;
        Fri, 14 Jul 2023 15:14:09 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3380C1454142;
        Fri, 14 Jul 2023 15:14:09 +0000 (UTC)
Date:   Fri, 14 Jul 2023 10:14:07 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, mpatocka@redhat.com
Subject: Re: [PATCH] generic/558: avoid forkbombs on filesystems with many
 free inodes
Message-ID: <ZLFmPyYOSSzsDamk@redhat.com>
References: <20230714145900.GM11442@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714145900.GM11442@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

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
> 

