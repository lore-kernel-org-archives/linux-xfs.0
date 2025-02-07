Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1054BFC1D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738907988; cv=none; b=F95gUCYVgvfUWV8wbFq6j79FFIjQ/obFoNQzMhPrmOzDw82DvAg6JXA/Q5mg7ib0/fJhKiJy92/Zx/Ck/7kU+r8XM6vO0FO0ztNTI2AAHg5wXk0Z3Fvw5oZWjXPmAzJaoBKNogtVigfUGoNOfQuKU7M1jyi0bqGwAkndmGCV4e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738907988; c=relaxed/simple;
	bh=dbBaHE1PlHB0K4G0GDAj+PhlQIyE3XbZ+846rE6TK38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nAmIrf+Atru9ychENkmAxDaDN2NASHAVrj0DCXTtEcAmlttxMhnvfHjrIYOd4/8DYCjhAV4lCvcbBF7JWeUh1veVl8bP3FtgcaYym5cHAZbzl7ZjVwDfSTv/+VyLz6AfV8/wcKhXtwFpu5NZjB7+6rW/LdSRbYqY4MsLAncQm0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mPhzIxdQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mPhzIxdQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V8payGmRVaxQz0gHf9d/+RNtH381H6keY+DGNQVkPVM=; b=mPhzIxdQLtyibHbSRsk81Ttcc8
	1feNEj/ze9jNy0EMdPZ7UL85zLdkMANZOEiEaPWiY1FTONcaZGrXMNIb9zwc3L8Xe0o+/dSMJa8uT
	jMhCYXNJKQShrHLhd6UNzLGeWo1hOTr365+hNUDe8AEuwctNR5rWKjmHHzU0YAz5U9uv8KT0Fs6Ty
	1usBRrH44eNLZS+gQyz+pselWB95i0RXyOQMUFdXhobayZEZPOlcuc9/0qyvsiEMNmTOQsZKp0ODL
	jBxYbEzEBjLnGIaxOoruDwqH8lhRE0fgGE/cC1uW+qZ+nwisEzRmodd66bJ2BNWzlCvFeEMTbloc3
	NAzhlB+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgHP0-00000008RNh-2rMD;
	Fri, 07 Feb 2025 05:59:46 +0000
Date: Thu, 6 Feb 2025 21:59:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/27] mkfs: add some rtgroup inode helpers
Message-ID: <Z6WhUgZj8I3Ql4gO@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088495.2741033.10645836020741372245.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088495.2741033.10645836020741372245.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:56:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create some simple helpers to reduce the amount of typing whenever we
> access rtgroup inodes.  Conversion was done with this spatch and some
> minor reformatting:

Shouldn't this just be folded into the patch adding the line touched?

