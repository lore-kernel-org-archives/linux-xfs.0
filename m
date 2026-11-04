Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829471;
	b=HphBLO1l0eiWRIz62rlud4MyfMiwo6Gc0jJr8KoajSxfMvtLV3Romgpb/cuMBzCKO80p
	 zGPB8gi/+W+MQt1auIHKrkatjC74DVcw7lpTGG5J2WzGJVrtrs0C0Kxn9/0J0/pJyB8/I
	 XE5ie7FQNv8PwRo0dCS3yVLL3G7ldoz3Y3TUNU6ENbFerRrRKulZyKWlmZ1yZzzGIaf0a
	 3lsWXq6C1pS2Lo9AMqclHgccuNxQAQzc8p8NpuURk3tp7pdn8bBhBwa/E7vyfaQto6JHR
	 PKIFRHeo1Xhwjm/58L126qFvd0H1sJrN+c0zdV2JRuDLazGJlmNLgVZaITTmjOWaQiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829471;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Pt10OpIafDHO+/s8UZzP68e4Ey+bkeQd5gvZCMNXoJs=;
	b=xd8+QfgrbqXnP8CMJuyz6x91w7AjusxLpFUUc7nz+LhB6xr/q5OCRwrxc5BW3AGKPNQV
	 EEr2GYb4jTgPbb6eNMmNPopEj0vZYtCXlMPSBZbSsmxBUhaCtS1XA8vVDL6zpiJYWSaWl
	 /OTbacpgo174TbLZqNhCb9tqCcp8MLjU4rpd4F09e9kFeyf5c9bFA9E0wfdFB269cZIfw
	 Fz0QHn/YxGuLc699y6ZoatdK62MEsoOA01pAKNe7aTqP6eMZdUzaYmz9mXHq8EZdKVOhp
	 pkofeByQuNnKBt4jYqKyPZ4LjCDFwgQTtAoCkzPm2AgSFSGsvS4jbdZAjfZmHGgM/TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MAca+erH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A125D606AB0B;
	Wed,  4 Nov 2026 21:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MAca+erH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110E91F00A17;
	Wed,  4 Nov 2026 21:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793829471;
	bh=Pt10OpIafDHO+/s8UZzP68e4Ey+bkeQd5gvZCMNXoJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MAca+erHy9DR7OyreR+xCs9Mb/ZuNFmIA1Px0E9Wf3rP6Bz4Md7LYWALQDukRMQdh
	 P5pYWT9fx/UHsEJMno83Tf61qCmIeZSI3bKLpodUjU2ty4+MzYeswuyT857wesl9r7
	 QEWaeuWTjq0lUPDsfeSFMK5ZcCnDTs1q6YqVV8sEIe2bUb7gLV0Ir3bTQlp9CVhUPz
	 yc+hpzv6ncSncR+9+aWvAnAJxCwiCAL1amJ6wsw9t5bDBUWDSxU4yRwKgXVTyS/3iN
	 +6xPgugAWGGs1A37hLKpGw285h8qkstXE7CkrflkXghHAyhWwqcqh7GFa+kvdLKtw1
	 nb4ye4C9X/LqA==
Date: Wed, 4 Nov 2026 21:57:49 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@lst.de, fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/5] fsverity: lift ioctl() input masking and runtime
 inode flag to VFS
Message-ID: <20261104215749.GA3648616@google.com>
References: <20261104194618.103332-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104194618.103332-1-aalbersh@kernel.org>

On Wed, Nov 04, 2026 at 08:46:09PM +0100, Andrey Albershteyn wrote:
> Hi folks,
> 
> This patchset lifts two things from filesystems to VFS level:
> - No-oping FS_VERITY_FL in SET ioctl()
> - runtime fsverity construction flag
> 
> The first one fixes BTRFS get-modify-set loop with
> FS_IOC_GETFLAGS/SETFLAGS ioctl()s, as it does return fsverity flag but
> not mask it out.

Changes to 'struct inode' should be Cc'ed to linux-fsdevel as well.

- Eric
