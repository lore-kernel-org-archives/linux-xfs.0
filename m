Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D181DDEC
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 16:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706287680; cv=none; b=SHl9jjrVhSiQv4//a1Kqb4mCtD9BCJwbFNfeLGWSriQ5liz9QReNX93DWP32bhYkUt6fQGp1PxaCUDuEICRWewKo+wxJr78s+nzpSOTXQllOt/OZVhMHMwmd7lDtlSScTMcgNUrYF8hB10TT8jmZ5Cy29FBYIBcbpmvYgIA2oSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706287680; c=relaxed/simple;
	bh=QAuBut075bQsFpMytI6aLemdKVuNtYSYhaBjCjTmBWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eRiugS6cGOc6+hk21uJxTgymOjkN4JoXhaxmxap1meNCu6OKjXIQwsdUNYk8xJQpPEpKR/JtTdorYuwtwW7ZmiseX3sb3y07hlHwmWdIWb1MtPA8ToOra/FkDipQ+TRzjkVzPUNMx1mrC3LKjaJGgvexiNuRiDNzwfT9sAwBuSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KrYpJ4UI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KrYpJ4UI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AB4C433F1;
	Fri, 26 Jan 2024 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706287680;
	bh=QAuBut075bQsFpMytI6aLemdKVuNtYSYhaBjCjTmBWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KrYpJ4UI6iPm7G0mK927Pbz7ii2aJw7ZMv1sf7jPDYdDkKfvegIXfEbDm8XfyGzA7
	 AXTBmP/cBFNS4IyCOyt0w0Jx6XyUObVKWMz++k3AqbvzOLPsqSMfp10n2+V0bUBCoy
	 StZ4gNCWnWvbXOl/zsA0zQclTd+H1oRnqDWbOGX1qfs3Ha/aiOjqJ8md7oRUaUWbkG
	 u4SR/yFLqxzbPoqexqGcjUoe0P5JcYnjvhN3o9qCBTRo90eG4m394HmWRE6tdE6xY0
	 S1KQjOz4OKDy9uD/xEciKJplmj7HAaRKCepVNx0JofG0ir+Cj/LBRpGnrcatJSx/Tv
	 b02bLFM+sIpEQ==
Date: Fri, 26 Jan 2024 08:48:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/21] xfs: remove the xfile_pread/pwrite APIs
Message-ID: <20240126164800.GB1371843@frogsfrogsfrogs>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-10-hch@lst.de>
 <ZbPcIPTFX_XpKIhw@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbPcIPTFX_XpKIhw@casper.infradead.org>

On Fri, Jan 26, 2024 at 04:21:52PM +0000, Matthew Wilcox wrote:
> On Fri, Jan 26, 2024 at 02:28:51PM +0100, Christoph Hellwig wrote:
> > +++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> > @@ -1915,19 +1915,13 @@ four of those five higher level data structures.
> >  The fifth use case is discussed in the :ref:`realtime summary <rtsummary>` case
> >  study.
> >  
> > -The most general storage interface supported by the xfile enables the reading
> > -and writing of arbitrary quantities of data at arbitrary offsets in the xfile.
> > -This capability is provided by ``xfile_pread`` and ``xfile_pwrite`` functions,
> > -which behave similarly to their userspace counterparts.
> >  XFS is very record-based, which suggests that the ability to load and store
> >  complete records is important.
> >  To support these cases, a pair of ``xfile_obj_load`` and ``xfile_obj_store``

Nit: s/xfile_obj_XXXX/xfile_XXXX/ here.

> > -functions are provided to read and persist objects into an xfile.
> > -They are internally the same as pread and pwrite, except that they treat any
> > -error as an out of memory error.
> > +functions are provided to read and persist objects into an xfile that unlike
> > +the pread and pwrite system calls treat any error as an out of memory error.
> 
> It's a bit weird to refer to the pread and pwrite system calls now.
> I'd just say:
> 
> +functions are provided to read and persist objects into an xfile that
> +treat any error as an out of memory error.
> 
> I wonder if we shouldn't also change:
> 
> -Programmatic access (e.g. pread and pwrite) uses this mechanism.
> +Object load and store use this mechanism.

Yes.

--D
