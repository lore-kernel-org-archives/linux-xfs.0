Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE561C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 01:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiCWBid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 21:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbiCWBia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 21:38:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C2166FA37
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 18:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647999421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DeE+Ijhsmp8No9DKybg0kXW3B65MR+UJv9Bn/AeXmq0=;
        b=Q+e+9b/JssmpH3j5nfXF6H6g2zXGL040RoJkfA/wgXZOS6D8AFuP/lnEgKoHCiRB7E1pgy
        9xjfYfcKq3T+WZ6fvE+nyknWN+gJK2OGyjLRJRp+dXqshr2g1ZkcjEEAbcPUy0UOFBaMuR
        kaNf+SfBJtqUljJFUp//9mkG/jSILkw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-9QDF_zpRNuGHucq8cGB-Sg-1; Tue, 22 Mar 2022 21:36:59 -0400
X-MC-Unique: 9QDF_zpRNuGHucq8cGB-Sg-1
Received: by mail-pj1-f71.google.com with SMTP id fh22-20020a17090b035600b001c6a163499cso216022pjb.2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 18:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=DeE+Ijhsmp8No9DKybg0kXW3B65MR+UJv9Bn/AeXmq0=;
        b=gkWAPK+YxM9MwV5ACrYRNIxJTSxNU3dnvvgsK0BRtiz6yGY0rrqggw5sZQgCyITNFa
         NpPfDhbcCizL9Uq8etbBIcjdJaBSQsZyVGYqjW/Mxpz/W8bVFNDgNy/lDmNrm8D5tGuO
         ZKmDbGnwOlXjQbKsM9Ncr4dHz5Yr6EbSjp74SDbwBfcJ7+wGJ8Vn2QAcLogS/qHitHvj
         ZgYtOU1wMZsl9ypUiYT5CRkyrWUnX6HUJ/fckauzwHoRERIYeOVz6M1D/EBTye5kKjRR
         bFlsCmnyD62qPOaAr69Idjzi+B17PRoAOzmw9poYaTggbBgxkmPtYDr3t8mFN6BZ5hrW
         1x8w==
X-Gm-Message-State: AOAM530iJwnt0Sy012hqfZeUpCjSd2SCjJGZ2xA5S51UIOshX9ZYJYmw
        S2PQXHdAqAwW3xWqGicQCcUsKtj5rQ49OZPHmyrgPqFUBPdKJMe6BYd6pmxTJpomDzGM5wnLDdy
        9cVOiRl46gH/hLUbE+DKr
X-Received: by 2002:a65:6202:0:b0:382:1fbd:5bb3 with SMTP id d2-20020a656202000000b003821fbd5bb3mr21089850pgv.194.1647999418754;
        Tue, 22 Mar 2022 18:36:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmU3+vqpdReZPaGUNeZtG1HB6fwKFyYdEPsbS7JKGNwjl0S4Mmhmx00ZgU5AoedU4IomBanw==
X-Received: by 2002:a65:6202:0:b0:382:1fbd:5bb3 with SMTP id d2-20020a656202000000b003821fbd5bb3mr21089835pgv.194.1647999418326;
        Tue, 22 Mar 2022 18:36:58 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q21-20020a63e215000000b00373efe2cbcbsm18488546pgh.80.2022.03.22.18.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 18:36:57 -0700 (PDT)
Date:   Wed, 23 Mar 2022 09:36:53 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1] xfs/019: extend protofile test
Message-ID: <20220323013653.46d432ybh2zpdhhs@zlang-mailbox>
Mail-Followup-To: Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20220317232408.202636-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220317232408.202636-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 11:24:08PM +0000, Catherine Hoang wrote:
> This test creates an xfs filesystem and verifies that the filesystem
> matches what is specified by the protofile.
> 
> This patch extends the current test to check that a protofile can specify
> setgid mode on directories. Also, check that the created symlink isn’t
> broken.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---

Any specific reason to add this test? Likes uncovering some one known
bug/fix?

Thanks,
Zorro

>  tests/xfs/019     |  6 ++++++
>  tests/xfs/019.out | 12 +++++++++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/019 b/tests/xfs/019
> index 3dfd5408..535b7af1 100755
> --- a/tests/xfs/019
> +++ b/tests/xfs/019
> @@ -73,6 +73,10 @@ $
>  setuid -u-666 0 0 $tempfile
>  setgid --g666 0 0 $tempfile
>  setugid -ug666 0 0 $tempfile
> +directory_setgid d-g755 3 2
> +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5 ---755 3 1 $tempfile
> +$
> +: back in the root
>  block_device b--012 3 1 161 162 
>  char_device c--345 3 1 177 178
>  pipe p--670 0 0
> @@ -114,6 +118,8 @@ _verify_fs()
>  		| xargs $here/src/lstat64 | _filter_stat)
>  	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
>  		|| _fail "bigfile corrupted"
> +	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
> +		|| _fail "symlink broken"
>  
>  	echo "*** unmount FS"
>  	_full "umount"
> diff --git a/tests/xfs/019.out b/tests/xfs/019.out
> index 19614d9d..8584f593 100644
> --- a/tests/xfs/019.out
> +++ b/tests/xfs/019.out
> @@ -7,7 +7,7 @@ Wrote 2048.00Kb (value 0x2c)
>   File: "."
>   Size: <DSIZE> Filetype: Directory
>   Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
> -Device: <DEVICE> Inode: <INODE> Links: 3 
> +Device: <DEVICE> Inode: <INODE> Links: 4 
>  
>   File: "./bigfile"
>   Size: 2097152 Filetype: Regular File
> @@ -54,6 +54,16 @@ Device: <DEVICE> Inode: <INODE> Links: 1
>   Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
>  Device: <DEVICE> Inode: <INODE> Links: 1 
>  
> + File: "./directory_setgid"
> + Size: <DSIZE> Filetype: Directory
> + Mode: (2755/drwxr-sr-x) Uid: (3) Gid: (2)
> +Device: <DEVICE> Inode: <INODE> Links: 2 
> +
> + File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
> + Size: 5 Filetype: Regular File
> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
> +Device: <DEVICE> Inode: <INODE> Links: 1 
> +
>   File: "./pipe"
>   Size: 0 Filetype: Fifo File
>   Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
> -- 
> 2.25.1
> 

