Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753392;
	b=YwgcR1xIK3jKPzMrhbEgSGkJxnhoh47KmIJ7IWBYfiWETr6faEm+omUteaC6XECo8y6K
	 qHAMOy6IwE3nywO24yFM+6lMj+EerMWbDTG48Jf3lFnykemp3pRaf7qGkFZx30lUvfBtr
	 TmLWM5zLFLMipeMpV4jbHocpdGztUTYUKFspBSByDD2wjDJ5S7D01JlEL7NaqpbtB70Vv
	 2RaoOz8ZIvpvfiXV7CmyGjEGCE0n3fA8mGIUpfB2z4Gk81mgY3sx2u1wnyovC0M3rixXg
	 Efh7wh4swEwEIgOraC+/886Y+aIKXkSYCECbdstPJ1GP5FtKaMZM53mXGK/pJ4aOvAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
	b=d9JhiL3/JcV8QQvEMzoo2tpSMhDXsa8uOQgu5fPhOdwwcMslfKWYvPPHTJ2qxsDIVXNg
	 9BgNZsARH/sP+GDC11TSp77AvtqLecViTlnSRLvwAvg/rotO9rQHGcvjOikp7AHk974IT
	 4qpZFHdpZ3tiVZwIPSeHjduZIcCcfsE7BnR37L4y+9fcqu0TKC4f7T/c7irLoPDK81l4Y
	 E8vG6HYqjR0VfG2X3p/oU2X58WYfzprvQXu7aFQFmZgBv0qT8erSLkDKlsrQou4CBb+Jp
	 z+p6oQEI+1kEObwL1+WVyFBw0SHVGQ5Ii3mi9Lr8I7btOqEDnxzR7gZzk8HHdqjnl0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VT+pUP2N;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBFD606A326
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 00:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DBFD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VT+pUP2N
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a06e79e152so124920b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2026 16:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753391; x=1794358191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=VT+pUP2NwuZcLnfpE6RBehWP9rj7p+v+tKoR/WVHOzz1v7CJgJGu6gqjY1V/YGEdmw
         igNrVOnPTFLv9xvYK2tnZhcPD4jqAzwLjDlQ2iFsJIT0vgZOsXkUB60qRSrv68Heg2+2
         k5XkKmMrKWtBUKDoGvgF6CjyKJx7mmzehyXgiMW8Z51NtcdDEa4LvP5GkI/GPk/JWdX0
         E0pyc83t8pyqA1wDQ4YMhv4IP3UIHbsnnJtT4+s3TyxuI9ePzpN8dD0BzwPhXNBIUBNN
         GS4KAdHBqzLrJ9upnMsWdUfiG2GuZuR+cDGx90+hJalABWpp8S3bPmquj5j2mZuikn7l
         6bxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753391; x=1794358191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=qzFFcij9HypLVc9vly8UXnTLo2TSbTR8y0+bLOCDEGwqhQIVTNKx90J6udPuMd7MCv
         1HsDwUOtRltNqjufw7yIF5kx1+2M+NfmjRt7Q1mMOwsVQ62PmJ3X/euOEbDbDeSBu/J4
         glWtYXkEjetxt9e+FjAbZkXu20+UvQ/peqrvgV1GZwdmfb43GutpezIKccehz8PZQAUv
         sguXhcm7GDX+wB5Ra+CdYuMLmMXR6+ZiRKm2gwhcMsyl/BllgQtCHwn9CQypGacRKrFC
         FViVV8SD1ZrV9EZdU4gS3J8BvG3xd1HGOwHb3NQG8bL1II23Z/M3GOO5Jzc0BB52TcBq
         vaaQ==
X-Forwarded-Encrypted: i=1; AKwUvBwcXG9YS/4PXqMCajfyvPzAvGcpz8OUSoSMzdxPjtg2O/AoUYO7ioms9rOa49lQ5S135piW7HCP2So=@vger.kernel.org
X-Gm-Message-State: APuU4Z+MDCzPO2WR0x3x1Bl3A1orML04gkwU3x6jdY2qM7gMdrZOrAhS
	WsXV21yoN0ZzDrHkupNbbpuO8MomhhMmY03Dj99lcXxw7qLtNfDhn6y/
