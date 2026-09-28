Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7174A369D47;
	Mon, 28 Sep 2026 21:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632051; cv=none; b=VWjT8Cl27BV+TFBrp00Ec0x2tdU++HpDNxhNjQY8rU/SXxXBQw9vnL93AeYeyemLRUUOs8gsbk6gwHywfeJWtiTTTffstktI7/NdTwUlnPSJc7wQMuNQYyoLvXru1nUSJ11TzGmnB/9/EguMPjesOdKxEpWNt+kkyTPl7GPTMcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632051; c=relaxed/simple;
	bh=XDhmANSHnsKMZgpjJGvMLm+X2Jo+EJiswUPfknfgl4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBpa1CnizUK5x3zHWDxJP5cGdEkpXwrpc/nmdDAOFt9rzWDaHEIQFr+f75DHdq7yWEvKG7lqP5y8pBEiNUnRpQt0XnG8GuIWjAhTBa7jH3asFWU8FVKssTxRmEk2Emf+zyDJGzLSQl5n/8iGFSL2m4s9GgN2UZ5GN0zsn4szvpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inMMAmeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inMMAmeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB111F000FF;
	Mon, 28 Sep 2026 21:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790632050;
	bh=xMR3e2G5T4zW/+hbNeFbKTp7voX4uiEQlNEhBuxOoUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=inMMAmeo762n7w76mTSS95s8wLxKcWoO23u28kpZaAvJWthvjS376wy8FBMCmZ3ZS
	 DQyvDaEglAm3/QFEKQfqcemRyjAlBB3Safz0FwFt1HtVBV9n0XjY7XPzZ+sokeD4vF
	 TkQHqZpXVzkyHDzu+OR91h4bPBwuuICYT4ZNhnzx1wjJ3GEddTLJ42Cxn5P6vO79Iw
	 6rir4JdsXDupSEq0/j/2KjqtrW2eeOsI5p9d+6KWQl4XEfHmf6jdN6EmxQOpbivL8O
	 arh8HC+xKbnwFMZOEm16Rk1SuvczsKOUkXZHbGg/S75iIktolCf4nypw45vD3ysrem
	 gFotxFJ08JldA==
Date: Tue, 29 Sep 2026 05:47:24 +0800
From: Zorro Lang <zlang@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org, 
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: exercise a failed CoW conversion during writeback
Message-ID: <arrf6KFNPOPUldgd@zlang-mailbox>
Mail-Followup-To: Andrea Parri <parri.andrea@gmail.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, 
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20260928085047.7250-1-parri.andrea@gmail.com>
 <arprh9oyZEXs25CQ@zlang-mailbox>
 <20260928154149.GA6253@frogsfrogsfrogs>
 <20260928162443.352542-1-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928162443.352542-1-parri.andrea@gmail.com>

On Mon, Sep 28, 2026 at 06:24:42PM +0200, Andrea Parri wrote:
> On Mon, Sep 28, 2026 at 08:41:49AM -0700, Darrick J. Wong wrote:
> > for ((off = 0; off < (blksz * nr * 2); off += (blksz * 2))); do
> > 	_pwrite_byte 0x59 $off $blksz $SCRATCH_MNT/file2 >> $seqres.full
> > done
> 
> That's nicer, no loop counter at all, and it writes the same eight
> ranges as before.
> 
> Zorro, if you're folding the fix in at merge time, please use Darrick's
> version rather than the rename I suggested earlier, i.e.:
> 
> @@ -48,11 +48,8 @@ _cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
>  
>  # Dirty several widely separated ranges of file2's CoW extents so that a
>  # single writepages() call has to submit more than one ioend.
> -seq=0
> -while [ $seq -lt $nr ]; do
> -	off=$((seq * blksz * 2))
> +for ((off = 0; off < (blksz * nr * 2); off += (blksz * 2))); do
>  	_pwrite_byte 0x59 $off $blksz $SCRATCH_MNT/file2 >> $seqres.full
> -	seq=$((seq + 1))
>  done
>  
>  echo "Inject wb_cow_convert_error"
> 
> Again, happy to send a v3 with this if that's easier.

I've merged it with above changes, feel free to check *patches-in-queue* branch.

Thanks,
Zorro

> 
> Thanks!
>   Andrea
