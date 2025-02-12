Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE90201258
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 21:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739395419; cv=none; b=twlX6xxwKb9YQBhp+kdrBjTOKqeg/oBy+601FzA1OfqnqCUtEAwyISQObMxSru2zpCDFEN5KZxt2/ZMzuIb5UAKP49D/tSdwytWjZJDnQ5eid1+Ie63zFA4XLIwi9jrI8f1d96jhafbiP3zQLX2XPfRQHF4ht4rXQjWJsegznKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739395419; c=relaxed/simple;
	bh=Hy2r0elVz1dNaH6kTrp/cVsXskL5R2B2kHanuTCM4kQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJfE5SC+GBpYa59g9YxtggpxZt50u9heKrx7tD8nFqQWKJah3uDX05b9zlqhKhnX0jESYEW5SbstSbeLodg+qOmYzfvC5O4/06icn53CJnjvKEs7eS46FsDZUwqzXJOhkFdDD4FqxEXoqhhD4T5G7pJAA3A2JdV8vjPQCairktg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=T5vgbcPP; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="T5vgbcPP"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21f4af4f9ddso1898205ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 13:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1739395417; x=1740000217; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DnWJ9ncHwe6ht8H8YTq86uwEtd3hGCr8wLzk0vFKje4=;
        b=T5vgbcPPmcNEygj7xxbAWZJ+tYuxFaYlP68nzftNISpR4yunrRg88SQq+m1iSy/nC0
         5DiLtsVehx7wf7e7NSdzUjVBRKq9vABcaib41ctk9SNs+fN6fIOGeGLs5GxqSmoqEFnb
         uEy71h1vGgOFlJoo3dh/ZVi6Tr7EgUEt+Hp/ga+494935OWDnxbRzm/g+reeSIZVQBox
         df2mmJrs9KX9Pb6im7LBYKbxw5CDxxAHLKOJCfk8L1P4683Om000dUkQtpeDNxLsgCJT
         mNUvfj237aGbgMV2jsAZHxQCW1mzigTWFxsKb8hjRKz3+PIMXHWtaIhf6XkxMtzs6Gn+
         xXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739395417; x=1740000217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnWJ9ncHwe6ht8H8YTq86uwEtd3hGCr8wLzk0vFKje4=;
        b=gI5XDAgTVQEVI4MF9kYt/KtW4rHQBDDXy1zW9iutjjsRn43YhZNLOOhePLTn+25VrG
         1qAo7eWcLqmcwKT3QdRG6QeUe3rJoLvjbPiQjxyDCD7WrHpMsfZZp/kjL/qwoasA+qer
         W7agSsbQHjIykN9CiEg80lFwdcRHfP7bxCNPDfCUV+dXTNm0N3NKnCmT2GxmC6jT08Q8
         uswdjvmFpq5wfrZxr6pDlw01Ymu00EWLcwUs2OH2E14pebR/o8yKbzizH7SdVeXO0QWF
         LvbNSiNWRdHAV+IX8MFQUoEVvN7v/4IvQHKTnuTdwCcpyhtGLc4IZeOP/X7RbRAbvQkd
         mPuw==
X-Forwarded-Encrypted: i=1; AJvYcCXU/PccYNYSY1UNb63ZogbiHtTDUmpgiQUlotfW3FWTd+FK5LjRVCBLLc2fDo2NfIdO5vTpsgVfEZg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0eZ0r0ZKe9WYBay728IEwM91Jy+3PBHDxkSlTmKe1BK/BJPEB
	blWWA/QkiUgU73oYnTp6n5oYREXsFNXVJGbN7ChUfFHSOpPV5hIVkx5SqvOUTXI=
X-Gm-Gg: ASbGncsH/zrgVYhwkq12gRoW+j0or1YTY7qodv3JKWFCBFvVnulJKkzK9L1jEmf1KrQ
	xC5cDPsBZpRvzxuGOMefz2mlzJWQawOreVLGUxBwj1j+QSVxmEYUwKR/+L+I1nFJN99/Q+5F/SH
	ZBbP3Bu83oCyv4+KE0h7SobXUYtnYqy6MbqGEIEABsjCaKUWc50+ddez75xNICmO9QNYGLf2oKm
	cUc0p6Cl0q7QFokQvEfg0tkhg8iK9WZf96msWx+Sr+Oh9pqVyHqzwPPov8czD58jAFFM109LPY4
	QE25owMG7awCing6bCfcqpiJKtI8pLOz1egCf6sI0OWE6IK5hNGUM0lsPzjUuSNoW8g=
X-Google-Smtp-Source: AGHT+IEYqdmFI/8uZqwemYkPrJk0UIjGmcrIHb9Mpfb2ciK6bkr9nytSyUNC0C4qGkZnmqnJZ6k5rw==
X-Received: by 2002:a17:902:ef11:b0:21f:5cd8:c52 with SMTP id d9443c01a7336-220d213e655mr13788095ad.53.1739395416777;
        Wed, 12 Feb 2025 13:23:36 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d5363848sm118065ad.55.2025.02.12.13.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 13:23:36 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tiKCi-00000000RUB-3uBx;
	Thu, 13 Feb 2025 08:23:32 +1100
Date: Thu, 13 Feb 2025 08:23:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH v1 2/3] common/xfs: Add a new helper function to check v5
 XFS
Message-ID: <Z60RVLPGwpucOgRx@dread.disaster.area>
References: <cover.1739363803.git.nirjhar.roy.lists@gmail.com>
 <61a7e3f25621548ec3ef795a3cd0724e32afb647.1739363803.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61a7e3f25621548ec3ef795a3cd0724e32afb647.1739363803.git.nirjhar.roy.lists@gmail.com>

On Wed, Feb 12, 2025 at 12:39:57PM +0000, Nirjhar Roy (IBM) wrote:
> This commit adds a new helper to function to check that we can
> create a V5 XFS filesystem in the scratch device
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  common/xfs | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 0417a40a..cc0a62e4 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -468,6 +468,19 @@ _require_scratch_xfs_crc()
>  	_scratch_unmount
>  }
>  
> +# this test requires the xfs kernel support crc feature on scratch device
> +#
> +_require_scratch_xfs_v5()
> +{
> +	_require_scratch_xfs_crc
> +	_scratch_mkfs_xfs -m crc=1 > $seqres.full 2>&1 ||
> +		_notrun "v5 filesystem isn't supported by the kernel"

This is testing mkfs.xfs, not the kernel.

We already have a helper for that: _scratch_mkfs_xfs_supported()

> +	_try_scratch_mount >/dev/null 2>&1
> +	ret="$?"
> +	_scratch_unmount
> +	[[ "$ret" != "0" ]] && _notrun "couldn't mount a V5 xfs filesystem"
> +}

This doesn't actually check that the mounted filesystem is a v5
format filesystem. That's what _require_scratch_xfs_crc() does.

Hence I don't see what this adds over _require_scratch_xfs_crc(),
which does the right thing on any mkfs.xfs released in the past
decade (i.e. when we changed mkfs.xfs to create v5 filesystems by
default). 

What test environment doesn't _require_scratch_xfs_crc() work for?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
