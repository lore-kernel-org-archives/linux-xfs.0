Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E6C238176
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 06:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760424456; cv=none; b=MRWgOPzfISnqU/xfdOfZdoSadXtVnY/bhsJThoFryRu+UQqdvYjJiihZEDfJdCS6M8vbu2doktHbZd0dGfuSqNL5zKfbcN0Y+UvREjTn4J8cGdglRBTA8wY5nkqCAQAPJiRBI5TQXaLC93xXWJO9OoWoKhOZqoqwwBhaYXqpr9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760424456; c=relaxed/simple;
	bh=MHDJvwQVw4hAV+xieFgHsm/3L3C6rZF3S94XFGkO2XE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=oHpB+CaNKCQ8Ep92tGg4zK/bvaqQphqPyfAJNSMIT3g52jAxwA58rCEYPjHHehJPtSEQpXfEjM2Imtu6ZraNBw57EifIy1WfpI1QiG4lzNYqfbItxMpJcOUaG6CnqlVP89yxvkqKWArrnFKcMO54mj+12CiWjXNuX0cvf/eV5Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B5J10Zfk; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B5J10Zfk"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-27ee41e074dso57693345ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 23:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760424455; x=1761029255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i5IQTUZRqs0M8R1/aO+Rnlpk45W5+vRfT6DAuQi4UL0=;
        b=B5J10ZfkKOvbeMMmFfABlBKLWjxVvT/oorJ1EvPLy/VY3hXqInurx2Jlz1kgfhkSlL
         mcUcp6V5rrZnTOsXRsFuYMyffR4iWRglNq+1atlL7t4Tj3rGN4HepRZEkwoD/gtmLGrN
         RmRfvjibaPyxXBIFgFFGTNDSd2wYaJrmmz/eD5ppV+FDtOqBWSneHslTvHvCWuECM71G
         qvQZebsmPfIBZDQ3dcrJdTer55dnxIhACCQVPdFOHNpngZVIhUogFcjKQaoaY0mZSzSW
         KQmN0WTzVme/XCz+qDqZnfnmU2N75C5YHBSdJ7lnUiSMQ4hdJo+dYvU6q42lcHm5PBA6
         v8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760424455; x=1761029255;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i5IQTUZRqs0M8R1/aO+Rnlpk45W5+vRfT6DAuQi4UL0=;
        b=TEBAnUn3cW8JfA7xNYMPtBWaQBw7HQ/NTOoJr+alkUHsRbqSUFsGnTfzJbNP5NxZfT
         lxEYyy9AxOqfFqGH2RgMZZIS1P9Co/TlDWo6ArOabjdyGZZY6HlUrUKgt/F471xXKbzx
         RVKA3DA5RpJ07u4yYyZSkHp7UJ1+BW+9MJMF9Zv7bjVDCiiHUfJ0kJNWPXBjAcIPve5r
         KRm9G6a3PRBSHItSxFjBiRmFwgIoxDrSAEkSLVU9331R3ePH8jjG3XBK2nkKTtdkRin1
         WLMKp2R4qC1GE1ew3Uz6PU0/jDUzjilSi6L4tYyrIm2GswAGFz0gZWk3B1ov+yv+S1sI
         mElQ==
X-Gm-Message-State: AOJu0YwFSjn9gWfzSYvSFbqrZW4Xnfscr+bvKQMc0zLOwjN2npljIwhh
	WznSxt/i2d9REz2u+KPmWiqmuZTgC4DkZiGYPsRI+iCDbtKqib7jk5Ecb84QFw==
X-Gm-Gg: ASbGncvtOHRB1ZiCyDsI2C/vTGlbxeWJM9MKA+soNP5IlZWCGKIrTvHMILgtEVt9RNY
	+80xL8WQUrrzBVxTRI5k/ov86NouGHaTtioxhJqd7gsF+JsqRg//5nX7+LVnNBpPO5Ynp5oZIl0
	ZuYIC5VFvWqaWQExuz4/ZN97k6owg9thXfwgBwv3RqzZvkis9g5PPEaiBq9XXgNM03vkwj88u0K
	/ypWNZhjAucNIvBPnp5fpjPuwgvyVfE4yrRbuU8DlJYAPs3HTBMUyY6eMNlf4zr1t4IvJXa/cFq
	pQK5zjx5wUTq5qornBLki7fEFGw3d06yWuGpoGtP2DRH6nk9Y5F51xpIcejZRZDXNaE6FhK2/8y
	hlpNLRhGX6Yuo7Zhf8NLYPs8lXQDNyuRgX/+LJ14w9VtufnBaz7a8u75NmUciU7kVMJjB/pGQRt
	zSp02kGx5VtEOxvAqChg==
X-Google-Smtp-Source: AGHT+IEViNsTccuAwLB7xi00VozaH3DR+Anxi7GXCbRFAMUxpC3k9hHzX3pa8So+OEcXca0/F6UkAg==
X-Received: by 2002:a17:903:3885:b0:246:cfc4:9a30 with SMTP id d9443c01a7336-290272c037dmr293756475ad.35.1760424454714;
        Mon, 13 Oct 2025 23:47:34 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.205.87])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f3c700sm154971095ad.103.2025.10.13.23.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 23:47:34 -0700 (PDT)
Message-ID: <ec2bc94bc73a42ab61019b8de5951359d383247d.camel@gmail.com>
Subject: Re: [PATCH] xfs: don't set bt_nr_sectors to a negative number
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig
 <hch@infradead.org>,  Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Date: Tue, 14 Oct 2025 12:17:30 +0530
In-Reply-To: <20251013163310.GM6188@frogsfrogsfrogs>
References: <20251013163310.GM6188@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-10-13 at 09:33 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_daddr_t is a signed type, which means that xfs_buf_map_verify is
> using a signed comparison.  This causes problems if bt_nr_sectors is
> never overridden (e.g. in the case of an xfbtree for rmap btree repairs)
> because even daddr 0 can't pass the verifier test in that case.
Okay so the check "if (map->bm_bn < 0 || map->bm_bn >= btp->bt_nr_sectors) {" will be true of the
default value of btp->bt_nr_sectors = -1 and the verifier will fail(incorrectly), right?
Why would we not want to override bt_nr_sectors? If there is device, then shouldn't it always have a
buffer target with a certain number of bt_nr_sectors?
--NR
> 
> Define an explicit max constant and set the initial bt_nr_sectors to a
> positive value.
> 
> Found by xfs/422.
> 
> Cc: <stable@vger.kernel.org> # v6.18-rc1
> Fixes: 42852fe57c6d2a ("xfs: track the number of blocks in each buftarg")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_buf.h |    1 +
>  fs/xfs/xfs_buf.c |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 8fa7bdf59c9110..e25cd2a160f31c 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -22,6 +22,7 @@ extern struct kmem_cache *xfs_buf_cache;
>   */
>  struct xfs_buf;
>  
> +#define XFS_BUF_DADDR_MAX	((xfs_daddr_t) S64_MAX)
>  #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
>  
>  #define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 773d959965dc29..47edf3041631bb 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1751,7 +1751,7 @@ xfs_init_buftarg(
>  	const char			*descr)
>  {
>  	/* The maximum size of the buftarg is only known once the sb is read. */
> -	btp->bt_nr_sectors = (xfs_daddr_t)-1;
> +	btp->bt_nr_sectors = XFS_BUF_DADDR_MAX;
>  
>  	/* Set up device logical sector size mask */
>  	btp->bt_logical_sectorsize = logical_sectorsize;

