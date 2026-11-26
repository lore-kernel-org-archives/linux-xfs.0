Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700963;
	b=Tm/FlQI+MR2vKDbDRSo1H7R1wQyQT6cLIIsNQq17NxEXRRj1+66x/i7JxRfg8nkYxwpj
	 RbHKNwndD6f2Uv2bJbQ0f2OhAsAlNuAoPQB26hLUIBTy1Md7Jnj/8R2sLtWpcB72jhSJg
	 NL5MHluXTYN2+73F9GEYZK4JKLDvcj2j8LbvR27PGWZml45hr1uOooV9vr73P2BQFpPqs
	 yA/HsgFkkBuCbhIqLj/LJyOHk3X3H5c04GPd+QqyH8QUQbs+AHD3YOsi3oRgqN4B58nbF
	 Er7tIqHfb5XseNp+W3YV7ULoeZbELzEKfuW37LWqhfu3JE80mcwD008lihdNdNLmxjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700963;
	h=Received:DKIM-Signature:From:To:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=NPSQpQTltqIf0XJ7VNXqiz+KaXdcYp8qNQ6kjBes5z4=;
	b=m0ToynOSRHOto7i+XuwYkaGpLAwh4RYOQkkYvCQGKmDpoF0GNshjonVOctksCk3tbJOf
	 I7a+GE/JJP0L3BqSLREkl2O7WOAS6N3i1dh+JnlgJ+EQ4snfMlLZ37YeX91Dpc7lrk4f8
	 4IRplAJQ0QY9t9XZDBzNHkmeoiS+U4hlYk9vcjycToCa4AnMmHptGJKwhYmBNTRAHqX5v
	 U05oOND1vY2qiB1dqoPuO2GR3aIzRdYancBDlvhN4CBj3lGJxv6bKweCN4oBjKMqXEaAA
	 e27WP6Hl9ThAhq6VlSSO3FaUxsCoxnNHniyAGc2aunza/DLzB/YUxYVh/wfui8Jtdjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQOFNUNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF612606A31E;
	Thu, 26 Nov 2026 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQOFNUNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC6B1F008B2;
	Thu, 26 Nov 2026 13:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700963;
	bh=NPSQpQTltqIf0XJ7VNXqiz+KaXdcYp8qNQ6kjBes5z4=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=XQOFNUNhGT1djQkLGRJrfRKAoNwaL6nvksQaBAC8zU/ZqPJORsxMRnjFWA8wlaS/R
	 aEvplfktszAt4rUt7dcqpgPJWanejChUUkq6VPAgsdZofyDfsfXp933v8Aya2WHGYY
	 UKqLP7RrBGkdPIaSQJZMM6bFqtZNfUbQo4mNxbJ9KuJ3zdHjxnMfgH+aqcrd8FD/Fe
	 1OzDl89myKivyH9YHOfC8hthTV/ODx/hB6fwJ1a6sCZoUL4xdwUPzTQ9lWLvQ/wC7G
	 3UaY6ybmUrv2+AF/mjACQ3FtM2pRACAdi6jNnP6uybToDeFVNtKjD6DuIPZIKD7C/x
	 yhNO+OUOwtsaA==
From: Carlos Maiolino <cem@kernel.org>
To: tytso@mit.edu, david@fromorbit.com, jack@suse.cz, djwong@kernel.org, 
 josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 tz2294@columbia.edu, brauner@kernel.org, Chris Mason <mason@kernel.org>
In-Reply-To: <20261112214604.67875-7-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-7-mason@kernel.org>
Subject: Re: [PATCH v9 06/14] xfs: recheck direct write alignment after
 write checks
Message-Id: <179570095963.157938.9680779051208910940.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 14:49:19 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 12 Nov 2026 16:46:10 -0500, Chris Mason wrote:
> A direct write to a reflinked file on XFS can expose stale disk contents
> if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
> aligned.
> 
> A direct write cannot fill only a part of a shared block, so XFS does
> such a write through the page cache. xfs_file_dio_write() decides that
> from the range that the caller passed. But O_APPEND and RLIMIT_FSIZE
> change the range later, in xfs_file_write_checks():
> 
> [...]

Applied to for-next, thanks!

[06/14] xfs: recheck direct write alignment after write checks
        commit: 3779fe1637ab7f8a8b57dfbee9ba584d6f01a893

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

