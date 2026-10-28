Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203047;
	b=q0AoT3OshR/y7vktUdUyHZp2wA/7SWlQm1xIT0L68tvncGCLKASAuLH3HVGpsW/2LrDX
	 bsFgQO3gyzyIDeo/BhRWmezNaqpfE/VDnm+zuTmGSBgUtHz4xLtuN6SeGrRasA4PlUN6O
	 tA0WTVZW80Vi/LJAJKk9IGZATEQOpyG/QeFRugHGozEuO31qxhidANEZatOB6aXwpA0Lk
	 aj9OvcGZOVDkR0YsKWZlKtShDeaLYChs0N/wX/3v7VJZe2JfeMMpNMamW9hsHM/VMoJPT
	 hPGh3N/FvfDZEO3M4Nz+tO5NUw7IMKxG3w+tUbkxfVqqc31ac9v08msz5kUeKUUftMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203047;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=NIXToBSnqUf2ux4YwrjpuW/kMzFSdyjTLWO2PJ6CgCQ=;
	b=TufH+Dusox713B2IXm/Ay6J0J1gZO7V0HB+gysb1gOKrdkN/Lc9codeOAWS65ovivYiq
	 ugOYp08f6nx5ZDHcf3Z/uWiGnf5JJqiwkY1zRbrjmdOjylcqKhCE10Ynhw6joY23lRYo5
	 PV6aPSvtKfTHYcJtvFmhxtsYnp96rpZSDyXV+vlZDzm1Eo6I4IwEJW0EGTTo9333NCRsY
	 P48ypAEBIoAwmcJJtpQbMLAHZidSQqYFLj0ZwFEm2giOUkCyOgODnO19w0ItVSu86bGJE
	 6nYS6/X04S722b4W7tpUjAF2iIa9/HNICfFDwQKw9suM1y+PCpurqIbskyJvrMfXAeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dQi1qJ52;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFB3606A31C;
	Wed, 28 Oct 2026 15:57:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AFB3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dQi1qJ52
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NIXToBSnqUf2ux4YwrjpuW/kMzFSdyjTLWO2PJ6CgCQ=; b=dQi1qJ52R76Ih0644BzL/0wQCK
	QK0UJ6sdHQEOwta/8ZDO5Lebhzzcv8zmygIvyrFnKBAWCBGrjGYWiANG2pWs3g5RC/JZN8xVjKjoL
	AbdRbOTCpYp4pMa8ORt9g3ApSKxAAjonxKfSJQH4QTIZOZ4oFCBl7FvgKRpuspiq14esgnka2bv+3
	zynERwYPDUKEnKllSW7R/47D19yQoa9dTMgNf6JoePslS/XwfJbV5QbEfb4nNUhDFKm/phBSA5xFd
	LGPIkU/hlXLFlNUtBqEAhhNQVN1+NQ3z3SAhdNDG/sXkYU4ZYq444cv5cr/u+1GD7vTfZBClxna3B
	oowFOOvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM61m-00000007TWT-2QFP;
	Wed, 28 Oct 2026 15:57:26 +0000
Date: Wed, 28 Oct 2026 08:57:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/6] fstests: consolidate _require_fs_sysfs and
 _require_fs_sysfs_dev_attr
Message-ID: <auIbZuqnQBrNdqDF@infradead.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
 <20261023203114.1655019-3-zlang@kernel.org>
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
In-Reply-To: <20261023203114.1655019-3-zlang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Oct 24, 2026 at 04:31:10AM +0800, Zorro Lang wrote:
> There is heavy overlap between _require_fs_sysfs and
> _require_fs_sysfs_dev_attr, and their ambiguous names make it
> difficult to tell them apart.
> 
> Teach _require_fs_sysfs_dev_attr to default to $TEST_DEV when only
> an attribute is given, remove _has_fs_sysfs and _require_fs_sysfs,
> and update their callers.

I find the optional device argument a bit confusing.  What speaks against
making it mandatory and having _require_{test,scratch}_sysfs_dev_attr
wrappers?

> +	_has_fs_sysfs_dev_attr $dev "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 1

Please turn this into an if to make it more readable and avoid the
long line.

>  
>  	# Disable retry of metadata writes that fail with EIO
>  	for ctl in max_retries retry_timeout_seconds; do
>  		ctlfile="error/metadata/EIO/$ctl"
>  
> -		_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 0
> +		_has_fs_sysfs_dev_attr $dev "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 0

Same.

