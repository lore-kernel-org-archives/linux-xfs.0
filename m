Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E4613281D
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713285008; cv=none; b=YCo+G3RqdyBpR96rhpG3OI+ySB7qCM+nqatNVw1CZJv9ncksK+UGIBj9po5rHl9Npnq5V1aT6awyWeEtL8WAH9Aqsq9vKLIWu0nK1KpsjrhF/ZAFXsrbPXmz+9S7Zm59XsvGKE+VTlgrsuo6X9P5nbR6P8vW7qSBFLEpQGbjCfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713285008; c=relaxed/simple;
	bh=oggfq0wNFIwN4xQKWlbNERHNA+oRGmQSoy9pXh+sTLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jv5Fj57BxaqzPay7yHPnsapQJx4blRu1SvnPk5UiomYzMx1RPqQl4wmlXS7NlrMcD7ae8eFjeDEXnWVWho23LigAJU7Y4IVg7HV7GRFgbI0IBrY00CVJfKp4IFnnP59JGkSzcZKQzqo1FWx1RViN582+WxGz0/PZLnTn0pVdKBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R4Egx18v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R4Egx18v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VAbCzEf7c7a2zZtYXypYYXHjs5nF3y26rxc6OGxLQWg=; b=R4Egx18vBZos8o+xul4iIIfDT4
	3Y2ly8rR17/gCHxBLevF4jrdekQwSkB33a2BOFanGNkWbmHYAxGNoigeUtebveoQfuSSw6JKHI/aw
	s1sNOwizO3htT+ZG113wP2BgOB6fo1B6CATtexjVnfmShsghhr6oF0+kwbU18lyByqotx02Kql9Lr
	wEZgMbqIwnbpMree8jHS5ONhiA54F5KXeTu3RbXyjAsOOESZpp9MNWIziZq2EpuGF2UD6ueUg9SAx
	EXS0jwW6c90ffBXqEAXMBpqZw4iBd1PzFWGY9TN0yu89hyXZt3n6RL8wsbfXfVNxWpKTM0mWw7wi1
	E9HNhnOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwlh8-0000000D1St-3onk;
	Tue, 16 Apr 2024 16:30:06 +0000
Date: Tue, 16 Apr 2024 09:30:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] bring back RT delalloc support
Message-ID: <Zh6njnD-b9v7TPV8@infradead.org>
References: <Zgv_B07xhnE-pl6x@infradead.org>
 <877cgz3rmt.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zh0CHF5Fl3mqaSvV@infradead.org>
 <87a5lta2kt.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5lta2kt.fsf@debian-BULLSEYE-live-builder-AMD64>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 06:23:26PM +0530, Chandan Babu R wrote:
> Christoph, I have pulled in many patches for v6.10-rc1 and am now encountering
> merge conflicts with your "spring cleaning for xfs_extent_busy_clear"
> patchset.

That shouldn't really conflict with this series.  It's also not anywhere
near as important.

> Hence, please hold on until I update for-next branch. You could
> rebase both the patchesets once the for-next branch is updated.

Ok.  And I'll give up on the pull requests as they seem to cause more
trouble than they are useful.
