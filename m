Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA12A934;
	Wed, 19 Feb 2025 06:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945170; cv=none; b=V312MYz2+admqKUX9DfAFZKcV25EUrnVZTDDg3/fxAqoTXZhMPJsbdh/2JV2zuTNEcF2UVDcoS+M4hCrTdmDQOpAAeCDis3Lv7UUhNOzPIzmgo0Zcwy7zu4l+fJO/Gv9m9zZOP2ep0C4V19hCjAS7f9z2DG3sFemMx9hW8DdVCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945170; c=relaxed/simple;
	bh=XasfzNlpoUbW8DzfTZ90a8+5c9HLjSkk7QBJ+/TBCE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qyzhROEkMQSSZOC7VHwdx1Y9ecUIsMWzT+cfXwR8SPW8BUuX7SdOZZ21em5xFnO3HgK6gkIapasX3nAYfLXtBB0IvGMmYUiWFWp4i9qelNsWOxkrFEbufeCRlnDVSzXNVEwwqed2ZOCMvitpGOofvfB6gYJrW9JBJcCtO8KrTFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qHhhDOt3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qHhhDOt3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+TswhnBufp84BWoJubuGx3x8pbHoAWaGM+dtSmTARTA=; b=qHhhDOt3dyQ3AWiRhAtPULYNlv
	gbYTPz2cEXZ7PLm4xlnVnB8g8xLM93KYv39lKivEXXRcw7eJhBdAIt/pbRgMNRsJM0wKkNJdyNDJ+
	w/1QplqAVhXD0lz+IC/q4NlHFR6pYDm2q8IDxh2iuyAAR4oQberI6wgGfNOJ9nR+CzLjKNAI27RuB
	hY4QqCT3o58GACSEjjVQTgI+pzfcWhjLMyXpkOFHy+teF44J/UOP+75Bl93asX1WVpzAf+CMPhVrp
	wS/gFIAIgExlkcQtKR8ckSpDv/q8fBQGRi7KXBCL3IU+iZa1OI52fD6xUS/N6u+Y1ZZxBzOZBQAUA
	N5B5bZ0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdDk-0000000AznB-3Dp7;
	Wed, 19 Feb 2025 06:06:08 +0000
Date: Tue, 18 Feb 2025 22:06:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs/163: bigger fs for metadir
Message-ID: <Z7V00HpRcTa2_J8T@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588208.4078751.16040969808269964576.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588208.4078751.16040969808269964576.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:55:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Adjust filesystem size up so we can pass this test even with metadir
> and rtgroups enabled.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

