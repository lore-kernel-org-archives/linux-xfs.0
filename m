Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD70C5517A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 04:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8E9C221FF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 04:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pk7q2Bhf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgKKEXy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 23:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgKKEXx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 23:23:53 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35542C0613D1;
        Tue, 10 Nov 2020 20:23:52 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id cp9so326666plb.1;
        Tue, 10 Nov 2020 20:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bfjeJtaJ8ymYb9/0wols3g3hiomCS9tqbS0m1iaxOEQ=;
        b=pk7q2BhfngaUT/pumcje3YwEzp09tpzR0kJunzY5DDNE4ZHIQcHi19cH5l6iW8w8pX
         lh98PNDVu9mMgmhBAXy6X4O7WH8hSS/44gKA5zv/Dc5qF+B83QX/JZ0GipaVVfUi476f
         GE3+TOPUVq8rmPQtQq6J8RkTr2v0OsNjPqXrzbKESSi0XTZvwAUyvdxUnVvUaytUG0QX
         NqhnMQkp0pj0zPfTDungSqIj40ERBewf7dxHVgY3zur5czgB31IF2GjhxIDu+W0aLxVu
         dkKRxm4I77u0Xz6yyCOKB/0eL15CwrWN1pN5/TD929Yd4XRR7cl5AxZuT4Y4Wcm3Dy6O
         H3Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bfjeJtaJ8ymYb9/0wols3g3hiomCS9tqbS0m1iaxOEQ=;
        b=Nf+AGQ0cM/nVcIkynY2zk7l79YgJeXnXBubp4UsllxtwVtDA/imRBcj3FHvMWB2byc
         rvXsgd4S+4CtqW1iEqQZoyHkWYWtOReZxyfTInq3lzJaOAc3Ij/WCS231eat3KfQfNQl
         1GDEe7JFCOCh03g4dX9B/sCm9ZZMDkOoojG4x6YUDOiMsctmj2ORpmTcCRivyYXvIqE0
         Sn9EUNHhPpx9IS5Sry9hEdQ5Ra6DX55fP4uxP+yVybxBi574FNPS1IONlXxPDGT5vRYA
         SRqKH5axpdxbefCpCHt2rTRRmXxD1SvqlAohXywU1eZ5iw0MhlheZbb7WEZ2VurdYR7q
         0G1g==
X-Gm-Message-State: AOAM532ZSFWX5IqUZ6PyQuL0Q0sReLuFlOtGs92U9fZvxliNach530lY
        bhzktQ5W1IAAsk3XgTEtC7Y=
X-Google-Smtp-Source: ABdhPJwoVg1q7EPJiMY7L1dxrAYXbft69t0Vfi2t8QbdQYRI152guwN9gp+PJ/fkLWNHs3vkbkxfAw==
X-Received: by 2002:a17:902:aa06:b029:d8:bc5b:612b with SMTP id be6-20020a170902aa06b02900d8bc5b612bmr1187334plb.50.1605068631618;
        Tue, 10 Nov 2020 20:23:51 -0800 (PST)
Received: from garuda.localnet ([122.182.230.114])
        by smtp.gmail.com with ESMTPSA id d10sm584044pjj.38.2020.11.10.20.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 20:23:50 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/6] common: extract rt extent size for _get_file_block_size
Date:   Wed, 11 Nov 2020 09:53:47 +0530
Message-ID: <7948340.P4EV05P4cu@garuda>
In-Reply-To: <160505537946.1388647.16793832491247950385.stgit@magnolia>
References: <160505537312.1388647.14788379902518687395.stgit@magnolia> <160505537946.1388647.16793832491247950385.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 11 November 2020 6:12:59 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> _get_file_block_size is intended to return the size (in bytes) of the
> fundamental allocation unit for a file.  This is required for remapping
> operations like fallocate and reflink, which can only operate on
> allocation units.  Since the XFS realtime volume can be configure for
> allocation units larger than 1 fs block, we need to factor that in here.
> 
> Note that ext* with bigalloc does not allocations to be aligned to the
> cluster size, so no update is needed there.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/rc  |   13 ++++++++++---
>  common/xfs |   20 ++++++++++++++++++++
>  2 files changed, 30 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 65ebfe20..019b9b2b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3975,11 +3975,18 @@ _get_file_block_size()
>  		echo "Missing mount point argument for _get_file_block_size"
>  		exit 1
>  	fi
> -	if [ "$FSTYP" = "ocfs2" ]; then
> +
> +	case "$FSTYP" in
> +	"ocfs2")
>  		stat -c '%o' $1
> -	else
> +		;;
> +	"xfs")
> +		_xfs_get_file_block_size $1
> +		;;
> +	*)
>  		_get_block_size $1
> -	fi
> +		;;
> +	esac
>  }
>  
>  # Get the minimum block size of an fs.
> diff --git a/common/xfs b/common/xfs
> index 79dab058..3f5c14ba 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -174,6 +174,26 @@ _scratch_mkfs_xfs()
>  	return $mkfs_status
>  }
>  
> +# Get the size of an allocation unit of a file.  Normally this is just the
> +# block size of the file, but for realtime files, this is the realtime extent
> +# size.
> +_xfs_get_file_block_size()
> +{
> +	local path="$1"
> +
> +	if ! ($XFS_IO_PROG -c "stat -v" "$path" 2>&1 | egrep -q '(rt-inherit|realtime)'); then
> +		_get_block_size "$path"
> +		return
> +	fi
> +
> +	# Otherwise, call xfs_info until we find a mount point or the root.
> +	path="$(readlink -m "$path")"
> +	while ! $XFS_INFO_PROG "$path" &>/dev/null && [ "$path" != "/" ]; do
> +		path="$(dirname "$path")"
> +	done
> +	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
> +}
> +
>  # xfs_check script is planned to be deprecated. But, we want to
>  # be able to invoke "xfs_check" behavior in xfstests in order to
>  # maintain the current verification levels.
> 
> 


-- 
chandan



