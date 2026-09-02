Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5477637BE70
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 18:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788373351; cv=none; b=NX/b+LFpEpAlr5AwGilCvVjKyt57v1emJlIjKH5V3x84Gac9MgDMiBAKMzpDWsl/oG76qGaZvJTg48o1VZ9VnjTBbr7Zx9GgDGBdEqpPvmC+6Z9QChn0aVSCNZUND7bwYErfhoiWkYG+i0QAipnuMJkh+isr4flWMMlwdzDc4yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788373351; c=relaxed/simple;
	bh=NVVTGnB37/fY4kDzzxNAhZ2/5WJSJaVtQxGRcCwpNPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fYCfWyf3itviVFhN/4IetOxhiRxp8Uwwl9j8vjDXJ4uuYW0vGjLo5t5TNBKOoc0Ht2OVqTawlgrgX+qIvIoVgGUrf2UMXDEbzAZzvWkyG/tnb4AmY+8BqFcL9AybtytKRBo/+cmG/zDvnoXZZ1UESSg1urAwoEVMXNx+/RiIf3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ec7IYQ2q; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ec7IYQ2q"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-398b3c37877so1859583a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2026 11:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788373350; x=1788978150; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qPrGa15l+jPzGGVJJ+aWuDwK7J17t8ka2erG7mJIoHw=;
        b=ec7IYQ2qpVHYYqvZuFz/wcRrv+BcMGfvnuXTjUAKO7k4CwoQ17hSYpMju1sZr3xS2k
         XKlesOOeAenjvL4ZXImfyNCStl7+c0wBZhRZbyJo6NqJcfln+z0aXB08ttyV51g5m3rc
         ZjOD251vtaapGLje3hBpKv9iDIMruXVs2azPlc2jnhHrDvXvNpxxCqPMps4tzddmzIwO
         +uc9vGEs1Pkq6ztpUlzb/SCMblqt9ENl4eaBtm2NisCGtlLA44ThcdU+V99rXFCrMxiJ
         nhUgF/0oF+AVb5CyKeTHRby7mLih4Y67SX/qXGfkTGRJENvtO/5UbEiPkWa6h1WzYdNC
         UwLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788373350; x=1788978150;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qPrGa15l+jPzGGVJJ+aWuDwK7J17t8ka2erG7mJIoHw=;
        b=ffy4WmrqtIhxct8dL97wpF0gNBYh4C64GsVJuqKL5ip4t4Cj+tJXiIJxNUy9P1nouJ
         gh2sqOSECRqcQtpZlq9rapciTi5cIerCPfochk0+iBUC8Nil0uRQHiIo629jQAa6Ntp1
         ZwBq7WsUUCoViEpvBr+Tugs1xCtx18CkY5hnfHlta1ZpQWW+7JiipsI/7oajvlqQFf+/
         pCCvHfqpbAQHwNSpMqeHQoUG5KuzlX0P5kH3UqAdUBAaxonhgTYJ1vPcV7ud4xPm8i9W
         LsUBaX62ir2FGbbs/E2ljRpUT1lc5mGD3QmJ6H789r+Cc9zG+zxFAvbmWbj9o1VmNwqA
         8oJQ==
X-Forwarded-Encrypted: i=1; AKwUvBwUcgXEtLsXhDk92guXVaDguORMXzTyweJDmjdLA076tZUEFEgUKxejNX+ToUrdO68BD6vpzilXdns=@vger.kernel.org
X-Gm-Message-State: AFuF++mS1Uwugk37ae6j5vRRs531H2yvFRsxLblNFLkI0hkS4XjLYZ09
	41mrEoWPfmCuWTENr2U/fWP9XGJvARZaR6Eg5v6OIAbwu8JrYHUWfYApE8UBsoo=
