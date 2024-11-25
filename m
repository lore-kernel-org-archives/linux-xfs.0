Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9313A2AE8B;
	Mon, 25 Nov 2024 05:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732511628; cv=none; b=QzHrXiSxmU2F3SzsNSiXODg+wWC1o7VF+EWu9JthHs3RDej/Yyp2f4Z97gRzDtKMytjWy9mEy8d//fhGUu6NIGBaCKObUxzWOWqTSZn8um7BXH+cC9i0EkZ7Se8qRuURpRFwNh7bLlLriluzhQzH767ZgPogOiPZqsVECmqV5v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732511628; c=relaxed/simple;
	bh=sCb3E9KR6iVK95rG2GSpoSkdJVjnQWwYtZvKtwxUqmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O3eV7I1NtZ+LouTp90/gezd8E9QULA8ErwjKrJqBu1+MqjvpkkA3KsFH3CgwPTQRo+z2JpBvEe22vFKNyFjq5cyVVODhbwwm1gnxbqPtui75KxjJE+47MkzEw9mk2xCJ24a7yyBLEhPownKOdoA1h0pfUJ21S+nwnJupveRh1Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cI1aouez; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cI1aouez"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rOA+hZbYERZM11+6jdpBvKP+SEi2TevPyC60fA/lcWM=; b=cI1aoueznk+JWkxgxR7jvUbWyY
	W7UhmyX1KNwAChYHAIYPYV87QjuDSEVqEP4JS2b4yQvnzG9iciB7KG0uHVmKA6tfAGp6JG2o517ib
	IOHZqu944Rt4RD8JZsgUeMpgv1JZvC3aMMsEXGgpT7gDSD5V5HMYd8PLwyH6b/Pw4la/TvvTesZA6
	E2yKmNfsC+btWbc7Wrmg65F+Pk1bua9Mf4YIxE8TDYk0+LE+PDldbYaz2kByp+MMc7WMiL3gN7TqJ
	VjDrzlOFuwyzl4/NP+mKOaukVYGT3Q3P5YJx8i8bHOmclwH5iahG9vSklEFN7kP3iUf/1zH4gG9rR
	jvp5zorQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFRPu-000000074iX-0ymf;
	Mon, 25 Nov 2024 05:13:46 +0000
Date: Sun, 24 Nov 2024 21:13:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/17] common/rc: capture dmesg when oom kills happen
Message-ID: <Z0QHio94WfCBTLNv@infradead.org>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420132.358248.17693136056902875765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173229420132.358248.17693136056902875765.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 22, 2024 at 08:52:32AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Capture the dmesg output if the OOM killer is invoked during fstests.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