X-Gm-Gg: AYBFou28ES6pRWMFyXmHEqsBl4aoze4kD/XtqQUKbRwtHbwUsX/ULpNexTFePTS2nI5
	RXLV0HrJeyiXcHYUNEOsyW45afgRe04lGsnBvNStw6QRe61mfulkp8xDFLcY3piiZRtxIHcLydL
	GZwqiG8/f1rPUJkrOZK8/0OP0YuZXQFky9R1moKNX0yJXoCFpA9AhBRDlt6b9Ti7T4YCD+QAXQ5
	gLSJ/qflRnZzs3c9p4FXj7ichN5Zh2dNW7tlnBHVlvAX0ACQjiEI76nNpE7cFXMIy0g3Eo7coP1
	Gi54+DJyk3Zf7QvevBZ2vUcwSapF/cwsuvQHaGKJA8TXMP7rNOl3Exswa4grG37nIrmw8NI0qXB
	Mp7Z2gN5hE0xTCQhGJ20hpbznbJp/9QY1RCAoqUAA1A9JJ0yi5oFjYTVjtSKkB2DQK65LhpCNtB
	VlzsfUu5AbdT2G9+2pSJQ3Jn4IVyon9onG7iwhugeibGb3yXHEPaDXnh7+V2Z7hcv1e9VheWjhQ
	oJSvxoqBuEhZyembNWZ/Qpj2vWEhxjLkRK/OFoQWW7tcr5eggXsbYtmqCLhjamvrRgFl1Iu5oB6
	b76eqO3OM1py5Ogb/DHCPkRQuXbwdAYRR8ZQHGA=
X-Received: by 2002:a05:6a20:914b:b0:3e2:9470:5303 with SMTP id adf61e73a8af0-3e928953948mr11828504637.15.1793753391239;
        Tue, 03 Nov 2026 16:49:51 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb46440cc7sm329325a12.3.2026.11.03.16.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:49:50 -0800 (PST)
Date: Wed, 4 Nov 2026 09:49:48 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <auqBLEvcurRZfGj6@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:08PM +0100, Christian Brauner wrote:
> With errors=remount-ro every ntfs_error() ends up in ntfs_handle_error()
> which sets SB_RDONLY without holding s_umount. If that happens while the
> volume is frozen through bdev_freeze() thaw_super() sees a read-only
> superblock and leaves the s_writers rwsems locked so every writer hangs.
> 
> So set NV_Errors and a new NV_EmergencyRO flag instead like ext4 does.
> ntfs_emergency_state() returns EIO after a shutdown and EROFS after an
> error and the write side shutdown checks use it now. fallocate,
> ->set_acl(), FS_IOC_SETFSLABEL, FITRIM and ntfs_mft_record_free() get a
> check as well. Errors while mounting still set SB_RDONLY, nothing can
> freeze the superblock before SB_BORN.
> 
> NV_Errors already refuses a remount to read-write and since
> commit 521978c4f444 ("ntfs: sync the volume dirty bit with the recorded
> error state") the volume stays marked dirty once errors were recorded.
> But the dirty bit may not be on disk yet when the error hits and
> writeback is refused from then on. So a work item writes it right away
> because ntfs_error() can be called with mft records locked, and umount
> lets a pending one run first.
> 
> Unlinked inodes are left to chkdsk in that state. Their mft records are
> freed with direct bios while the index and bitmap updates of the
> deletion can't be written back anymore. And writing to an encrypted file
> only warns now. It called ntfs_error() which let anyone put the volume
> into the emergency state.
> 
> /proc/mounts keeps showing the volume read-write. Writes through file
> descriptors opened before the error fail with EROFS.
> 
> Fixes: 6251f0b0de7d ("ntfs: update super block operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