X-Gm-Gg: AYBFou2MtoXPv73uC3huaGB9Dz8tn2TAkD7lMpyv1eOWFUaSPsp6Jt2Yc5NDtNV+Auq
	/mkuFUbnJjfnBwuaH6pJXqsSFd4e/2OyQT9v53xaeuRoJ7jUn73XDgzVbKKJcAw2tT40T0ng9lm
	TtX/+FlZXraKV7BlLjSyfqnNtEzaPk8Q7A+Drd/tGeIUjJoUJytCKKZHujBYe7P5csl5gsx6iGl
	sviHR2TRrF5SQQ81IQxLQbsBClb8mTQKvs8pFxKCOFRf0jsIjgFcW/yyugM+SzFOz5L+m6FQUz5
	8BX+GQU3CdlKt26C2HR7KIQzMhk9P0KD2agzQtYnaKHwbiDtvENk5U3ucFfA3HzVQxsaIlGGXcT
	GLZN7FQQwXW6AB0a6GFl2zLrUaXJyTE0K6+zJD88Hm57glN/Cp5nlW9XkRX4R+Btk0/Na309W3X
	4FqTX9OGDTs+i+Xjh6B72GA1OlAk+UcTnDVp4ijXqLEZFV9qV9xGBA9n7nDiDDZhwlDAEpolVbB
	msdbMUM+OVBs9IaGcDbkGwSOJnqyR4WYgnZDfM=
X-Received: by 2002:a17:90b:4a07:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-39aee0e5ca1mr8288945a91.13.1788373349409;
        Wed, 02 Sep 2026 11:22:29 -0700 (PDT)
Received: from anuj-MacBookPro ([2406:7400:63:f76b:3efb:3463:cad7:ba39])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f079f1f4fsm8613791eec.11.2026.09.02.11.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 11:22:28 -0700 (PDT)
Date: Wed, 2 Sep 2026 23:52:21 +0530
From: Anuj Gupta <anuj1072538@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Tal Zussman <tz2294@columbia.edu>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/17] xfs: move PI generation into xfs_submit_zoned_bio
Message-ID: <64756fpdb36bljyx6zmlcgdhv6ksly6zfhua6ierzga2jd6bl7@wyz5ar4cbba6>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-10-hch@lst.de>

>  xfs_open_zone_free_rcu(
> @@ -890,6 +891,8 @@ xfs_submit_zoned_bio(
>  		xfs_mark_rtg_boundary(ioend);
>  	}
>  
> +	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> +		fs_bio_integrity_generate(&ioend->io_bio);
>  	submit_bio(&ioend->io_bio);

It seems to me that IOMAP_IOEND_INTEGRITY might never be set here. The
zoned write iomaps in xfs_zoned_map_blocks() and
xfs_zoned_direct_write_iomap_begin() do not set IOMAP_F_INTEGRITY based
on bdev_has_integrity_csum(). Should both paths set it? I didn't have a
zoned device to confirm this so this is just from a bit of code reading
only.

This looks like a pre-existing bug from 6bbb4d96f797 ("xfs: support T10
protection information") which can be fixed with something like this?

[PATCH] xfs: set IOMAP_F_INTEGRITY for zoned writes on integrity devices

Neither xfs_zoned_map_blocks() nor xfs_zoned_direct_write_iomap_begin()
sets IOMAP_F_INTEGRITY based on bdev_has_integrity_csum(), so PI
generation is silently skipped for zoned writes on integrity-enabled
devices. Add the check in both paths.

Fixes: 6bbb4d96f797 ("xfs: support T10 protection information")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_aops.c  | 2 ++
 fs/xfs/xfs_iomap.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 76918bd15ca8..f813c0150c62 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -459,6 +459,8 @@ xfs_zoned_map_blocks(
 	wpc->iomap.offset = offset;
 	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
 	wpc->iomap.flags = IOMAP_F_ANON_WRITE;
+	if (bdev_has_integrity_csum(wpc->iomap.bdev))
+		wpc->iomap.flags |= IOMAP_F_INTEGRITY;
 
 	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
 	return 0;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 225c3de88d03..d7d88231d28b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1086,6 +1086,8 @@ xfs_zoned_direct_write_iomap_begin(
 	iomap->offset = offset;
 	iomap->length = length;
 	iomap->flags = IOMAP_F_ANON_WRITE;
+	if (bdev_has_integrity_csum(iomap->bdev))
+		iomap->flags |= IOMAP_F_INTEGRITY;
 	return 0;
 }
 
-- 
