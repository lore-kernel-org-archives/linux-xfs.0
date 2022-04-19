Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5D1C41535
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 18:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353115AbiDSSi0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357694AbiDSSh7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 14:37:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D79C01F615
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650393236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SWUk78AsoIGQX6lh08lxO2HS8IQOcjGi+y7zsp0Kjqo=;
        b=EoqzYw5/mEC0qLfAJ6jfjUEw7nMI8WkJCUz7Nk5mjkIsv+k4hKCx3mci1p3dPd76VcQx22
        QMtsQWz06RQLxD1xHB958qoaqh/dKTg7a9g54VnxINKbp2bDVDOLGj4qJnal9XOt0LZ1kE
        xiWkJPEZJ+DllxfbsmaaHgNFMFsoQow=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-D-brFu4PM7qh6gXNUUzoSg-1; Tue, 19 Apr 2022 14:33:54 -0400
X-MC-Unique: D-brFu4PM7qh6gXNUUzoSg-1
Received: by mail-qk1-f199.google.com with SMTP id u7-20020ae9d807000000b00680a8111ef6so13028478qkf.17
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=SWUk78AsoIGQX6lh08lxO2HS8IQOcjGi+y7zsp0Kjqo=;
        b=mHiKyOL1Rkg2bhiwPFOC/7sImouaAiCbs6Y5XEdANXSxSuSMgBUmPba7m4EwRv+/kh
         HgbKnSmEc89etpw3x1sEWcAMGqNbD68loJzrEvxI39+kqTZPXq6v8JG1iQ9msjiHV9J9
         O7p0MWDqob3oLeWPdz3ndozE/6fOBxKBcWh4EKZXHoY5w9Jnk+k1RYnVshUMRsrNMhLB
         8H18WEW3oT+sGO8ZXQzA5iFWDJG39abGYJ19sb46WxMCqQvOj2AvobnDfDPwJpJk3gXX
         z9tAGkAWQIs+vFdRJALN/v1JITiER+etbOtuy7ebqT833TpAdD1R77fD2Ewd6UTBgGSz
         FOLg==
X-Gm-Message-State: AOAM532OPNbRO3IvKVccZ2oLZjfNZTtyJ7hP1kXc9Zz1tkKUdQERyTQr
        V5tdZHsSD2IHgEfitgNZmTDnJPIlsd3j8P5PmQ2bcKShor0C6+/cUvbr8KSjj/nbWdGrvt+nscO
        YBnzsr75fZGBZbM46XBMU
X-Received: by 2002:ac8:5815:0:b0:2e2:2d63:ac13 with SMTP id g21-20020ac85815000000b002e22d63ac13mr11352223qtg.469.1650393234148;
        Tue, 19 Apr 2022 11:33:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVtHSfykJku+94V8otg5MRSbPg/0uXdOaMCXKZQIi5RbaJYEzpUjc445QSUU7qrtYPoljJNA==
X-Received: by 2002:ac8:5815:0:b0:2e2:2d63:ac13 with SMTP id g21-20020ac85815000000b002e22d63ac13mr11352212qtg.469.1650393233929;
        Tue, 19 Apr 2022 11:33:53 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g19-20020ac87f53000000b002f1c774a4cbsm509491qtk.12.2022.04.19.11.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 11:33:53 -0700 (PDT)
Date:   Wed, 20 Apr 2022 02:33:47 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs/019: fix golden output for files created in
 setgid dir
Message-ID: <20220419183347.hruyn5zimz6tcxd4@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <165038951495.1677615.10687913612774985228.stgit@magnolia>
 <165038952072.1677615.13209407698123810165.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165038952072.1677615.13209407698123810165.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 10:32:00AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A recent change to xfs/019 exposed a long-standing bug in mkfs where
> it would always set the gid of a new child created in a setgid directory
> to match the gid parent directory instead of what's in the protofile.
> 
> Ignoring the user's directions is not the correct behavior, so update
> this test to reflect that.  Also don't erase the $seqres.full file,
> because that makes forensic analysis pointlessly difficult.
> 
> Cc: Catherine Hoang <catherine.hoang@oracle.com>
> Fixes: 7834a740 ("xfs/019: extend protofile test")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

After merge this patch, xfs/019 fails on my system. So this test will cover
a new bug of xfsprogs which hasn't been fixed? If so, this change is good to me.
But we'd better to take a look at the patch you used to fix xfsprogs, and make
sure it's reviewed.

Thanks,
Zorro

>  tests/xfs/019     |    3 +--
>  tests/xfs/019.out |    2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/xfs/019 b/tests/xfs/019
> index 535b7af1..790a6821 100755
> --- a/tests/xfs/019
> +++ b/tests/xfs/019
> @@ -10,6 +10,7 @@
>  _begin_fstest mkfs auto quick
>  
>  seqfull="$seqres.full"
> +rm -f $seqfull
>  # Import common functions.
>  . ./common/filter
>  
> @@ -97,7 +98,6 @@ _verify_fs()
>  	echo "*** create FS version $1"
>  	VERSION="-n version=$1"
>  
> -	rm -f $seqfull
>  	_scratch_unmount >/dev/null 2>&1
>  
>  	_full "mkfs"
> @@ -131,6 +131,5 @@ _verify_fs()
>  _verify_fs 2
>  
>  echo "*** done"
> -rm $seqfull
>  status=0
>  exit
> diff --git a/tests/xfs/019.out b/tests/xfs/019.out
> index 8584f593..9db157f9 100644
> --- a/tests/xfs/019.out
> +++ b/tests/xfs/019.out
> @@ -61,7 +61,7 @@ Device: <DEVICE> Inode: <INODE> Links: 2
>  
>   File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
>   Size: 5 Filetype: Regular File
> - Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
>  Device: <DEVICE> Inode: <INODE> Links: 1 
>  
>   File: "./pipe"
> 

