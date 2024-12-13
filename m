Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E361822F8
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070040; cv=none; b=fTwzIWLD2OzcXYRMz+ry08zySSn0xTXwchL/z0Xud/7rsmxqky91U9UdRXKsQarwFAgqSGg9NEqiiBptpXbcFeCJO6Xw8OQAyNyAAI1YcZOgJSNbwlHR74KhG17emDQ+4eesGXLzd/x1pAmmjgvG/8hyhb6K5uvjHWvVWlLzvH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070040; c=relaxed/simple;
	bh=TGsKr8zQ0LGAX2gQT3qxoRlMSnlZ1AIAJ3f/BiyIHQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKZ2Lw0tiZjP45sPMvxOZXGuKunDujlk8BH+2IXy/cqKqA34duQObjPgV9d1nMPvub1EDU4Xz1R3Z3FxZUEIvp2VcxMrIxBj/ETMtbq303pWwGbj6gF6GQ+HSTnMEk+pXBEIRT1zDE2rZsv9gmxC2Vc5D+OLojcELCMu1dULElQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MIt0DRUH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MIt0DRUH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vHf9HdTGvstlN9eRoPqKiPfQ1uhL45PzNj9aSKcSwhA=; b=MIt0DRUHZo5XVQgQYFfr0f4Wvt
	b0IqullJhI4DwdnU26BSHVdxans1tLtug8cdLg2kMZHhioSHcVHaS0X2MqU+yjTYw3Rgqy7Z8Vud4
	aR70668kvzxVZh8dZBUL3xCEGLS8w3DbY05CeMpqUIrPDqTd0iZSp++ApmfP+uhSrNC24Uqiek0Z0
	gycB1/iZTlKZlqgUSYRCplTyICupDf9hYrSnHjtUCXD5X0FXnf9cVMDbUwcOBxA5Cghb3kaycJnvW
	uZ/CmnQStXZceTW1UYMmRteUiFO03qvcBNYJ8OEQpU9TDvdxCrGz4q3fJJf4fdAfec6yK2W1gpBNL
	sr5E/ecQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLypa-00000002pox-08bJ;
	Fri, 13 Dec 2024 06:07:18 +0000
Date: Thu, 12 Dec 2024 22:07:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: make xfs_iroot_realloc a bmap btree function
Message-ID: <Z1vPFgsIAZxfIKvp@infradead.org>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
 <173405122228.1180922.1590571352191211765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405122228.1180922.1590571352191211765.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 04:59:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the inode fork btree root reallocation function part of the btree
> ops because it's now mostly bmbt-specific code.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

