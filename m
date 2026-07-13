Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEA53D647F;
	Mon, 13 Jul 2026 09:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783933920; cv=none; b=e+FLxTLnko3VUXE9UcYaTaRLrUk6lAOggbWywg93Mm4fgcfUMFz5xpE9sqrDuyS2HoZaDx2rhGdHdHbrbbueWACw2bc7s3zp9DzNiwdqJERPJcj8lC6pyuSdIngJ/Eo8UODowg6kROWHuc5UV6RqihEVDjd46RSWINW3o/SyA8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783933920; c=relaxed/simple;
	bh=IGGEjiffqNsOAyeVLC/UVa7sDscYJXygtQOtQ2cyRTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4vbz+HUmOob60ZdugI1O1znqk6/yFUNsj1nhNrgKusKJ/uaykngl6n/RLoe+fmJFSblCl9PWErVXdWw12ULJZee8NMbbfOHEqqopZwUSHts/DJbUbnQ+6YWPjbxDUQAycYRtHh6RMl2LbGjF6G4X2QvBPNhYzdCkUuWJsmny1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=czAatAGy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="czAatAGy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sD+5Y1O2kahXNOyh71OubREDkvuYVidT8qeb5Gq1pLM=; b=czAatAGyxdQSiSjSuCCAhEmu1P
	Jv/o9wrA0KiMtnS2zE1xnIiiJhCsZXoA+P3ku2JC/Lh40DOU48OOy/zw9IouexkBe/ceyWtlII7vj
	GTCMR49N/9L0GMJNdoubsEgrd+vGqkrY9Mxt0vevZxNx2Mgkls5y4bSohTtMqO4vwJUVulk5F/59P
	AhOsixRQluIopXeompBbap3VU2dx7KuqKGtsElvFKdvDrwxzoau5oeLMqytYwGQS72ExmYXndbVrq
	oxWegyKoRoCH+Ro8Hb+D4BZEp3LgpjJYkzx4gfTF28sDlymujrPGQV7pVg1qVlesiCyZRx8TUhVcG
	+s6bWaSw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjChh-00000008g7a-2UZN;
	Mon, 13 Jul 2026 09:11:57 +0000
Date: Mon, 13 Jul 2026 02:11:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, bestswngs@gmail.com
Subject: Re: [PATCH] xfs: reject log continuation for a header-only item in
 recovery
Message-ID: <alSr3bJ8yow3ID9K@infradead.org>
References: <20260712220854.3131445-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712220854.3131445-1-xmei5@asu.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Jul 12, 2026 at 03:08:54PM -0700, Xiang Mei wrote:
> On an XLOG_WAS_CONT_TRANS op, xlog_recover_add_to_cont_trans() extends the
> tail item's last region via item->ri_buf[item->ri_cnt-1] without checking
> that the item has one. A header-only item, created by
> xlog_recover_add_to_trans() when a transaction's first op is a bare
> sizeof(struct xfs_trans_header) op carrying XFS_TRANS_HEADER_MAGIC, sits on
> r_itemq with ri_cnt == 0 and ri_buf == NULL. A crafted log whose ops are
> XLOG_START_TRANS, that header op, then XLOG_WAS_CONT_TRANS thus
> dereferences ((struct kvec *)NULL)[-1] and faults during mount(2) log
> recovery of an untrusted XFS image.
> 
> A valid XLOG_WAS_CONT_TRANS only follows a region written with
> XLOG_CONTINUE_TRANS, so ri_cnt >= 1 always holds for a real log. Reject the
> ri_cnt == 0 case as corruption with -EFSCORRUPTED, which the caller already
> propagates to abort recovery.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can you share your code to generate these malformed logs?  Because it
would be really useful  to test these conditions regularly in xfstests..

