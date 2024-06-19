Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1425A1E495;
	Wed, 19 Jun 2024 06:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777946; cv=none; b=GfPY5vMOSH4uTKYjs7yMB+EVuVd7hN4dBbuMJIIWnDot5OEtTbvUB08WrR9hZBlRQpK5eoDoeHmVX7hhmgc8gChhbWlbXCLm+YdCrE6ECllMCfhU/IrojXaFaY78l5EGratSatl+D4LMepgZXeiFG0qSvzq/CYaW84jw3ppL2mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777946; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GMURDXR5EoHpUh1JD8reOs3sc1elZQ26umI6CwsYAr2LX4wxwBdV6AQiUWB+1onpsuzas4EkrS2kcyDV2m0iAzUw4V+0HVbUPXfuJjVoEKTjSc0WSa4dedw+wV/t08b9+5/MI3coT+otF6lMdrdJUrYqs4HT0Dl+Wqud9IsCPAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F5KK8Ca+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F5KK8Ca+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=F5KK8Ca+3HkYuhfa3wqKB8iIKC
	Bq3zYuKIzytK5ophGHXnIyopyCivdlFb173rkemQXiZzPAprLFpYA1k3d3SK33QUwRxQSUW48lToF
	9qjkMobc2yXyMvWWAno6vWTz3HWi4fEw1pbZ6vn1A3Sm9HWi4Dyu5qfk5LfOh9dmxIaSPGeXBgmNU
	VUm3nX10Zu6qlg+7wD+YWdEMm4GyXtbrDV4ck70uWzOBNEeuDrB1kdJ5p618ahbPgCBBnhf3ZpwT0
	63kTIYf7JH9O+AvmYouKEuz4zCDryk0waWxLq4oJ2VsKtz6Te3+H6OmfTu96LjZoxVun57wHDi+Fe
	9YNtATBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoeu-000000002Qv-0iQ0;
	Wed, 19 Jun 2024 06:19:04 +0000
Date: Tue, 18 Jun 2024 23:19:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] scrub: test correction of directory tree corruptions
Message-ID: <ZnJ4WIIOIn4ZV-kz@infradead.org>
References: <171867146313.794337.2022231429195368114.stgit@frogsfrogsfrogs>
 <171867146346.794337.14515921328114662170.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867146346.794337.14515921328114662170.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
