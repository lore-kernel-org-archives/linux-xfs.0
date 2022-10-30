Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A929C38A02
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 03:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJ3Dcy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 23:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ3Dcy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 23:32:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B40A46DB4
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 20:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667100713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MKcEvPdmRY2uO5eAbMKVgW+hn0/Q5weE/T5XGHv7vm0=;
        b=K2XFZk4/Lw9VrumWXkvLC7eAMUJlUryVFlNDxwZhQGy0UuDB+lqaqmyoZOEmyAO862MNZ5
        IMiEjHjUgltLs4hkiuz/x4kXMi/13RXpawzhwl0PAzmIzzt8D0oTOsH1Auqehv+0rRMsw1
        pHFLQ9b81M9adaXsnbPdwA/sXSUHnOQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-494-FH7xs5UaMDSkRQXOdvDL3g-1; Sat, 29 Oct 2022 23:31:51 -0400
X-MC-Unique: FH7xs5UaMDSkRQXOdvDL3g-1
Received: by mail-qt1-f198.google.com with SMTP id v12-20020ac8578c000000b003a50eb13e29so2536728qta.3
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 20:31:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MKcEvPdmRY2uO5eAbMKVgW+hn0/Q5weE/T5XGHv7vm0=;
        b=PJX+TGRE1JGHtDSeLCvGtEI0iUzCz7K3geiyMvwdYI4TdJUR6cwrlPjQ0+wpm/ViDX
         0bt3wVCTEAJk3BgoTiYElvXHdhYUoWG3EZSVN8qF5C9yIX2y56oMJs1ZAhV2BRNobESJ
         HruKGGfJ67+H89HBGEZaAVtwT8p22XGJOkYf1OxVVciMwMVtKNdDwehkASa/+GdBy93g
         xpGto2ZT0yvIf5NFGxRbZf3s7Rp5EhS0NDZKe7HxQWHxR9lkmNTdZKD95tqTkozAeg9O
         Ud25pFUFX8ThbVHA/DPcDBymsr7aeFsxu0Eq5Zs8pZN7aITvrm62awlnraOsFWwGtkYL
         f0Ng==
X-Gm-Message-State: ACrzQf1A0HfmII2jF3l8lLpinqU079DndzonnrJwsrTS0W78yFiIMUay
        bYQzEAqk70BwNqCmzLqsSdSayd2PcOuZzQkgja9KVwJgyBB6eirkmMNuBZhhMkbfYM7TC9AyvRw
        ILh56/fPTKjzJ8h65ZhLc
X-Received: by 2002:ac8:5849:0:b0:39a:8e35:1bfa with SMTP id h9-20020ac85849000000b0039a8e351bfamr5518530qth.573.1667100710592;
        Sat, 29 Oct 2022 20:31:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7bx2KaTP4hWipW5/xbKquDnQ2o/mHUa8yEjHhJEExywCotoGffEqF9WtcSgFC1dxA1nU483Q==
X-Received: by 2002:ac8:5849:0:b0:39a:8e35:1bfa with SMTP id h9-20020ac85849000000b0039a8e351bfamr5518524qth.573.1667100710320;
        Sat, 29 Oct 2022 20:31:50 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u15-20020a05620a454f00b006fa0ca71bb6sm2225503qkp.88.2022.10.29.20.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 20:31:49 -0700 (PDT)
Date:   Sun, 30 Oct 2022 11:31:45 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] common: simplify grep pipe sed interactions
Message-ID: <20221030033145.azfluzhja65jpf67@zlang-mailbox>
References: <166697890818.4183768.10822596619783607332.stgit@magnolia>
 <166697893084.4183768.1057318180034267637.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166697893084.4183768.1057318180034267637.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 10:42:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Zorro pointed out that the idiom "program | grep | sed" isn't necessary
