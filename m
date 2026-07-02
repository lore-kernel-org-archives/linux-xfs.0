Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FF83A4F5F;
	Thu,  2 Jul 2026 10:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989968; cv=none; b=VgWxJT4rACBOTpBZUGN4Km6kiuxWmgdApVrlR7r8hcO9gARECpybMrUMirHGzqGabyjdWuEz8Ljp72uI6RNF7SyOXamIIeN4+KWjl84zGON+RzeiYYxJ8YnM+LcyYlZL5+Mr982Hox5cco4mxTRER3MJHdrVQt0V3OOwYA3psCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989968; c=relaxed/simple;
	bh=KpsnpJucENLVn4jiO94HiDlLVdotfxoT7WFbeF2le0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UoQLvcrzLleZf9pSBRqD9ul4y2XUhIgMMQ6bYZ4ihd4/qsC8zsoMhSxSCrtpRoP721NhsShTw4AvMC54tM+jd1pUnudp5m4C5wa05KIHlmrW4JZmi1XWg21nUZ2kd4ot35h/aLk8p8kXFs4qChEgJ06ffb/47n7oDAxM2bNR5F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TVb5LM+m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TVb5LM+m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/4zcHvGMTc7LOGf5OghzwyBNpiYsdG9XFp+xC+D3jCw=; b=TVb5LM+med5o93PQ3mbuEfWdtC
	RU6Ly2I+AdIsc6l/ytlRHpshRVchiU6XOt4t0QHkJF51Lufoih6m+HQYDVACQ1NDswlKFaJELYGNm
	CNfOJxRJS9KOc+uKGcUJvElqmifV0nHu9AR7Ff+2QZNDGRmVj2Aj1GxPEXNVCjYkuhp4DmnTS88Hl
	5uYBKzIbeMOcAGbljD0PPCpDrLsJJDL4W4j3fucAXuJukEyXBRwkfhtBALrcHpD5J2U8TIHZrUG/5
	PrmcdGie/MBIkGiOLj+wytegz4O9B5+QbCy/xM/00tB0rzlpnT2OBoZXCHBGS4r83X1dCyl1R9fEJ
	Jerru01A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfF8e-00000004Fxs-3Kt5;
	Thu, 02 Jul 2026 10:59:24 +0000
Date: Thu, 2 Jul 2026 03:59:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, gfs2 <gfs2@lists.linux.dev>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: iomap_writepages WARN_ON_ONCE(PF_MEMALLOC)
Message-ID: <akZEjH2Hf8-RR8yQ@infradead.org>
References: <CAHc6FU4tz8-HmEf2_XKT0NT8N=rv5OMcY79PxTACkXAVLOAUpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU4tz8-HmEf2_XKT0NT8N=rv5OMcY79PxTACkXAVLOAUpg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 01, 2026 at 10:51:06PM +0200, Andreas Gruenbacher wrote:
> Do you have any suggestions?
> 
> The above is on RHEL-8, but a similar code path exists in cgroups v2,
> triggered via:
> 
>   echo reclaim_amount > /sys/fs/cgroup/.../memory.reclaim
> 
> That code path starts with:
> 
> memory_reclaim -> user_proactive_reclaim -> try_to_free_mem_cgroup_pages ->

PF_MEMALLOC is a sign of direct reclaim.  cgroup code is doing really
weird things when it is set and it is doing writeback.

