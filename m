Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC63BEBE
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 04:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732596796; cv=none; b=A161TsjrlYd5wsl1va0OsIN2WxUxoilNYDqSNQezmyl3x9vpSc/KrhbLhYJbJgthD8NR6DLmxbyTsr2CH4hQ+lnWwV9W7kqJmxfI2jEsNRAFA+i0vWwx6YuXZwO2j0hrU0kn3k30SxG1hrgp7rdz4Ob7vS5wCc51HFmoVAYc78k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732596796; c=relaxed/simple;
	bh=a1Y3IOBYQ1yjQwOXlMabA5zzHjao1pjw06QUfzU5KSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ooV8z1o4e/OrHx1gcRFJornwfJDBKwMS0SOWocJiD6OQ4L0UpdF3lP5RYcDfL5Qru0wINcfm9EaWCKlkSYeGCgagAxAnkCHipTh6ch2iGczvExhm7K8G/RkJQxDRmyhXF4wBDp8jOytlnwG9moq5kjH4N9GVoOrzd1pFN3l9Iy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CbIp67hd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CbIp67hd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Igf3/dp6YEZOsgP/rbC/Rs4mn7LviTg9VrgfkKbCJs0=; b=CbIp67hdiR3xeH1Gy7SCsdx+zq
	5+HTZRLnQcKoMzMxirihtdo1AE5r+//qr9aHvDGWvUGnGcQ5lBwLwP/t/3ZOErWAikBmdT69t7Y0y
	vMjUIBnOONdX6WGQKhGbg4EnIuM0rEGyNn8IP8LnuYRf8CeyKJqR2eAdwgtYT24Bwfv3JCnqGh5rI
	9/dGbxOla76+3vuWM+BuAbcCH9SkjUn1Oob+/eDa9eCRCxIrxBYAqV0MrhUy0a8u/WuaTUb00beAE
	zgCy1ohYMQbsPLOMeQkBcNn5DCXcE6LimDrWdN6yWSMCOJdViYlwoTSuu3n9XQXmkqvu4rbS6XP3l
	zaJGvyow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFnZY-00000009dGb-0FgA;
	Tue, 26 Nov 2024 04:53:12 +0000
Date: Mon, 25 Nov 2024 20:53:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: linux-xfs@vger.kernel.org, mmayer@broadcom.com,
	justin.chen@broadcom.com, catherine.hoang@oracle.com
Subject: Re: [PATCH] xfs_io: Avoid using __kernel_rwf_t for older kernels
Message-ID: <Z0VUOCUxUgK1PfA8@infradead.org>
References: <20241125222618.1276708-1-florian.fainelli@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125222618.1276708-1-florian.fainelli@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 02:26:18PM -0800, Florian Fainelli wrote:
> __kernel_rwf_t was defined with upstream Linux commit
> ddef7ed2b5cbafae692d1d580bb5a07808926a9c ("annotate RWF_... flags")
> which has been included in Linux v4.14 and newer. When building xfsprogs
> against older kernel headers, this type is not defined, leading to the
> following build error:

As notjign else in xfsprogs uses it this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although I wonder about the state of sparse checking in xfsprogs,
which to be fair I haven't run for a while.  I guss it's time to
restart them and sort out the mess..

