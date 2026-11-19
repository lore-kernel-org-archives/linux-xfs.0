Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082461;
	b=cXnLkJoBtE6SGrKAlRBQ3+A+ID28Wvm5FriDBPyy/i2MeEDcaP0HP8dMjzcDp8GpXGI+
	 G+dpSD9kboMS0DB6VtuGaKcF+m5TCEBJlzuGfONH0RTDxLOqAKTzFUytLqFn63BawobtM
	 xbtrmpRk4x8bSOhd2sjlVNYVywaiS0zF5jbhSXltIKhnP520YCzHypRb2PqONA5IRiByB
	 mYCTVuDKjU8vzC56OaDzUyR4RRSQLCWBfyRcR/eu/Ckw5gFhrqHsC8vssGraffgO6HY+t
	 X+/PhZAXBPNZBSe5nBPFNxkpQB8u3NgJEQuwoMZAiXSO8YgwpLtd6v8JuzX8scgpFMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082461;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
	b=Unv7EC5z/YJCh1SmiZFCCAii25oSxnnBk6fuuRlUm+2leNtMBFrJrd7NAsyChU5b90Vj
	 yuDhdwPVGFhhC8iXP13nnwrNfw9QxkLdzbk5yCYNRIS3OOBX2UaH5aDbabbpCOoakqyI/
	 gOeEKImAyps5Lt4/iG9YgcUjfwK+eP+8TmOPXPK9frStnaXZ9hkadAw+0qK+kbV7zkbfM
	 k5VlAcZWK07GIqIgD5wA16n0hE2WJjJtaphgwF8UK7I2s1IX86zM7orIZYytRG+mZhFrO
	 so1uCgYz91cGmB4wIeZLxC9Y67/ShLJT49Z7j1uDYt5u4rZEtcqQIG1xgVGdB6N/GGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qQtx8HcI;
	arc=none smtp.remote-ip=209.85.208.177
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF80606A324
	for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 10:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AF80606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qQtx8HcI
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3acd523a802so18989791fa.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2026 02:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795082459; x=1795687259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
        b=qQtx8HcI9xOYAewqsC1qeKXYpNZYkorGxO+WUf8GNlozJTjTfjp6RYu0ME9dnQS7SU
         QlKY2a5rrUaalMRM2QkFx1q2fMNmh0+6Kx9oHBLriNElluMZgw2IJqtD+3DSP2pgxNzk
         2TmsS6xkE/qzDTWdZfTpZ+KAbD1lTDxAfFCzr6drsaxvmeBYV8fzzvm70Eui4lhqXTnh
         HgbHImFNfpvHwHXydOauwOfe17ING4Q6TVfyd4rcZEWzKr9mr4fzMJ+Vemn7/3JBMyOg
         1EBPQX8TZZCNUbaVOuHs0Ki+dm4jvN/9bSy06FQShgIIqQcy0wSxBtWSC2/KV4f07jNA
         MUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795082459; x=1795687259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
        b=atEgAEYDH019BkG4ZCGDrTzq6/wG5/BL6Zfn7exAaGRUIUZVkNR4w4JLhCwZfHO5SQ
         zkjHR80GBKJhOU3TgMRIXESJyEMi3u5mXrqqNgZr3kkNC2A70Jry44Wg85ZcI+eIfVEk
         m+V9qddWX/pPKi2JCxWyjGkExSeNL6Szw3fmWd4B9EVWLGesReprozMyj7YaJ/mVfac8
         n1bk+yfr/tVkyJw9plyEQaqLWAwkUW/tAk0+xxpBE5kz27wyXpBuUztXVwY2YDchiKWT
         /FlRvFRUdSTekuns9bI+5DRPaU4NLs/Q1B44+42MEYbTDc2vaWxkRVxNVhGafPTODhv/
         cFgA==
X-Forwarded-Encrypted: i=1; AL+hErF8ySmL3ByVbRye8x0QWFlqEvN4OYEL3ndIXhgblC7Pxd6slZ045gnin67mJy6oEojmUp8thHzwiH8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ce+r+Ouf/nuu7iaoIE/KGGCzJfq3g1CkFUabnqhOmXK4CF3AG
	FAi8zm5JQ8Ey/0JKB4zImnLNkpVnFp6ydAIYPjv4ZZ6s6/m1tVOaLl2W
