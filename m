Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202904;
	b=Id7+ArIp+i+oGZhwB0QNKowJY39fwjrLtnvcDZ0LqN3Hz+QsaVKIMgqcLILsXOhmadUi
	 6he2yZnHVFj3Ma58ka7QZJCuzD2hoUW/Y/M7nPuDY8qCYMjY9uYofetmSjyuxKm7WCUpx
	 q7a0X8/+Ae8dNKF1IeTZ00/3mQxnQCpMdLwgLsDm/TsUzSqfwXKtRSKmE4enOQuhNRhUX
	 LLjIpXcX0OClrbhkt5ytJ4Vi8NqJACfaHrMe7cE0X3UgmX7dLFODjRMmHDtdSF6sFjQ1L
	 drSwoDxHYEShb9AtELd5j35WtkofcX+Bj4IfEmbBBjUWxHO7oawqUnL5PEX6700hdlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202904;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=AuTKHk+x5Jmbf0NeEGNUF8wfoWCYhHg27ca3tfsrwoWnrhjtsXS/dmnmIATST2jN38hP
	 SSI76jQfG7lCw7JTW7GAGmJWcojd06N3dzUA8W1d6h+Z1CVmehijnmNph6gD9dtv9qfIl
	 WWPQTSfFzFTZLKy/AvjhOz9MtKWDydMNDEit7Dq117JRevn/bOMN6yUpCFElTvFn28fUI
	 yiwo7HutY1YN2KjtbCseykdQC+UJ4gGNRKaG7+hLLJFFJkGgIChyBEAau5F4P1ASTcV1s
	 dN8Yrh+cjYYL8A7LJQhkv3DdEwo6/unOqLUu2HwqOAG8OfZOrQIRjBScphQqsqFqo7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=SDJfZCD7;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDDC606A31A;
	Wed, 28 Oct 2026 15:55:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DDDC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=SDJfZCD7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SDJfZCD7+VAURctPW0QW8GNM8P
	7HhbgLqmP2YwIGrt7lQYKf/kg2fon3nTH/BcGrP2sAhm7Z5+kl7o0vzGNE3TCZ8LvZGg/ZQAI5Cp1
	8WXvqdiVBHKI1Pb2oU8YlDApfDYRUVcTJH/fMktB/VOAXave64RUXkAvC0BfaYalVXdAxBKIIH67o
	iB1qnk0r3Yz504Lnb2v7Yvu9drDLD7vcyzgHsMRLqoKMARtnSuxhySrpZ5C8ileMWJIqm7VBC6lyy
	jG/2EpuFsbLeFjEtJv1RUv+aYXVosu+zpnOjHjIqU9tx1iMHY/lbNugydXCuBI4oBFc61lJR33DCU
	hl2h9N7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5zU-00000007TKH-0Uxd;
	Wed, 28 Oct 2026 15:55:04 +0000
Date: Wed, 28 Oct 2026 08:55:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/6] fstests: rename _*_fs_sysfs_attr helpers to
 _*_fs_sysfs_dev_attr
Message-ID: <auIa2FTd8PRF6qxd@infradead.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
 <20261023203114.1655019-2-zlang@kernel.org>
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
In-Reply-To: <20261023203114.1655019-2-zlang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

