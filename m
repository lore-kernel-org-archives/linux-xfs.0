Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC613624AB;
	Wed, 18 Mar 2026 06:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773813690; cv=none; b=oRr0iL7l7VZxJGsL8tylLpE0uYbMshpnaMxHtpZeE0B7yaIfN7LTc6SmDdTeZXrizGLvx7fhYsymPs7TDnjYwq58tVQVFbzp/vUpf2DG6yWVph/G2U8GiVzfzIQ7MYTUxLe1cfRear9AH9dagFj3FWRhES2LhLGcEWKeQ3yp3zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773813690; c=relaxed/simple;
	bh=tukwA/wQc/iOgH90Pv3xzIj37DdS86LlpdsJoLFQ45Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUZhP9NGxKjk6WXYsz+CcdTpLVuGDqk5CGeWWgv71s/0+73Jq0zaYsg6o0MGWay6AIrSpAy+bSztswvk2+u7cIOE0PCKuzUSdU179WfxVFzat2mgVmGdy824WdcZStgW4WQFqTqyAgMuQyas0JHjj7ZOWG0v594JnCg5tv4YS8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TAo7tsgZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TAo7tsgZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rGkK4EH4wc4SNJP89M9o8IFhEM4YPx+o2/dneZXXldc=; b=TAo7tsgZpjarMiRPn428TPTbRB
	5sKQA7DASVZpsAXX45hQGO2SmWZUF9OBM5uJ2T6iicFUXBsrq/pLANRNMPF3T2Rf0NCC8Ihd0qz4x
	GWJCLyxbwVCYt0dwW1Cw2IQdVHwcK6hrbkR7VV8DzfDZ0a+y7EBeqo0AKUdcfBUXKzRKeKLQDWMAL
	uRFBccnPPJce2/eHyfZu6sQu+tbGxSZaEF1OgNaGZgej+EysOPv9Gb3/BKmyIPoXsum8WmuE8C2l8
	WJdyGnxG1CV8YRRem+BqrszKNkYtJdWXlKjZQzHGx4xXMdQHU9AEm55oVETJO2P1kT/Wb81IXDgiF
	7x6/ugAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2jyC-00000007p5H-3GxZ;
	Wed, 18 Mar 2026 06:01:28 +0000
Date: Tue, 17 Mar 2026 23:01:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/6{59-61}: force xfs_healer to run
Message-ID: <abo_uIzTtheDqpZb@infradead.org>
References: <177370372656.2108664.15986990094116651469.stgit@frogsfrogsfrogs>
 <177370372704.2108664.14001765676527302739.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177370372704.2108664.14001765676527302739.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 16, 2026 at 04:29:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Set the autofsck property so that xfs_healer actually runs on
> filesystems with old feature sets.  Since these tests are looking for
> error reports that don't require backref metadata (media errors, file IO
> errors, shutdowns) we needn't _notrun them.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