X-Gm-Gg: AYBFou2G8RAGAZ915qGO2+Rsa1rGVAfyK1dL4p3lIegn8qyU11yBLVo9yTxE16+Ktd2
	/YePtBQH18zPbIcpf6ShOxmt0JY/9TNjDvYYjQInphho5mhebVRzDxYPfeeMF/fCJEdxnjxh5P6
	UP4ZbyUM5T0xqJsqadERqV0gI6ZeyjKnIe/rAYnU0msypgwORyY/EHd8QKLQ7W/EIU/C+aMnX/u
	Pw0DvqyJMjz1XvnatBN4wKMX51FXtxDDwEWu5J1BVhVqvKQxKaQMxTpMXNbde7Ct0vC+fC4jrXR
	kaTygndAXpu6Rw4J375ajBtnbv/aylFWoWqDZ31Los0l9084hcgYcL/BLZC8fu0JRR4xAW1+lVc
	D+ws0wFhyXR64N149sj9AWZK6sFr7r0cmEouoS1sHiZeG3eSb6iWftUFxm2sZhxeRDtXSL6ecOC
	SH2wCkIvuABK1saQZtyLR3jzXGa/v2VS/1IPdQvIzhYb7vLWWXHuJzu5iIQ/YmIVxHK5mI+Oj7U
	FdhZb1c3sdpnZRg+XU+SUeajz0vfAWhiZGwNlbLmnkColQQpzmDGw68XnD0UbdChoPO3MgZWJG/
	ZPJN1rOyDq0dqL0mC7JDTcW5didOIRvhsvpChHbGDqmP+HsZz9G7RxqO0bs0rgP98i+pr/ReSbd
	PLr2PIwdlgCF2/kvf2HyS5g7n9uo6IVb3SGUPtAbRZVAHib/L68G74/5HeLI=
X-Received: by 2002:a05:651c:1987:b0:3ac:7ad6:2003 with SMTP id 38308e7fff4ca-3ae670dda79mr17356091fa.6.1795082459145;
        Thu, 19 Nov 2026 02:00:59 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxeervp7z67jbft6-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:352b:8deb:4901:b3ca])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae6ea7c798sm8419451fa.11.2026.11.19.02.00.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 02:00:57 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Thu, 19 Nov 2026 11:59:43 +0200
Message-ID: <20261119095943.85048-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <av4Hn9u80fs8iHZ6@dread>
References: <av4Hn9u80fs8iHZ6@dread>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Nov 18, 2026 at 10:16PM +0200, Dave Chinner wrote:
> I really don't care if it is exposed by statx or file_attr; checking
> the flag through either interface will be orders of magnitude faster
> than using FIEMAP to iterate extents on every file to find shared
> extents. My concern with statx is coherency - it runs completely
> unlocked and so can race with operations that add/remove the reflink
> flag...

Thanks, Dave and Christian. Given Christian's preference and the
coherency point, I'll write the RFC against file_attr, once the
question at the end is settled. xfs_fileattr_get() already reads the
flags under XFS_ILOCK_SHARED, so the new flag gets that without extra
work. The answer can still go stale right after the call, as with any
stat result: a clone that lands after the read is missed, just as one
that lands after FIEMAP returns is missed today.

As I suggested on the 6th, the flag would take the inverted meaning,
so that an unset flag stays the safe answer: say FS_XFLAG_NOSHARED
("no extents shared with another file"), read-only, in
FS_XFLAG_RDONLY_MASK next to the case-folding flags. XFS would set it
when XFS_DIFLAG2_REFLINK is clear, and ocfs2 when
OCFS2_HAS_REFCOUNT_FL is clear. btrfs keeps no per-inode record and
would leave it unset, as would nfs and cifs, so their files read as
"may share" and a du tool falls back to FIEMAP there, as it does
today.

overlayfs needs care: ovl_fileattr_get() reads the upper inode, which
for a metacopy file has no data extents. The overlayfs patch would
take the flag from the lower data inode, and leave it unset ("may
share") while that inode is not yet known (the lazy lookup on
data-only lower layers).

Christian, one question on the shape within file_attr: would you take
the inverted flag, or would you rather keep a plain "may share" flag
and add a mask to struct file_attr that says which xflags the
filesystem reports?
