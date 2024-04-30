Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1117217107D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714480751; cv=none; b=XFpEPT5IGPq96nKFvVHkVQPNwZp3k7Ae2zwfyRpRrLFfJNVWP2h/yzJit4NqOhC9z0452aM31YbJN70BMz5LTzx/MrCbKSUijuFHzhZ7OJJe7uGlEeZbjG8LbyrQVATodnvEA8WEZ8Ktx2iQmsIvjNHX+WjHZyGnDPz4qeTVPlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714480751; c=relaxed/simple;
	bh=2B5D0D1GgUPmS0uCeYNjZO5NRwRu0X9XoEhIRqRwJsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQRUCHMAlTbJtK1XD7x0Xin35MwY7XucQj7L5Dz6cThUEWQD1JLmmWseN974S33KhMV7QMZRFTc+3XXDMj1kBeQAlvtFhabDQmxiPcwG+khOGLbZ1CcFJJJ+j+OcseThuPUMCUxmflDprguPpOsFKLf/xgmKxZc7/f7z+GEmh/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=enWqOxC4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="enWqOxC4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714480749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W8nGH1asXpyg2kuAwkDFcJcU70PWri0NFYqSFUgAKXg=;
	b=enWqOxC4hJ2z3NCoYs5iGAKuxCcdU8B09PevdcMNoT+v1WejC41dXt+QTOYpIIx/ZmADB3
	plSxX4c5BR0oSKZMfpnhnXqfp0CJvcKA1YH4kLcAhbwOBFf+hRgeitNDBgM9RdUfHgUA06
	G8urrwdE5PSKrIeJyVy00m0ghJb+1ks=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-QW3BsSJWPaauGVxuVFXUcw-1; Tue, 30 Apr 2024 08:39:07 -0400
X-MC-Unique: QW3BsSJWPaauGVxuVFXUcw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d87257c610so55213921fa.2
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714480746; x=1715085546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8nGH1asXpyg2kuAwkDFcJcU70PWri0NFYqSFUgAKXg=;
        b=GDuGDdewP1GOIDOJOFmsVf7Wiahg0IztY1BiZqqqdyzIbxbnL0MCEIJvz1fj2iYCQo
         ZQGZAwUklISGSOpLt5WTalx9RqPBSbkK7cNtEas4T6Z999xO6AC9qqKqq++9hd7nA1kS
         eoNN2qwqiE0zNYDBJlcl8AjShs1ppglM2In8hP3906d2+GW9NPE4uItvWIoy5BiIt+tW
         Yb7UERfiXoZpDoSxah7QLyqE1H0HHL9rL4G5uTrLz7/3hVV7Cx90LpeAtKdEek5kKgq8
         YWYCv3qJbyWghCOTEbqzSOtWhfRJumhosTxxfzOKbLKVUjXDaAxrNPKtivsrnhf9Fmpo
         rjCA==
X-Forwarded-Encrypted: i=1; AJvYcCWv82YETDyVVjrw4dAvh0CwB7nDXOa/jKAvamMYtCE4rVi/CZ4mV6gwNMcEAgfxmEYPXcQ2PYUyFcszrkLJccLkfxzMYyZhYtJd
X-Gm-Message-State: AOJu0YzdPLC059o56sbmuWJ88kjU/1FS48wjviUy4Cv37gTZPQanosV3
	rInYdYMqsMOBp8dnoanyrCH39woNDwKROcGYnecXvy9ijpKG3B5Vlqfr318RaOUjgS7RUuf9/y6
	xl6VxlKthPp+EnWK50IqYMGn0PYtLGZmqNnQ0egtROvocwgdM41YmXspfx2sAqxQE
X-Received: by 2002:a2e:8751:0:b0:2da:7cd1:3f1f with SMTP id q17-20020a2e8751000000b002da7cd13f1fmr9600212ljj.52.1714480745911;
        Tue, 30 Apr 2024 05:39:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVYxuPVguCsONK3OpB7FYzf3d9kL4MuW/MmdYMbqLYevCuGHaDwdtQS1Ck+BozrjZINcYDmg==
X-Received: by 2002:a2e:8751:0:b0:2da:7cd1:3f1f with SMTP id q17-20020a2e8751000000b002da7cd13f1fmr9600183ljj.52.1714480745328;
        Tue, 30 Apr 2024 05:39:05 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id jw5-20020a170906e94500b00a58eab0f0e9sm3899676ejb.185.2024.04.30.05.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 05:39:04 -0700 (PDT)
Date: Tue, 30 Apr 2024 14:39:04 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, ebiggers@kernel.org, 
	Andrey Albershteyn <andrey.albershteyn@gmail.com>, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/6] common/verity: enable fsverity for XFS
