Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BD4C001E0
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 01:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjGTBkc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjGTBkb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 21:40:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23350172A
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 18:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689817182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OchssuLsI8TgAPpPN1HYvAbN+Zz0angfOEiv64DZQpg=;
        b=YSWiQHocpRboPTg8i3afG7wJ94p/OgQHPxrd4+u9uNcF3AcVT0wWWD8DuYEifIAMHHYFb3
        HmzbIfCqrYesCozIdPwthxR//Ooh2GVkWtkVXLWzn1bwGCg8cytQlIHBhTwCm8zJDTirI/
        Mr/l9hLbeOQ386Y156vNR5srnln9Dms=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-16Zdmj0hMTaI729o-zomfA-1; Wed, 19 Jul 2023 21:39:40 -0400
X-MC-Unique: 16Zdmj0hMTaI729o-zomfA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-262dc0bab18so125756a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 18:39:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689817179; x=1690421979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OchssuLsI8TgAPpPN1HYvAbN+Zz0angfOEiv64DZQpg=;
        b=hswiUN74fw40Fa9D7pOX3xLJqJh4QlrytEF+CcS81+kENVuxhSTa7iHOhbFunLgsPk
         fzijt3lQsQ3CZ9L0rLG6FKVJvSGW7h6GgiMIlweo1uYGx5R9FUuOBaBXELeXEIlv19gV
         rwp54dd9TYQOsXM3IBlsCv3hpngGSxrHLo+fcpIJDFlZJHef8QGIIFR1rIK5ZGO13qq9
         oFQ48j3ziynD0zxvJwh/eGU6YR/I9IbaxJRuYVVDAPmRkTPPfxZy2bes21eTUZtRjhm/
         kuSffSnNcQ8gKV70EH7pD59lFep3TuPqvwwqbT6iF5zE65FeYAAFj956Q0xLAjzqbUi+
         N7ug==
X-Gm-Message-State: ABy/qLYWLo2uUhBMFX07nvWsiBLODEv9xs5gkkI31AADGpVn8nXT0loT
        GM9GV2BDt6pCvmNprXyppOLM2A9IHdzOhN+JigMcxeWzFzQ6igpyuwxO/e2b9hXSC6OGGO6dTrR
        nhgEvtiKLckdpCQZWz0NBzIa3DbADlU0=
X-Received: by 2002:a17:90b:195:b0:265:d6d7:468 with SMTP id t21-20020a17090b019500b00265d6d70468mr676143pjs.24.1689817179327;
        Wed, 19 Jul 2023 18:39:39 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEM44lkwhqKYx3rhW6uGA9TwFBwP1NFM1xjeL//8vKhhOwWCL/UCm/oaQoBbr9Sym4eUoLc8Q==
X-Received: by 2002:a17:90b:195:b0:265:d6d7:468 with SMTP id t21-20020a17090b019500b00265d6d70468mr676134pjs.24.1689817179045;
        Wed, 19 Jul 2023 18:39:39 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o4-20020a17090a420400b002638e5d2986sm1651422pjg.17.2023.07.19.18.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 18:39:38 -0700 (PDT)
Date:   Thu, 20 Jul 2023 09:39:35 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] generic/558: avoid forkbombs on filesystems with
 many free inodes
Message-ID: <20230720013935.vwrqz6kpa2ia2zjk@zlang-mailbox>
References: <168972904158.1698538.17755661226352965399.stgit@frogsfrogsfrogs>
 <168972904731.1698538.2489183241457829688.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168972904731.1698538.2489183241457829688.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2023 at 06:10:47PM -0700, Darrick J. Wong wrote:
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
> Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
> ---

This version is good to me, will merge it.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/558 |   27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/tests/generic/558 b/tests/generic/558
> index 4e22ce656b..510b06f281 100755
> --- a/tests/generic/558
> +++ b/tests/generic/558
> @@ -19,9 +19,8 @@ create_file()
>  	local prefix=$3
>  	local i=0
>  
> -	while [ $i -lt $nr_file ]; do
> +	for ((i = 0; i < nr_file; i++)); do
>  		echo -n > $dir/${prefix}_${i}
> -		let i=$i+1
>  	done
>  }
>  
> @@ -39,15 +38,25 @@ _scratch_mkfs_sized $((1024 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>  
>  i=0
> -free_inode=`_get_free_inode $SCRATCH_MNT`
> -file_per_dir=1000
> -loop=$((free_inode / file_per_dir + 1))
> +free_inodes=$(_get_free_inode $SCRATCH_MNT)
> +# Round the number of inodes to create up to the nearest 1000, like the old
> +# code did to make sure that we *cannot* allocate any more inodes at all.
> +free_inodes=$(( ( (free_inodes + 999) / 1000) * 1000 ))
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
> +echo "nr_cpus: $nr_cpus files_per_dir: $files_per_dir" >> $seqres.full
>  
> -echo "Create $((loop * file_per_dir)) files in $SCRATCH_MNT/testdir" >>$seqres.full
> -while [ $i -lt $loop ]; do
> -	create_file $SCRATCH_MNT/testdir $file_per_dir $i >>$seqres.full 2>&1 &
> -	let i=$i+1
> +echo "Create $((nr_cpus * files_per_dir)) files in $SCRATCH_MNT/testdir" >>$seqres.full
> +for ((i = 0; i < nr_cpus; i++)); do
> +	create_file $SCRATCH_MNT/testdir $files_per_dir $i >>$seqres.full 2>&1 &
>  done
>  wait
>  
> 

