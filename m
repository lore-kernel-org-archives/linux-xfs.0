Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764AE366DA4
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772549345; cv=none; b=ZXICN3L4pK6Idt9r/HFX6Rh2yiPgGeMM0TrRUBvPZmr5kvhwUXToPAwCfbGs6sf7DwnHEcHwcLqAg8AeXA95d5mAn49UlmWpxQy0ZWb6z4RT+oT1mIBbufL/h0UqpEDPso/dSYJY2nhNoYvervdCq8qlE379iwJbbziloBHZvG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772549345; c=relaxed/simple;
	bh=rS1/6mRsyemGBkcjvyFIqCOb96FXDu2avtFofNmE3Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZnflB5tAU59qoa6UEMDtTPr/8xqgBu17dOQnj62shDP0NwSYJKLu51Xd8odtndzT1oUZcFZvo5w9q/vj7KxMlyw5/BaOOo3WmR5sejlR6kE70v2yT3Why+kH4/ONqU65QCRe1H3+QDN06uh8Zp3I13HL0Y9Cl4KTUEaL3sVOyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3XlnLOv7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3XlnLOv7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ABXkFTyVUjP9uxNMqoA1ahYS3OBwQ4e5TOlTewAjiAA=; b=3XlnLOv7ACuFoAOiTQpTLX/8Jw
	QIMpYaBlHjAzq339Kid0IsK/b9URXd3HXgQktzAcV99CAwfxzgvHdWJArnVLlFcuTocOkdfnL7C+W
	/QLPWs5oUTBHiY2FpsPAP1PRbbos64BmH0+YUGhDstVzyHbta6aoaA0h9d8F++2Vay7c2ud6/UnHi
	vvNxRhJdQUsDfV69X4iyOWKElBGcoMoAAkhVhuPgNkDuUQx9mj6Vv8wwnTwQm1XMprXtVn0XFLfB1
	zTx0p1DyL7QbpQN6InECtTroBQmYOyG2cM8cho3ymrCdM4JsibQnECGjdwQgW+YbcRNk0aaIa4uZH
	g7g8bYAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxR3X-0000000FMFW-433x;
	Tue, 03 Mar 2026 14:49:03 +0000
Date: Tue, 3 Mar 2026 06:49:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/36] xfs: remove metafile inodes from the active inode
 stat
Message-ID: <aab03-37QcwSKu0u@infradead.org>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249638385.457970.8057539261074430844.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249638385.457970.8057539261074430844.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 04:20:47PM -0800, Darrick J. Wong wrote:
> -#define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
> +#define XFS_STATS_DEC(mp, count)	do { (mp) = (mp); } while (0)

Looks like XFS_STATS_DEC has been around for a while like this.  Maybe
split that fix out?

