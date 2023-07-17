Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3702DC0015E
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jul 2023 03:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjGQDEF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 Jul 2023 23:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjGQDD6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Jul 2023 23:03:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE55B113
        for <linux-xfs@vger.kernel.org>; Sun, 16 Jul 2023 20:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689562991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ohf9oTE8PoNQM+gBA+nwQjAZJRHtXYuggoi5MTM7ouA=;
        b=Hw7HM4RU+woz+dmdLoj1PZVPe8zIdBQ+gqpbsyRGQQy+q0M7+HJyta3wVlBHoDgkk9gKvA
        bUba3mqIXl4FNeuunhBK1y4XQhHex7u3NbS0yMKr/RJHkJWWolatzNkrKgvW4JknetDgPc
        DxNneLr9SbIvUku2gtMQocYNFd+Cf+8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-p0AvoNVTOKi1NYqrSjTFCQ-1; Sun, 16 Jul 2023 23:03:09 -0400
X-MC-Unique: p0AvoNVTOKi1NYqrSjTFCQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b8af49a5d2so32207045ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 16 Jul 2023 20:03:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689562988; x=1692154988;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohf9oTE8PoNQM+gBA+nwQjAZJRHtXYuggoi5MTM7ouA=;
        b=KQch0yM4FoITTHx9hTEoX9hukuww5iwe37mLVn07m4e3RqzD3tBAdWrfRplyR9v27D
         MJ+3AgdVgI7GBaslH6YzVLowjG49WP571tFDL+E1EmFqTzURuL5hGdR3E2r+QPc+eSVx
         tJF7Hu55vuDfsKfFjyX/OqDtVKwmnsWsSGd5Y0ecURT7mCT0AGC+gpbTpEBTawUPOYGb
         JFWgZhjPErHf63IMhcAYmeGXicvhfILnirWQVIBmqIt0C+qlOwugOjbNT6jk3nUjfB/s
         /Bjx4dz+aJdg/udt44agQqKh3vnA7UyGXp/mldTpgs+AziaIPz6To4z4LYl8k8pz2Cnr
         NDrw==
X-Gm-Message-State: ABy/qLb47Wymx42/RghY3sMjRiihk8KgruN7KxdU1g2rETcWNlrF3DiW
        CwbUJ9pSrwMci46adGQFdgEJfczRDJb8Qy5hd2+8dK2lu9RLsmYfScL3AToCSbckk86mf49+raj
        5HX3rP5qVOcmwQFyaheCl
X-Received: by 2002:a17:903:32c9:b0:1b8:9598:6508 with SMTP id i9-20020a17090332c900b001b895986508mr15969565plr.18.1689562988521;
        Sun, 16 Jul 2023 20:03:08 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFjIVdnxQL4YXmYK6fefJwo/CmOB2L4VfbDTw32sAIHT2Xg0S8EWdBTcFEGuH8pSVYWzEay6g==
X-Received: by 2002:a17:903:32c9:b0:1b8:9598:6508 with SMTP id i9-20020a17090332c900b001b895986508mr15969552plr.18.1689562988233;
        Sun, 16 Jul 2023 20:03:08 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jc6-20020a17090325c600b001b2069072ccsm11602636plb.18.2023.07.16.20.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jul 2023 20:03:07 -0700 (PDT)
Date:   Mon, 17 Jul 2023 11:03:03 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        mpatocka@redhat.com
Subject: Re: [PATCH] generic/558: avoid forkbombs on filesystems with many
 free inodes
Message-ID: <20230717030303.i3stvautu3oh55ao@zlang-mailbox>
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

Has the $loop been removed?


> -while [ $i -lt $loop ]; do
> -	create_file $SCRATCH_MNT/testdir $file_per_dir $i >>$seqres.full 2>&1 &
> -	let i=$i+1
> +for ((i = 0; i < nr_cpus; i++)); do
> +	create_file $SCRATCH_MNT/testdir $files_per_dir $i >>$seqres.full 2>&1 &
>  done
>  wait
>  
> 

