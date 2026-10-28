Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203070;
	b=eoaKHxJaI8dqyJoB746g4use23jfEVSVMG1aM0QVJGQXVU1TyTHQpLuCgr73BXXu3iGo
	 uYa3w8acXr86uEKBmCxz48eXY9vwvw8tGu3l7IdVWm+2j+QpiLo3jUUOpL2hsaZxyRaHa
	 jlgZIp3yy8uN8datjCuETnWhr91adxsTw9E0o15BTh3xNTHleLMoHNhuLpacUW7dsIylA
	 j/e2erlsgKjsPcg5I/0bhEaJ9wARe1/6UtuJrxzR+lVm69R3nPlhoNPvOt24NBINDQ/n6
	 aeu/zJ+alatVWg8Y3SJIkHeDijoJ0RKRZLo+GnOd0Ns8YmQ46p2kM2Vz/mh82LUQI5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203070;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=4zZdVCNBC5i5qXeoal0+niFGZkountVwk93ml+hYitA=;
	b=jUGex1x+FQfU5dp/WvUOCTLiAvqvTAVoobKiNt0iFODLvvFBT1OboxaYGGiB/51auFJg
	 WWs4LXKks6lj53VRvwbLXTmapx7qlKZDRZIt3NFRK28SR95gNvatB9YcDKfb/Z2cNbBs5
	 wA10gDSqzm+e1r9mUz27yyGBchDop3u9L24vmkxsS2Q2eV72UG5nIZGwrMNTEaLTMuus4
	 qHReP3VBIhVzsIYAzn2Wdwrz1eanBrBcLxiOC3B+K5gMZkLidk5ouyARto/Wl4KtJh4WU
	 V4DB1tooHGz6DBGaKPyUpF4/Mc8oNkDzZuhVIcWlGCBCXWG77tEJWMMi3dnpP+/eZdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="g+4+2cT/";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27A9606A323;
	Wed, 28 Oct 2026 15:57:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D27A9606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=g+4+2cT/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4zZdVCNBC5i5qXeoal0+niFGZkountVwk93ml+hYitA=; b=g+4+2cT/+QieBYZfUuKGcScV+R
	w0R8xIc//vGnDv6/mZHgy/ZLK5seVj22xqj5k62UUBZuYPw7Y+GIs1892XKVMs53TWZvLYcC3naNV
	onl50gO/4OerJfojIgzwqFSrPkcnTncDW7MVwPj0IszOqvHJCCBfb23JqZPYnlHaY/fe3CqniiSFc
	UdroUoYLFrgl7jxjytU/HzTNF296zDKBIase3eyYxbDGOoRlJxueNM6bwGQUxrvFtVVV4kfqW+1O4
	k4lMlODjaJyz1jR1EqNvY/5Vuw55t9WzzH6Lt9U9mpqLXZ4kBWVIGt1Kd0gICU1BAp1FA1IaaRXRD
	Z5Dvm3+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM629-00000007TZG-1cwm;
	Wed, 28 Oct 2026 15:57:49 +0000
Date: Wed, 28 Oct 2026 08:57:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/6] common: move btrfs-only sysfs policy helpers out
 of common/sysfs
Message-ID: <auIbfYdbpIVN6Kko@infradead.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
 <20261023203114.1655019-4-zlang@kernel.org>
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
In-Reply-To: <20261023203114.1655019-4-zlang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Oct 24, 2026 at 04:31:11AM +0800, Zorro Lang wrote:
> The sysfs policy helpers in common/sysfs are only usable for btrfs.
> The only filesystem supported by them is btrfs and the only callers
> are btrfs tests. So rename them with a _btrfs_ infix and move them to
> common/btrfs, then remove empty common/sysfs and its references.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

