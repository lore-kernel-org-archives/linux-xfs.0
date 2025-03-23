Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504024501A
	for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 06:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742711651; cv=none; b=AnzxFvWsAw1DMzzasW+NPeOlgx310KEWEM8aJ+lrdpT4axI8Hg0rhrmnaitCduiHzCikNZMI+wpt9PZC7qRJB8x8Cf8iSlo3qIlnSta6GKrgR5ys1tVu4f9y3Gp+KdGGaKqUmj/T/n1r6VtA54XfBByVvOVZ4ePooxjAEXvxr4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742711651; c=relaxed/simple;
	bh=WzCjjR0NDFOAFeQwoviTEX90uN7nBzxt7Q1DEEheKog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pmog1b1fpK8SRFpG6a0yMBByyrPXLwdMYt1nj4EY2VL5KB3v3DIpJppbNpOE7Mvb+DXhbpCFwQn6P3NdCEUxIc0puLKH6zRnvWX8hISKWXM76A2JJnG6pPsS3DGcsWhuFl8+Ccqv8Qhc9gYHh8JEwSJ7vAoiTyd26hJZumc8/xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VI+/euaa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VI+/euaa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XgWUbOOcwmaIfmp2NbGBN7rxMVMRKts74eY5RBI+t0o=; b=VI+/euaa5V5+FxmoPxMQ24SPxZ
	sgaUkuvnH0JH38JDQKDOX4BNtUsaHVRYkn42FuqOLeVgLxSY4JZLTU1kOzhsJkhd+dEauXbxmgT6f
	vRflfTdlRy5amFH40GS7wXdvTjmF0hwP5futQCf1DchtFlUhJiL1lkyfroVYjU3ok1AMez97y+iqZ
	XHGsawpUEp6DHYm01aLvUftHbeRh9J5OnvQXMP2HYzS/bG6QfLBb+DQY4qA2Av/q1cuH6T8ydnQ5P
	ATj5Mhev8N7p5AwGsQZ9p9enHWLZ8GxCNXaH+kmBrzdGx4LQTqGjsvcUy5vFVnZFR5ljfKOeNLtQD
	agST8IMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1twEuP-00000000lit-485P;
	Sun, 23 Mar 2025 06:34:09 +0000
Date: Sat, 22 Mar 2025 23:34:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/4] xfs_repair: fix crash in reset_rt_metadir_inodes
Message-ID: <Z9-rYZFH78Eb45XC@infradead.org>
References: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
 <174257453632.474645.11619039334465128305.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174257453632.474645.11619039334465128305.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 21, 2025 at 09:31:46AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I observed that xfs_repair -n segfaults during xfs/812 after corrupting
> the /rtgroups metadir inode because mp->m_rtdirip isn't loaded.  Fix the
> crash and print a warning about the missing inode.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

