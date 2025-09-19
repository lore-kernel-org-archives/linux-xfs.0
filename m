Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5013176FA
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758295841; cv=none; b=PjEm3sB8dNlKgnTnJbHfhYFci2pLMQj2cQMG0bU8C61QpmUpAde/rIfEWF1zTNZoyPHMY783u7SXUyvPWmr9iYzdJFAVk8vrUsNpPCyWrpF/zXpqFUFbIW8MfzTHL3pbM7aYFf+opawqXU+Llz3YSnS6/Cz1wqLMzjOUoK22JYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758295841; c=relaxed/simple;
	bh=0+OZz0+68+94Qv9YpeOJNDKov6wKwBQzL9Rbxdp1KGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEFJHcFPSWlVa5YxF3Ryf0XabWkAF3FcCs1xJzfbHzTkVV3m2QNxrKRnnu7Hp5xbUv4s2ElLpPoznJnFZmqogsDzVQ1nZwk6mcFLuj61FPYgiuBG7/aBspCvu6tepUAwuaCDge7pUxM7oZYEGbRhEDenMTiBMl/YDKEDfNqlHzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MtHmjTSu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MtHmjTSu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nN7CjETO0Ek7IIZJG2ZHiq1NeqmU/XG7eTjSYfE39YE=; b=MtHmjTSuc8QMfK2c3jIZsgykJw
	l31SgGvpDc1RQIYk5a68fvoONw/nsXJaqtX63nH0UVXX+hsWuiL9iPo7cOqbcw4PufDTBJlaX7+yQ
	6rk0ZoWmBOdP5ZwE2oDebiFucqccxFi4ZreB4t2ALiETFVZVCuRnlAw+s597+fQSyZ1j3I51fxRw7
	wmqDS8AQ/afFnbusCzSuD5OpquA8UArWDwR/WtBIzH5kumtPsrIBCjcTHAhCc+lJElX1Uv0IPAq8z
	zEHR8b4GZWrMFPSLw3g9jrO8goyTn7ZEu3r2p1rqA9onx8Tajqq6XbmkFxDmMZCBLpiGHMr/rIHQ6
	dmuFrDfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzd4J-00000003L94-31el;
	Fri, 19 Sep 2025 15:30:39 +0000
Date: Fri, 19 Sep 2025 08:30:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, jack@suse.cz, lherbolt@redhat.com
Subject: Re: [PATCH 2/2] xfs: rework datasync tracking and execution
Message-ID: <aM13H6P-lMYjR-9k@infradead.org>
References: <20250917222446.1329304-1-david@fromorbit.com>
 <20250917222446.1329304-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917222446.1329304-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 18, 2025 at 08:12:54AM +1000, Dave Chinner wrote:
> Jan demostrated that reducing the ifdatasync lock hold time can

s/demostrated/demonstrated/

> came to the conclusion that seperately tracking datasync flush

s/seperately/separately/

> seqeunces was the best approach to solving the problem.
 
s/seqeunces/sequences/g

> operations are allo done under ILOCK_EXCL context:

s/allo/all/

>  xfs_fsync_flush_log(
>  	struct xfs_inode	*ip,
>  	bool			datasync,
>  	int			*log_flushed)
>  {
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
> +	xfs_csn_t		seq = 0;
>  
> +	spin_lock(&iip->ili_lock);
> +	if (datasync)
> +		seq = iip->ili_datasync_seq;
> +	else
> +		seq = iip->ili_commit_seq;
> +	spin_unlock(&iip->ili_lock);

If we care about the additional speedup of the READ_ONCE done
in Jan's patch we could make that configurable on CONFIG_64BIT
here.  There's precedence for that in i_size_read for that in the
VFS.  If we have a helper like:

static inline bool
xfs_inode_sync_csn(
	struct xfs_inode	*ip,
 	bool			datasync,
	xfs_csn_t		*seq)
 {
	struct xfs_inode_log_item *iip = ip->i_itemp;

	if (!iip)
		return false;

	spin_lock(&iip->ili_lock);
	if (datasync)
		*seq = iip->ili_datasync_seq;
	else
		*seq = iip->ili_commit_seq;
	spin_unlock(&iip->ili_lock);
	return true;
}

we could isolate that to one single place as well.

But even without that, the patch looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
