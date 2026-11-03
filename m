Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719623;
	b=oyDdt3L7fUu9ohl0Sqh7KpZSOTk+pTelvHOTXn1AogWIMDlB26eI4W/IC8TeAEzqamGw
	 3+SPwYhNTJDPIrGan49zOJatHbyVI51xdNQKeiMzzDILbG2c3NhF0sTnUy1h26d2/lqGA
	 WUpL3+peXygAxxW+Xmdnv7hQnfX5aPrJ0Gw0u33VfrBhlEQnT3hzQ2M8Z2pCk9DTOnwUC
	 0QN30wtWzms/jobMW7STsDKxyj2El1Hb11gP7OJ0braXZf/xdfYeqQ0sGys+NgozV1lk1
	 PdCU4gkuLIxwphGOyg/RCFvBAwDFJP/Zh8umeTyQjPB+qkyJoO3QjLZSmCVvbhzbOTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719623;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=AVZUW7JEVGyeoQnEv0aslvSoDcn0jwFFot05lDDKtnc=;
	b=Vnzd23phh3ziru9j8kXNH3zhzrI/ZjyXfgMzEo2qESskvpSMQVF8gGAFGJp59dGUG3T+
	 usRveCuZcb5DWQwJA5UFqdTRifl4hlQVuZwJUjTSNEBd6v8yU+cGmyIg2M7dpCuLj65uy
	 scjsmAnzvx/kRn1dw2tGnjV9kGDxBdn86LEOMMSH4Kl7KIzC6nxchy773UyNKDNdk8z6O
	 4Dc0kQBm+MT+ePjl8AIi4egjdV9RQ5DLqm1F2HZuQv8VgGJSNt0782EjcAXUAWfGImRh7
	 104WlTqqvYcrqNCpoYh+RjA/k7kTe/nyv4becGsdie8bsyVYgqJAIwfxlDXQjQ5EYgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RZdU131h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C82C606A327;
	Tue,  3 Nov 2026 15:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RZdU131h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C2D1F000C1;
	Tue,  3 Nov 2026 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719622;
	bh=AVZUW7JEVGyeoQnEv0aslvSoDcn0jwFFot05lDDKtnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RZdU131hHHiXO815LwHHIQfeuVTRF+gd7FcxH4k1B5Py73GQ8BHW2XtljNxk9Yozq
	 /6NUVmAvu7H5yF7ulh0kBbVYsTKFZ6bvWuPrQufn0VS3N/O9xv/hzSN0QIgb3wuRgf
	 DyANwWe83Ttk5AHodaZ7cD4ZsocRYiQkehg2dkLP1JEzFP54iz8DLGPf/yCfy7TTUR
	 VNstnWmiZL9CY6BhaH2IeMZQovL/gZ7DWx+XUjNaYw48j7hTEquPBqpfJHJFIY81hm
	 uk48B0oWaVMg+NYBa5TZ+0Dq05fSp8lqqiTPCKlNrwJV+eVAaxfu0XhcCEqIIgWT6y
	 zRMEUXCQVV37g==
Date: Tue, 3 Nov 2026 16:26:58 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	david@fromorbit.com, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 05/15] xfs: handle fsverity I/O in write/read path
Message-ID: <aun7nfkSqaV2RT1c@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-6-aalbersh@kernel.org>
 <aumrai1iWxj97svo@infradead.org>
 <aunQUzz7AV-qvys-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <aun1e6gedSrVDuRQ@infradead.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aun1e6gedSrVDuRQ@infradead.org>

On 2026-11-03 06:53:47, Christoph Hellwig wrote:
> [Note: a question for Eric about lifting a flag to the VFS below]
> 
> On Tue, Nov 03, 2026 at 02:55:48PM +0100, Andrey Albershteyn wrote:
> > > Is there a reason to not just move the IOMAP_F_FSVERITY handling
> > > into xfs_bmbt_to_iomap?  It would break if single extent is shared
> > > between data and verity data, but we already leave a large enough hole
> > > that this could never happen, right?
> > 
> > I think it can be moved to xfs_bmbt_to_iomap(), but we will need an
> > offset there. The one extent case could happen if file size is
> > exactly 64k and we got continuous phys space allocation with merkle
> > tree (then the extents will be merged).
> 
> Or a multiple of 64k, yeah.  I though we went for an "air gap",
> but I have to admit I forgot all the details of this already.
> 
> I guess passing an offset it is then.  And maybe also add a comment
> about that while you're at it?

air gap is zero on multiples of 64k, this is more of an alignment
with largest page size fsverity supports than the gap between
data/metadata (not to have mix of data/metadata in one page). The
xfs_fsverity_metadata_offset() is

	loff_t
	xfs_fsverity_metadata_offset(
		const struct xfs_inode	*ip)
	{
		return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
	}

-- 
- Andrey
