Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A629433B0
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 05:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576789; cv=none; b=m3r+KjkazzoadS9AW/30jYa+HaFvLsHFwEo72X6VS/dRtR7SaCeAccVrVdIPpweBhB/vYYWkOEEt0QI+SJ9hkxvlZFYOf3jXYpYTRnK7r4Oi57dUX5hBRp188lOAFKhMJ0ECPzUG5h+Xg0tdXeXPujndg4/AVtbIizTNhDq+DmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576789; c=relaxed/simple;
	bh=p2vMboOBZ8qQ9y9vvZBybc+P1nfT+0sarMMxpBTwPTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZrrwGM5tuwHBqYvbSMqXmcfq71ArsLZxXaFKpIH3+QBQIejdj6QMWNoo+xhoFWIa2+B5INpRd2T0mv0vRW12lAnDN31yd5u4s23jH7DsY3Gpm7M6VRkPD601uAISJTefsNGruKdCHEv+jDG9INg9nRlEHA28fJkrSYa9L8oQqMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w3kwMjIK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w3kwMjIK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Km9Zv/RoweqNMAbMq10pECg9Rhi682NB89umy3T5FIk=; b=w3kwMjIK496T50xOQ8aN1imktk
	mSVSx92wPFE8GpnEBt36wWDThDLS6fayk9a/Bq6Qw/5WVYC7trIf0PfW2yKUoVsqw+67oKlkISu6G
	+diJpS8w9faZrQd15aBQT9BmzHCC8jE3iDQSDHioMvVLt7lVCWBQOG3li/ctxt3fQ3DuJUEIhkygf
	0jr/Wj+ynbVD0LqNOtq5UCPmzsTXTN8pm/DAMYclZeiScAYHV64ZYtYM+KvugMD+0+Nzcmj9ffYUb
	U8VS9usNQ9AP8hBT/DRgnBfS4a9SvyGW1Op1B4ecqjHDcp9KvCYdlvGzeUzHK9Lp+V9LAQs48pKcS
	CUkW4pcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37vn-00000009jT1-30Ku;
	Tue, 22 Oct 2024 05:59:47 +0000
Date: Mon, 21 Oct 2024 22:59:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCHBOMB] xfsprogs: catch us up to 6.12-rc4
Message-ID: <Zxc_U0nns3lEkrpN@infradead.org>
References: <20241021215627.GC21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021215627.GC21853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 21, 2024 at 02:56:27PM -0700, Darrick J. Wong wrote:
> Hi Andrey,
> 
> Here's the libxfs sync to catch xfsprogs up to 6.12-rc4.  I have a bunch
> of tool changes as well, but I'll hold off on sending those until dave &
> hch have a chance to look at last week's kernel patchbomb.
> 
> The only unreviewed patches are these:
> 
> [PATCHSET] libxfs: new code for 6.12
>   [PATCH 01/37] libxfs: require -std=gnu11 for compilation by default
>   [PATCH 03/37] libxfs: port IS_ENABLED from the kernel
> 
> The first patch brings our C usage in line with the kernel; and the
> second one is needed for a bug fix that got merged between rc2 and 3.

The entire series looks fine, the libxfs resync outside the above
patches looked pretty simple this time.

