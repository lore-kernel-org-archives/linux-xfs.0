Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E388D311C07
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 13:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756387143; cv=none; b=PCGde96I8oZeBHL5BgvsNTbHJZdW7blREv7kxSyx/vNe0x8MguHdM3XyYNPEVn+8qyPR+zrOp6aaEE3oVxFrBJnWkhTHzFfcCXaXaLY/LO8M7FHoaP0+E/bUnhoe1BvQ6yAFDnt3Yx/4/8csVdXnaWGVnGFnlOv1kiNxQY6/K+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756387143; c=relaxed/simple;
	bh=Y6ypxoX2XffdELZxczW8mJBleNbb5/cQVgU3dXSHxTQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Pb/c8nURzJH7j65fEKI3r8kY86LXBJ7gvLEayUeRUPwCd+foU6mGe5742GNnZMn+aFfvf6Ktna/tTAzkYiAzN6fYF04TudrHV9UHywT/UZx+HN7W4CcRXHu/YVMSCaEJPeFpmE9R+3xvV3Kt5tvvJnApjhns57zQXR3NOkwTwuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3mEkakJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3mEkakJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A55CC4CEEB;
	Thu, 28 Aug 2025 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756387141;
	bh=Y6ypxoX2XffdELZxczW8mJBleNbb5/cQVgU3dXSHxTQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=m3mEkakJN1M3m5XkyRksBDMPzCQ8GWOcyBaLetfpS62ieLTz5sF0/tlVU0NaDdxBN
	 2T4O7tOb6edRzdw0S8QMfwamHfkuI6iB8Zse/IH7OcalIC2Pu6uO4VkyFXyLqQ+8qF
	 y0BYs0NcSlbVzcXN2m5AzBWxvUxhC2hdmN1l+sBlcueFVQemC3n7PQavHC/Vz3SS9T
	 WQ8ftSWAK9+3Wynh6Do/lAkJ/EeGxI01mLzTYUXWxRBQDdOGWd1wpg7NhfDK5537Q+
	 qnORupGBcivoe7Y2kIuukS4MPkdPWZ74NHja2rlFgZdJtnA55P12J+dN7VGuMwhYwq
	 d+Th1owA49jcg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20250825111510.457731-1-hch@lst.de>
References: <20250825111510.457731-1-hch@lst.de>
Subject: Re: [PATCH v2] xfs: implement XFS_IOC_DIOINFO in terms of
 vfs_getattr
Message-Id: <175638714076.29667.11579415359404190380.b4-ty@kernel.org>
Date: Thu, 28 Aug 2025 15:19:00 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 25 Aug 2025 13:15:00 +0200, Christoph Hellwig wrote:
> Use the direct I/O alignment reporting from ->getattr instead of
> reimplementing it.  This exposes the relaxation of the memory
> alignment in the XFS_IOC_DIOINFO info and ensure the information will
> stay in sync.  Note that randholes.c in xfstests has a bug where it
> incorrectly fails when the required memory alignment is smaller than the
> pointer size.  Round up the reported value as there is a fair chance that
> this code got copied into various applications.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
      commit: 851c4c96db001f51bdad1432aa54549c7fe2c63e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

