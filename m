Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9390133343B
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 06:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770273391; cv=none; b=VQBMHOE8bgcL26hbSNiGoXDgJ99iYwk6dyaPHVe9blzZHR0Y6FEsQ2T6EsWc3j7cPlAakA3xkgzKxNzkr6K1qXD18cO1iIKrqnql1ZpXekVRQPl5MGiRmwI9iO9ZVRTIR0AsuGQQDawElcDvg9WtCSSgQ3nHLEbkZWJuafaIpvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770273391; c=relaxed/simple;
	bh=IE6utOrbsdv697v+Q5HtuDyYMfbCRwnXcUnUjrd1deY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=S8/Ed/lX47czQWs78aFzUxRV5/fDw5gHMRzF0VSxH0L3J/FIxFkhtREWpWNawog87vqivYpWRT4XhoPENIn1l3l6RUP5I/g0v9AD8uD/s6FOUG9R3Lj7JFm9ruBiK5FCnQchVgdvIBkSasFpc8a+1to/99doW1dYEuP54O+qEFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KTDDmLy6; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KTDDmLy6"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c6788f3db37so172082a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 04 Feb 2026 22:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770273391; x=1770878191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vH999gu9cF8Ex6UpWJyf9ehfO8DS1HfN7WwuwJxfEkk=;
        b=KTDDmLy6a+k2mCqp0SCBcenrUJfI+vId1eEDkUMtM1P5VNlxtCTRfVJMc78gYk9qbd
         j9YslvakJEsyduvarmgnju2tErT8kVFbzrkK6Gps0Wgrhe9ztjLOYJ6x5h3YkR2m1ALw
         8CcEs3XGUh/vhs5P0JfYhkRWPErOtlcZJl2zqSyxxlURphLb25tlju8tQRPswOpCCH0D
         ABjmF+06KGaD0vnYmjJhGHqcJS+4y2YWoWk8t0sJmYgDcibtHgtlD8g+NAejwjZql6c7
         SBOjRLfmrLHiy7QsvWX3XwgYsCKN111gjTUj2KTtVwiWY/PTCXkIhO6/9zTO1XJJcGhJ
         62xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770273391; x=1770878191;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vH999gu9cF8Ex6UpWJyf9ehfO8DS1HfN7WwuwJxfEkk=;
        b=sqCISKc4dlM5RhoI0QrEyX38ZXwdGpE8k7oygm/moO81ICxnAdHN4+2bOADXex5fgx
         B8GJ9P4lSa20BtmkA1UsD9COurrIkU4hYsNHA8pRGy4ZMJG8NPTV00NAUnW9WJpdY+OE
         MrqwhfrHApIooXc9XcJhAQ3czO33s8xP+66C+in8H3LuXqeiJOWPB2qHn0YYL+U5X73m
         mzWpFWhxVRjR/minF2td/j33NqBUrWNi2gLPjEppW5yr9/S4WZjRiIUDsQuGKJR9DYVK
         +1x1RqcLwchwD/8ftZm+Hit8tiLK5ecPDFZA2GPLx8VekA9CSjZRQDRxG8vt9vLDzoHU
         fNRw==
X-Forwarded-Encrypted: i=1; AJvYcCXdvvyXmnRSQG7uFl/cRzstmaApDUwSZ4WlycQnLpObZk9kGkbyX40etRuUFouZ8HT9QsmX9eqD65o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMzKSn+YQOB8qaHGm0tqcxmHsCG/gtfJ3CaWqeOZguU3Q8y/mk
	vwToIbP/Amw9zv4pALiaMIkAx7xuRpwxThHdEU3CLAdpCxuDLE8OxZmp
X-Gm-Gg: AZuq6aKuVKQY6hH16MuwDmYO8ny12EakYJB+gxhP9OJ0gbor5SxMvhHOEs1v/XqHi0e
	SAUrMfkUjJ6eCaHeAupn1/Icut6eUsUs1IcdW6713UgK+SbnNhdZXKebvEF/J3/cJ1XsEJkvUIX
	Xmgt/6nc+CqwIyItcSg3aVwXoMnLZ1oqxr2Xrlv7dp4JOwaKmZ5nyuU/J6m23W7WpL/9xqBCBU1
	qoJ3xvlPWJgCjB6uztK//s6N3NHkSf7VpB18wQ5S8hyy/iki7lDAcs7bDDYetCEnwHzamPNGiqY
	ZmwQj4AMeKxeg1RYYZkiEz4Ndxwm3mD421l8Ny08SctlAuHHN3n8xw6VEOiGKctoKDBQDkUZ1sG
	eJnmvKnwIKvgB/4YxGwXZBd4jNkNaIdECMFnOYD25auxBA11masLQ4Sqa8CNnbfmp990h3JduvR
	SZN8A2vjF4G+bnHee26/as3L47Fg+aGMPToeS+pzTxo2epnB5LbgRjo9UoEN27/mEp
