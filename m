Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A204192D7E;
	Wed, 19 Feb 2025 06:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945153; cv=none; b=DktDCXSKjkv4xHxFCMH5jGg3jMj4oCBwKkTH603ql8EkS+aukdH/SiWwx67yWDyo5cSXcOwc+PUNojxI0JvmPaif5fzlWQU4QXlzLQo3w7LElEsDjddeHYY0ELeWOr+78uY0Ypt9DgP5aQWpAuNywRd7ngiLEuUgO/C8FtmJ1PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945153; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8EimQsW8kOWfXyeFYykfin3QtnmkmlgjShiH2wSShA7p1iKQ6pJ6yagButlsrjjIBqlea38mSfjWFYuhZF+Zr06KOXhN7ogVNN2U7+JKZujgCdJ0Ga/PSrwkirvPDA88xAMW2uZvKPCBDDdTp1yj6oghysXZVo7yKnMb28Icis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U20xsVNY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U20xsVNY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=U20xsVNYshNCbkiQf4zunwysOC
	Q0hQKTnKNzqzveon+58wLOZEo6D4ovXHBPKEqMey//bHtFLei1EgmGRE6X3S0hq4kAX3TL4aW5Xo5
	hnr/LlNUsX2uJ6cm7V6+xRra1QvsFYdKG5T5+2LOxZFuC9CT1bFUGDZjrhpdcLb0psgw0BWUjuePB
	FdqdyUssErj+Q0S2vSqw9GYcmNq14SALV9KJ/K8tm+9znWyWJSoL3/FCY+eSejcfXweZKwjtLqp4D
	zBNtfK6MBTP9s6wpZ5Vkiw+q2kjv3rknc6934N7Owg5LUuRC9WL3lmu5zDcm2w7pZpQ2pls5n56t1
	55lQRTlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdDU-0000000Azjs-0k7E;
	Wed, 19 Feb 2025 06:05:52 +0000
Date: Tue, 18 Feb 2025 22:05:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: create fuzz tests for metadata directories
Message-ID: <Z7V0wJky81szxUVv@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588190.4078751.15589074585657780588.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588190.4078751.15589074585657780588.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

