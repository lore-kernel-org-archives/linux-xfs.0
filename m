Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E71A3F327D
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 08:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789374545; cv=none; b=kGu5+b/1tDaObIpjm7VtgUZcXGUD/hOd+GbV4/RPGgLFFaYiuQfe3acICGehaHuA4okA5fG75hvJJiDBCEgRzUqpBRa9hzfemtl1VAZevELWoDug1b2nF3FOsSPHThYtNYSudtMN8f5bdDzR6xqAl1WXx7EkuVnywzacdNTci/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789374545; c=relaxed/simple;
	bh=CjuNn1/No3FEU8yWgNe8ewOXQ1wYxLNz09ITcP7PWGw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dSTUHLi9ib6+sjVIUZkvlLWuw0iWK+xXJq6vE8Z23ournN9El25XQrhs0qervnS+EzQW7QtcNlyYrFEpoSIG85pGwcNtOP2SZSidwd/9FosRMe+lIk9mu3V6503A1urhl/2UmR/wsFJOXuP46CcQOWVqnGKvCQ+SxpMD8h+lZxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GLBabV0h; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLBabV0h"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccdaea75so604588a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 01:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789374543; x=1789979343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CjuNn1/No3FEU8yWgNe8ewOXQ1wYxLNz09ITcP7PWGw=;
        b=GLBabV0h5vdyQXBA9p41HtZK7GfpqVz32p/SRlLRwO4pb6faBzqNKGAu5kQqu3sH3s
         gOGTGQIvsDxvwnr7CQHmWQzpB//rQuHrbhRo2q61F5CG1zY2UcbEd5i87wGxC/rd1RMC
         xnU26cDPXtQz/SNuwkpsi3h/pbCfxd2MVFLjZ1mjb8dUx08l2GiHPSvWyhuaRZTWSdt9
         EhMZRpDhSDSHoaUwobsDkAz/vKiDJY1AB/CVm726qcn8bDMnIvjyLjoBq4Tk44NGxQJ9
         QT1vfKw1g8/ocq/kE2r0a1/s8pUX9m9C0ey5JDIvaVNsP65gFAO2ybD51gdOeHFv7U3G
         OUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789374543; x=1789979343;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CjuNn1/No3FEU8yWgNe8ewOXQ1wYxLNz09ITcP7PWGw=;
        b=Bko37VrgnowZX/RKYlmDl7uKa9GG01KyDkHTWybniA8jQ3V7xOdedqoGAxLhJ6mQVy
         oR5PoBfbtZO0PH32Nf55hx/jPuuiB+KceY1+gY1cir4Bl1/XdgCxZnkWdgr9WrZl+Ggf
         tc4q12F9R6YeVf+WpakSYDtNJ2HT8Cd8WJShqbjf+wTAu6fZnrmXKvcHhQReos2I0e/E
         mSl2Nm1zQf4bN4Ahan0U5JxjZgqfmxmEI08BA+xEWVt4iJb8UjJhmGFPrRMz6cTwxy7n
         xyQ3iSP2tF7LeArbkOlT5mm4b32VwbsHABOxiyqeiP+g+2nJMVgtQROgAgD2Rnkq+nPY
         ElIA==
X-Forwarded-Encrypted: i=1; AKwUvBykYZeFUCkvWmyZqP+OvUq3xkyb1EruAJS0K94l3Ib/cnzLOGDU6EXd5sat+Y72wkF8A476Mxtmk1w=@vger.kernel.org
X-Gm-Message-State: AFuF++k1ayQsntH8NCpkjbmJZPd6GtfzBif9A6FP6PID4c8XTbi9o6bu
	fNFGg2A0nGeBIjrDR3JsBvTwNdgYN3OnHkKej29g8QbaLdzUoF3MIqYVeysuCwUTs2g=
X-Gm-Gg: AYBFou3wLzxG3+pNaeTkNTqkX7z6ua344lMUZKQnzWc7ZOJXBI+ZQFpZ2sJCNnBpmc4
	JZ+LbQ3ST3ZYj9RlnopfgrBXUbMwr0J7ZzVHwc2SpqQ/LyrkCQL9NCD0RyuzPn1JkH+FVZFT9kJ
	yu63WmYPnKVpKZpLAMolyutjcz26aoDOHfgbQtbgw1sdH/4bINaGyo14I9eHfXPMHuMdy5KZRyl
	34rmo/c5DUtEyc3H3vYJyPrTCLYX/2qvPhq7/v2kVQMrf5vIhyQaXnHZ9JhAej7rPIKDTCq3JtE
	IVhqRiP5iRxuxr728BCKdkVS6ByAOTRluZaXoKWOS/WzaJ5f3qe3HLkhisPs7PfqMVhDjgE+ShS
	zLP3satUnZuLkbS6IZ2SEJDPropyBZ4JhuE7yOypnsa3c+TPpE9i00jEsfGe78LB562H1Yj2luT
	RNOx6PmdJ4LlwJ0yZUu7PNcORtehgCyLlFJCAQy286h7oYExm0aepFzwBIzVLEEIYV2SrsLZSlg
	Oo6mEqe7RFgw5Lv5HEORXo8inOkXYsXryX8un/TyjrrEpmfiW6Cji2Igzb0m4HeYh7qX2Lm9+Pr
	Ahon8ecp4e1gzqvYakcVce7iceL/Eyeb9f8vRHwJ9aCz6ogqtnuYmbLaePaw8/jWVuCOQz/w1og
	Uv/YvWz9I
X-Received: by 2002:a17:90b:2250:b0:398:c6e8:3fc2 with SMTP id 98e67ed59e1d1-39dec3a472fmr1681646a91.4.1789374543294;
        Mon, 14 Sep 2026 01:29:03 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.t54fbfa9bf0658dcb-tp.internal (189.207.21.34.bc.googleusercontent.com. [34.21.207.189])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d994872e0sm19843658a91.8.2026.09.14.01.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 01:29:02 -0700 (PDT)
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/1] xfs: prevent close() hangs on frozen filesystems
Date: Mon, 14 Sep 2026 08:28:35 +0000
Message-ID: <20260914082836.1658-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Christoph, Darrick, and Carlos,

This is version 6 of the patch series addressing the close() system
call hanging indefinitely on frozen XFS filesystems (Bugzilla #205833).

In v5, I introduced a transaction allocation flag
(XFS_TRANS_WRITECOUNT_TRYLOCK) to handle the trylock inside
__xfs_trans_alloc() and propagated it down to xfs_free_eofblocks().
Christoph suggested this design and reviewed the implementation.

However, Darrick suggested that the deadlock can be resolved much
more simply at the VFS-layer within xfs_file_release() by surrounding
the existing check with sb_start_write_trylock() instead of passing
transaction allocation flags all the way down.

This v6 implements that VFS-layer trylock approach. It modifies only a
single file (fs/xfs/xfs_file.c). If sb_start_write_trylock() fails (meaning
the filesystem is frozen or freezing), we simply skip the speculative
preallocation trim.

I would appreciate your guidance on which of the two architectural
paths is preferred for XFS:
1. The v5 transaction-flag approach (centralized within xfs_trans_alloc).
2. The v6 VFS-level trylock approach (localized within xfs_file_release).

If the v5 approach is preferred, I will rebase the transaction-flag
patches onto the current master and submit them as a new version.

Thanks,
Aditya