X-Received: by 2002:a05:6a21:150d:b0:38c:627f:873f with SMTP id adf61e73a8af0-393723a5662mr5102313637.45.1770273390885;
        Wed, 04 Feb 2026 22:36:30 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c8321cb78sm3885009a12.8.2026.02.04.22.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 22:36:30 -0800 (PST)
Message-ID: <87a16d4d9c1e568a37fa07a97dda5777e14e9a8b.camel@gmail.com>
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and
 dirty-AG bitmap
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
 cem@kernel.org,  wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com, 
	vishak.g@samsung.com, joshi.k@samsung.com
Date: Thu, 05 Feb 2026 12:06:19 +0530
In-Reply-To: <20260116100818.7576-4-kundan.kumar@samsung.com>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
	 <20260116100818.7576-4-kundan.kumar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
> Add per-inode structures to track predicted AGs of dirty folios using
> an xarray and bitmap. This enables efficient identification of AGs
> involved in writeback.
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h  |  5 +++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e44040206851..f97aa6d66271 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
>  	return XFS_PERAG_BLOCKGC_MARK;
>  }
>  
> +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
Similar comment as before:
static int
xfs_inode_init...()
> +{
> +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> +	unsigned int nlongs;
> +
> +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
Nit: The name of the functions suggests that it is initializing the tracking bitmap which it does -
however, the above line does slightly different thing? Maybe move the xarray init outside the bitmap
init function? 
> +	ip->i_ag_dirty_bitmap = NULL;
> +	ip->i_ag_dirty_bits = bits;
> +
> +	if (!bits)
Umm, !bits means agcount is 0. Shouldn't we ASSERT that bits >= 2? Or am I missing something?
> +		return 0;
> +
> +	nlongs = BITS_TO_LONGS(bits);
> +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> +					GFP_NOFS);
> +
> +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
> +}
> +
>  /*
>   * Allocate and initialise an xfs_inode.
>   */
> @@ -131,6 +150,8 @@ xfs_inode_alloc(
>  	ip->i_next_unlinked = NULLAGINO;
>  	ip->i_prev_unlinked = 0;
>  
> +	xfs_inode_init_ag_bitmap(ip);
xfs_inode_init_ag_bitmap() returns int - error handling for -ENOMEM?
> +
>  	return ip;
>  }
>  
> @@ -194,6 +215,12 @@ xfs_inode_free(
>  	ip->i_ino = 0;
>  	spin_unlock(&ip->i_flags_lock);
>  
> +	/* free xarray contents (values are immediate packed ints) */
> +	xa_destroy(&ip->i_ag_pmap);
Nit:Maybe have a small wrapper for freeing it the prediction map? No hard preferences though.
> +	kfree(ip->i_ag_dirty_bitmap);
> +	ip->i_ag_dirty_bitmap = NULL;
Nit: Usually while freeing the pointers I prefer:
t = ip->i_ag_dirty_bitmap;
ip->i_ag_dirty_bitmap = NULL;
kfree(t);
In this way, the pointer(i_ag_dirty_bitmap in this case) that I am freeing never points to an
already freed address.

> +	ip->i_ag_dirty_bits = 0;
> +
>  	__xfs_inode_free(ip);
>  }
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index bd6d33557194..dee449168605 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -99,6 +99,11 @@ typedef struct xfs_inode {
>  	spinlock_t		i_ioend_lock;
>  	struct work_struct	i_ioend_work;
>  	struct list_head	i_ioend_list;
> +
> +	/* AG prediction map: pgoff_t -> packed u32 */
> +	struct xarray           i_ag_pmap;
> +	unsigned long           *i_ag_dirty_bitmap;
> +	unsigned int            i_ag_dirty_bits;
Not sure but, I mostly see the typedefed versions of data types being used like uint32 etc. Darrick,
hch, are the above fine?
--NR
>  } xfs_inode_t;
>  
>  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)

