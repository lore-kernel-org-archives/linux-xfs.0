Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F3C38A29A;
	Tue, 22 Sep 2026 12:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790080133; cv=none; b=CWX7tAJ38DYOEjD878WbDh1QZq4NBepmXxExtFqZs1vWiBxhJNMNWbsaRdsws7TJJKdLxFd1tv4YBjSVroRegEbCOlW8lmV69ut2ditLQmz0IP682fnU1r7NaXuI+UTivsjYyVkLJEL9HlgXGpluAKTLd06vfxdF8xsKBJ50kXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790080133; c=relaxed/simple;
	bh=WwsWF/lpI0aKuZc167ppsxhbW8HrcFlp0JC6ZwKNtWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npKTurVBFE7Hmt7yvaXLxE4gjf3xd4poNRBw3hWd0f0XbUeLntNOITD4Rh4dYFUcQJmhVjzM0dJOejBybSm3BBk4SHfvWNuz3ONj8Rd1aaRS1LjvBhvCKbpx4jnMJNd1Dl4f37SZzQW8R+Qqmb4gzF981xUepwCIJ1Rhc7qM/A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zbKU06Pe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zbKU06Pe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hGo6eU1o9GNAle32mTYCxcoAhPMYTLb0x27Bwef97sE=; b=zbKU06Pe5ofTFH3hIb6e3kLHxV
	vvkmv+QxXAgWsqH9x6hfhwsU2WiVfEtBZU1drf7tsvbTw55Jw8EVG19V1VjMGkp6eiheKs1ITlkyg
	gv8AjbOanmtDnIoFx63Ue++eEwPHejY2RBkTjaDx9pLGNyQKh7ZJ/D6xRYVUmdrhP54TAY1e1SWM+
	9R2WeWDmD5Z4iXqiHVPu4IW88Bm/U8Fr4+WeAaLlwsHEKxjYx3Lwt/eHrtLIVCXbjrm1P5zdyiwfa
	uzKjMCnT7Eoa/617a1bJJI/xFzcmlgChLv5rM6dsl7rbBl8Rr15SDp/EXGDwDhZsDb7NkGCm1TnfE
	775SiK5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8zc2-00000005J89-0JzU;
	Tue, 22 Sep 2026 12:28:42 +0000
Date: Tue, 22 Sep 2026 05:28:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 3/3] iomap: don't lose a failed direct I/O bio's error
 when zeroing the tail
Message-ID: <arJ0eljPZIuj5PFD@infradead.org>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-4-parri.andrea@gmail.com>
 <20260921223432.GO6283@frogsfrogsfrogs>
 <arIT5A3MR7VtCeba@infradead.org>
 <arJF9USiUqIEWB1M@andreayoga.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJF9USiUqIEWB1M@andreayoga.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 11:10:13AM +0200, Andrea Parri wrote:
> > > Why ssize_t?  iomap_dio_zero returns int, right?
> > 
> > More importantly iomap_dio_zero can only return an error for a
> > logic bomb assert using WARN_ON.  I'd suggest to simply return without
> > an error there and remove the handling of the iomap_dio_zero return
> > value entirely, as it clearly casues more harm than it helps.
> 
> Agreed, that's cleaner than retyping the local.  I'll drop the
> zerror/ret handling entirely for v2 and just call iomap_dio_zero()
> without capturing its return.

Please drop the return value from iomap_dio_zero entirely.