> for field extraction -- sed is perfectly capable of performing a
> substitution and only printing the lines that match that substitution.
> Do that for the common helpers.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/ext4     |    9 +++++++++
>  common/populate |    4 ++--
>  common/xfs      |   11 ++++-------
>  3 files changed, 15 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/common/ext4 b/common/ext4
> index f4c3c4139a..4a2eaa157f 100644
> --- a/common/ext4
> +++ b/common/ext4
> @@ -191,3 +191,12 @@ _scratch_ext4_options()
>  	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
>  		SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${log_opt}"
>  }
> +
> +# Get the inode flags for a particular inode number
> +_ext4_get_inum_iflags() {
> +	local dev="$1"
> +	local inumber="$2"
> +
> +	debugfs -R "stat <${inumber}>" "${dev}" 2> /dev/null | \
> +			sed -n 's/^.*Flags: \([0-9a-fx]*\).*$/\1/p'
> +}
> diff --git a/common/populate b/common/populate
> index d9d4c6c300..6e00499734 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -641,7 +641,7 @@ __populate_check_ext4_dformat() {
>  	extents=0
>  	etree=0
>  	debugfs -R "stat <${inode}>" "${dev}" 2> /dev/null | grep 'ETB[0-9]' -q && etree=1
> -	iflags="$(debugfs -R "stat <${inode}>" "${dev}" 2> /dev/null | grep 'Flags:' | sed -e 's/^.*Flags: \([0-9a-fx]*\).*$/\1/g')"
> +	iflags="$(_ext4_get_inum_iflags "${dev}" "${inode}")"
>  	test "$(echo "${iflags}" | awk '{print and(strtonum($1), 0x80000);}')" -gt 0 && extents=1
>  
>  	case "${format}" in
> @@ -688,7 +688,7 @@ __populate_check_ext4_dir() {
>  
>  	htree=0
>  	inline=0
> -	iflags="$(debugfs -R "stat <${inode}>" "${dev}" 2> /dev/null | grep 'Flags:' | sed -e 's/^.*Flags: \([0-9a-fx]*\).*$/\1/g')"
> +	iflags="$(_ext4_get_inum_iflags "${dev}" "${inode}")"
>  	test "$(echo "${iflags}" | awk '{print and(strtonum($1), 0x1000);}')" -gt 0 && htree=1
>  	test "$(echo "${iflags}" | awk '{print and(strtonum($1), 0x10000000);}')" -gt 0 && inline=1
>  
> diff --git a/common/xfs b/common/xfs
> index a995e0b5da..4f2cd46c91 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -179,8 +179,7 @@ _xfs_get_rtextents()
>  {
>  	local path="$1"
>  
> -	$XFS_INFO_PROG "$path" | grep 'rtextents' | \
> -		sed -e 's/^.*rtextents=\([0-9]*\).*$/\1/g'
> +	$XFS_INFO_PROG "$path" | sed -n "s/^.*rtextents=\([[:digit:]]*\).*/\1/p"
>  }
>  
>  # Get the realtime extent size of a mounted filesystem.
> @@ -188,8 +187,7 @@ _xfs_get_rtextsize()
>  {
>  	local path="$1"
>  
> -	$XFS_INFO_PROG "$path" | grep 'realtime.*extsz' | \
> -		sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
> +	$XFS_INFO_PROG "$path" | sed -n "s/^.*realtime.*extsz=\([[:digit:]]*\).*/\1/p"
>  }
>  
>  # Get the size of an allocation unit of a file.  Normally this is just the
> @@ -217,8 +215,7 @@ _xfs_get_dir_blocksize()
>  {
>  	local fs="$1"
>  
> -	$XFS_INFO_PROG "$fs" | grep 'naming.*bsize' | \
> -		sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'
> +	$XFS_INFO_PROG "$fs" | sed -n "s/^naming.*bsize=\([[:digit:]]*\).*/\1/p"
>  }
>  
>  # Set or clear the realtime status of every supplied path.  The first argument
> @@ -1267,7 +1264,7 @@ _force_xfsv4_mount_options()
>  # Find AG count of mounted filesystem
>  _xfs_mount_agcount()
>  {
> -	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
> +	$XFS_INFO_PROG "$1" | sed -n "s/^.*agcount=\([[:digit:]]*\).*/\1/p"
>  }
>  
>  # Wipe the superblock of each XFS AGs
> 

