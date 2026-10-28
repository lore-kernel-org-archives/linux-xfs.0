Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203104;
	b=iSZfnahUOxNykoiQorZJkL4ZnUXH3mOtRuw23VLzjBShcfOMT/dg919WF48MgSR6lxt6
	 imANwonb0f+ZWqRTWt4kqQ11YKhknsW7pK8clrKQ0NMjMwFJrE73I+RLcKDZPrhHDzHVO
	 pmM4hU9980Y5xkgoDVFs82rZVW9ujI49MExTX8azwOkZiYbRv9EWzCVcUpvgRBLd2mXRQ
	 FBOB+PY0yBFGlAyew+HcPqZzHZb4cAQox2fZeWYWl8KkfasFFxHsAuSZpeoa9JfF0o9jB
	 O3nzVsWXeuNljWXVpKBx0Q5IfRbXoEivRFb/O9j0GuNx7gJLEiN7aTuuJBqIyUHIyGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203104;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=AE2yxGDzdUdigMfyUt0F9ahIIfFBjGjrssVgNspdNj6Ctg6iljeOYeHr6PvcY9DeZbjo
	 eQwfPkI4grenzOwFFmenvNCEEVqHgoeOw13auvlidG6OlB/rcT1jGE1RqYCEqzE+otPb/
	 SsgCKBHJUXRXNAvwl3aa6QcvphtYcjcCciBVjJRdmk3bc/xhEbXoqUXEnQ+UpnyD7CRf/
	 xLQ7XwkRnzrm6rY6vLeMH0Vtz3epfJI1n4O/h+BzBc9/uGsQgHKafn2ux21uixBaMVSfN
	 QXF01S7ymH9pWOy0IDPby0RwNshRCeei0z6K+4+rlekWWZ2DqRi2AFLMGm6UBNscngQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nr3ZvHrh;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EC2606A31A;
	Wed, 28 Oct 2026 15:58:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03EC2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nr3ZvHrh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nr3ZvHrhCMTgById/eeHcfBbsB
	M2ZDlOtoV+/xTTrJT69Do37sxrrwN8LLAp6VigphLobxzA78DLI3+WGrYY1F5KkptLBumaHnK8Y2o
	NuGtNKR7n8kUX2tHtDwvzOR96krxKwS/PVgLKSJ+lbVD2NmLlxBPDYSu68XlEKhp22Tde6hKWjxBV
	uUu7QNN791KsO7wdHLxxxHh9QQjkFNfUJdB4UUx1w9muDIiQRUfKm4Lj0MChllMSVyT3QRrWfJ5m0
	obwcZJqYOrevFINlJ6FpCiiIEgB7KrrdouPGtISC7OGBxlOVuE0owlVad0XsUEHN30BdoZL6BL2RW
	uFux1HFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM62h-00000007Td1-29EO;
	Wed, 28 Oct 2026 15:58:23 +0000
Date: Wed, 28 Oct 2026 08:58:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/6] common/rc: use common helper in
 _require_fanotify_ioerrors for f2fs
Message-ID: <auIbn6JJgTAocFhc@infradead.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
 <20261023203114.1655019-6-zlang@kernel.org>
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
In-Reply-To: <20261023203114.1655019-6-zlang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