Message-ID: <owfufxxoyiv3f67shc42n7pxvw4ippzjgukn3lfhayu5uraeci@pmqvwjh2u424>
References: <171444687971.962488.18035230926224414854.stgit@frogsfrogsfrogs>
 <171444687994.962488.5112127418406573234.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171444687994.962488.5112127418406573234.stgit@frogsfrogsfrogs>

On 2024-04-29 20:41:03, Darrick J. Wong wrote:
> From: Andrey Albershteyn <aalbersh@redhat.com>
> 
> XFS supports verity and can be enabled for -g verity group.
> 
> Signed-off-by: Andrey Albershteyn <andrey.albershteyn@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/verity |   39 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 37 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/verity b/common/verity
> index 59b67e1201..20408c8c0e 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -43,7 +43,16 @@ _require_scratch_verity()
>  
>  	# The filesystem may be aware of fs-verity but have it disabled by
>  	# CONFIG_FS_VERITY=n.  Detect support via sysfs.
> -	if [ ! -e /sys/fs/$fstyp/features/verity ]; then
> +	case $FSTYP in
> +	xfs)
> +		_scratch_unmount
> +		_check_scratch_xfs_features VERITY &>>$seqres.full
> +		_scratch_mount
> +	;;
> +	*)
> +		test -e /sys/fs/$fstyp/features/verity
> +	esac
> +	if [ ! $? ]; then
>  		_notrun "kernel $fstyp isn't configured with verity support"
>  	fi
>  
> @@ -201,6 +210,9 @@ _scratch_mkfs_verity()
>  	ext4|f2fs)
>  		_scratch_mkfs -O verity
>  		;;
> +	xfs)
> +		_scratch_mkfs -i verity
> +		;;
>  	btrfs)
>  		_scratch_mkfs
>  		;;
> @@ -334,12 +346,19 @@ _fsv_scratch_corrupt_bytes()
>  	local lstart lend pstart pend
>  	local dd_cmds=()
>  	local cmd
> +	local device=$SCRATCH_DEV
>  
>  	sync	# Sync to avoid unwritten extents
>  
>  	cat > $tmp.bytes
>  	local end=$(( offset + $(_get_filesize $tmp.bytes ) ))
>  
> +	# If this is an xfs realtime file, switch @device to the rt device
> +	if [ $FSTYP = "xfs" ]; then
> +		$XFS_IO_PROG -r -c 'stat -v' "$file" | grep -q -w realtime && \
> +			device=$SCRATCH_RTDEV
> +	fi
> +
>  	# For each extent that intersects the requested range in order, add a
>  	# command that writes the next part of the data to that extent.
>  	while read -r lstart lend pstart pend; do
> @@ -355,7 +374,7 @@ _fsv_scratch_corrupt_bytes()
>  		elif (( offset < lend )); then
>  			local len=$((lend - offset))
>  			local seek=$((pstart + (offset - lstart)))
> -			dd_cmds+=("head -c $len | dd of=$SCRATCH_DEV oflag=seek_bytes seek=$seek status=none")
> +			dd_cmds+=("head -c $len | dd of=$device oflag=seek_bytes seek=$seek status=none")
>  			(( offset += len ))
>  		fi
>  	done < <($XFS_IO_PROG -r -c "fiemap $offset $((end - offset))" "$file" \
> @@ -408,6 +427,22 @@ _fsv_scratch_corrupt_merkle_tree()
>  		done
>  		_scratch_mount
>  		;;
> +	xfs)
> +		local ino=$(stat -c '%i' $file)

I didn't know about xfs_db's "path" command, this can be probably
replace with -c "path $file", below in _scratch_xfs_db.

> +		local attr_offset=$(( $offset % $FSV_BLOCK_SIZE ))
> +		local attr_index=$(printf "%08d" $(( offset - attr_offset )))
> +		_scratch_unmount
> +		# Attribute name is 8 bytes long (byte position of Merkle tree block)
> +		_scratch_xfs_db -x -c "inode $ino" \
                                here   ^^^^^^^^^^
> +			-c "attr_modify -f -m 8 -o $attr_offset $attr_index \"BUG\"" \
> +			-c "ablock 0" -c "print" \
> +			>>$seqres.full
> +		# In case bsize == 4096 and merkle block size == 1024, by
> +		# modifying attribute with 'attr_modify we can corrupt quota
> +		# account. Let's repair it
> +		_scratch_xfs_repair >> $seqres.full 2>&1
> +		_scratch_mount
> +		;;
>  	*)
>  		_fail "_fsv_scratch_corrupt_merkle_tree() unimplemented on $FSTYP"
>  		;;
> 
> 

Otherwise, looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

