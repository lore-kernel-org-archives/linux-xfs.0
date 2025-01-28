Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB46290F;
	Tue, 28 Jan 2025 05:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738041345; cv=none; b=nBeWtY6Vp8ZNWQ3feJuNtJw9AOxt2m8w3EKZ7oKzqipRHLjnPoB6hyUemJ36QCBuXasTUZPzDEGezoTZK4Q3KUylZ1W3Hdi5D9zmEMUqpO5W3yIyxDumoZQKNAFz3KzGrfzFLJCOWIsghmZbrLZFoU/c6OhAb6CHdlEKVT4RhuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738041345; c=relaxed/simple;
	bh=WR5Gh8cHSREOwQWo2nhOPaXRrHo344DA9jrYtdsIbTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6jfafp0T5y23Ru2ZdeCg5O6tjLmh9PtZzIN8PL56rJRyIVGjyiCGguI/pu5lOr4IFeCboejqvZ7TylCYLlfLyppQX8LNkrKVU6cKyuB/PkQHgmt3XlCvFHld3sx3dqvXwqGcdQGH/pcyknMyEtR2bkeOqeQlyld5syehJZLeeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DD887C7c; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DD887C7c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yfBvMWIWdCQjjh0tpDUoUdCQEstH57TAnMRYWbWxNgo=; b=DD887C7cQHmVTFZ9kuKOqrNxz0
	cxHpjyckNoSRLEGG35Ij7VbGFsiVHUpCSq7B2mfKZefq3ZqOXVd/A9kslV1pk0u1pcIBVLsAdNbVb
	L8Tak3SweFsAs+iFhjHv1385xMl6OGcTkGyVyWFNwb8J2xsZkzkIQWkJcpPLMdFeMs06iI+RKh2mC
	ZD1LI/WKf7nRZy/+LMC2ijV1Bh+HpfuKjiRyzUk3EBKgPaydGev+iWvF9UJLYqzT88B8qAuXVTLCH
	qpKc0VJm9M6MWMMtk9ROAxIwog4WRxof98EYKCeTCqtsS3VkEmalJ0yC0FgIn0oZZGuAp2N+v5pcS
	JuWjaG6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tcdwr-000000048SE-1kUp;
	Tue, 28 Jan 2025 05:15:41 +0000
Date: Mon, 27 Jan 2025 21:15:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Chi Zhiling <chizhiling@163.com>, Christoph Hellwig <hch@infradead.org>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z5hn_cRb_cLzHX4Z@infradead.org>
References: <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
 <3d657be2-3cca-49b5-b967-5f5740d86c6e@163.com>
 <Z5fxTdXq3PtwEY7G@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5fxTdXq3PtwEY7G@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 28, 2025 at 07:49:17AM +1100, Dave Chinner wrote:
> > As for why an exclusive lock is needed for append writes, it's because
> > we don't want the EOF to be modified during the append write.
> 
> We don't care if the EOF moves during the append write at the
> filesystem level. We set kiocb->ki_pos = i_size_read() from
> generic_write_checks() under shared locking, and if we then race
> with another extending append write there are two cases:
> 
> 	1. the other task has already extended i_size; or
> 	2. we have two IOs at the same offset (i.e. at i_size).
> 
> In either case, we don't need exclusive locking for the IO because
> the worst thing that happens is that two IOs hit the same file
> offset. IOWs, it has always been left up to the application
> serialise RWF_APPEND writes on XFS, not the filesystem.

I disagree.  O_APPEND (RWF_APPEND is just the Linux-specific
per-I/O version of that) is extensively used for things like
multi-thread loggers where you have multiple threads doing O_APPEND
writes to a single log file, and they expect to not lose data
that way.  The fact that we currently don't do that for O_DIRECT
is a bug, which is just papered over that barely anyone uses
O_DIRECT | O_APPEND as that's not a very natural use case for
most applications (in fact NFS got away with never allowing it
at all).  But extending racy O_APPEND to buffered writes would
break a lot of applications.

