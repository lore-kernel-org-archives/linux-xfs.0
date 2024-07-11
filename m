Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B38E23D7;
	Thu, 11 Jul 2024 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720713691; cv=none; b=N5SlbRhPDpFO3kR03FX5PhMcYIyFMa6nd6xsXopRKagrsLkXWuHBdA5izdBUK65o7PCC8WnKMwChrE4KO600N8/eA3dIB5xRwlQicjfuxwqvmEtujD6QuE57HKuaNQj82OBqkOJGfsbi/RGzoGoMD6x8KA8GRUFt8/VgjrNhjHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720713691; c=relaxed/simple;
	bh=p7kG+qHwWkIdmMpCc6vZBDxqi2F38qBRL03Q+OrMAL0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nrNxdF1fq2Cs2E/jWpAjN7CdKepIJ26gSy+BKUSIhtg4XXDWV3a99ySkxF+7tjA8O3pj3nPM7AMlAdKPHsDywS3ELiBNZQwGn+a/0lcZufkYXWskDIPMGLxOzJpxZjNCAN0pDBAUMeDhbnVi5ct78GdCOZOLmtaTyQxbc5KgyZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c8chyzJP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c8chyzJP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=LLOHc5uUiQOz3StgLQ05KnNTbQs/AhE5avVmGa/JxrU=; b=c8chyzJPWTMVRaYTCWmMjNNFsL
	I1eH2CfRmsML+RZvF06TfGcTO/XsV0NNrg9wPldT9II1MLR1yDPUadpV7AdOMzSBI8YN+iP1rNsIT
	gh9DWRBS74aUz6L6SxQQPopHhRitIAw+vpQ9xCm1XEITiU20rY5hMIWgiPLKKFxMvZJ4j6vOVvKdC
	RtHsxYnBE3N2IG50m5/JyXgDFatGZTLn22EOCj19EheersAvNe3yCWtNJY8ghlXMIaQ3bMcMFO82j
	XFLOfNzPjWDZn0RBQQiC8rr1vrp8L3+qgic6KJZdo00eEkqMEKWt9mPzJc/F+TsXm2qcveXXQ4pkz
	HGOXpDxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sRwEa-0000000EbOg-1ZTF;
	Thu, 11 Jul 2024 16:01:28 +0000
Date: Thu, 11 Jul 2024 09:01:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix file_path handling in tracepoints
Message-ID: <ZpAB2HU8zE41s9j6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 10, 2024 at 10:43:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since file_path() takes the output buffer as one of its arguments, we
> might as well have it format directly into the tracepoint's char array
> instead of wasting stack space.

This looks sensible to me, but..

The nicest way to format the interesting parts of a file path is to
simply use the magic %pD printk specificer, which removes the entire
need for an extra buffer.  It would be kinda nice to use that for
tracing, but I can't see how to accomodate the users of the binary
trace buffer with that.  Adding Steven and the trace list for
comments.

> -		__array(char, pathname, 256)
> +		__array(char, pathname, MAXNAMELEN)
>  	),
>  	TP_fast_assign(
> -		char		pathname[257];
>  		char		*path;
>  
>  		__entry->ino = file_inode(xf->file)->i_ino;
> +		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
>  		if (IS_ERR(path))
> +			strncpy(__entry->pathname, "(unknown)",
> +					sizeof(__entry->pathname));
>  	),
>  	TP_printk("xfino 0x%lx path '%s'",
>  		  __entry->ino,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 56c8333a470bb..0dfb698a43aa4 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4715,20 +4715,18 @@ TRACE_EVENT(xmbuf_create,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(unsigned long, ino)
> -		__array(char, pathname, 256)
> +		__array(char, pathname, MAXNAMELEN)
>  	),
>  	TP_fast_assign(
> -		char		pathname[257];
>  		char		*path;
>  		struct file	*file = btp->bt_file;
>  
>  		__entry->dev = btp->bt_mount->m_super->s_dev;
>  		__entry->ino = file_inode(file)->i_ino;
> -		memset(pathname, 0, sizeof(pathname));
> -		path = file_path(file, pathname, sizeof(pathname) - 1);
> +		path = file_path(file, __entry->pathname, MAXNAMELEN);
>  		if (IS_ERR(path))
> -			path = "(unknown)";
> -		strncpy(__entry->pathname, path, sizeof(__entry->pathname));
> +			strncpy(__entry->pathname, "(unknown)",
> +					sizeof(__entry->pathname));
>  	),
>  	TP_printk("dev %d:%d xmino 0x%lx path '%s'",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
---end quoted text---

----- End forwarded message -----
