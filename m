Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEE828368A;
	Wed,  3 Sep 2025 06:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756879513; cv=none; b=F6TrdbnPqANcr1pp+t8R5x7gS6yhLt0/0Pm7zqoXM7qaofY234xBeKutmv/PkDH1ALxM7YozbRjSxaJfpggpcP8JaA/NXriQTJaN5nRmh/Dj3XL6o6s2lFJmZsJU2Owv071hxRucolQS2qmzsrKBbXmmuzu9TTJ4W6qB/8oi6pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756879513; c=relaxed/simple;
	bh=XRYe6k301hVMrjUu3bWA/ITB1UE99EqwDnjHlWIAJ5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BR5xiPtQ8qEsPqA5V1SuyGlyN19UsfzFKyIujylGXE6i8RZnmKhwD9uJ449IEToQR4mVqbuUmSquyVKT/5PXMDjEZfrOuxHFPcpajI7DMcxeN112ZFsNShY8BGbwPvytD5lPBvjKerpFDOHquoRZ21pzWRSE9nCtjVmI2eCw57Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cT+veg2Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cT+veg2Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XRYe6k301hVMrjUu3bWA/ITB1UE99EqwDnjHlWIAJ5k=; b=cT+veg2ZfXSKObX79Q8bWSzWNL
	JLbLPgt/4aBUWUx5eNU8PMZvjh/HLOlT8bcjI+CVSzkB3Fs//ZteBKkMv3CODCVlpOZ3FWVIcE7pP
	QTinsa0W301Ffsc66xKDjgsxmoS+j9NjIxRFwwHw6O3JOC969gGukX9QdUf+ne4CWsG4uL+Bj2EKK
	4uwi6wpeE4u+p1RV+nyzlv6bBngAu7eLxbRs/i1LAb0dbF9ZVF34/RCyOk7+5kyxwHvd7mH+7lBBk
	293P6mfjU2SgzUjFV81DmQlyfr+DJZaeSj9hPITgc6ZFZCn+9PABLgFB1V3rGi/D020hWPOMHtG+v
	Wf85/xBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utgcJ-00000004SJ6-2O4f;
	Wed, 03 Sep 2025 06:05:11 +0000
Date: Tue, 2 Sep 2025 23:05:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+ab02e4744b96de7d3499@syzkaller.appspotmail.com>
Cc: hch@infradead.org, cem@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] WARNING in xfs_trans_alloc
Message-ID: <aLfal0B4HnWJVWz1@infradead.org>
References: <aLfaWUYaqDk1d85i@infradead.org>
 <68b7da5d.050a0220.3db4df.01e7.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b7da5d.050a0220.3db4df.01e7.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
