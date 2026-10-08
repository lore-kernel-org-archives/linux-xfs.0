Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6643AE1BC;
	Thu,  8 Oct 2026 16:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791477897; cv=none; b=WrQVt+iF3REsw/8WOoWO7gGpQThtJyNQua8LIqXoEf0E/dK9AFnS3k0t08psQolUnDx1b9gLVl6/Bz9JkrTupS+KvMAS20PyX48tb7Pc+nASKg1Iri6DYQprmeaqjp60lHMAffhUY1KkltzM3fACkbJTTl/PHhS+6Eb6IaL1Sow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791477897; c=relaxed/simple;
	bh=7tV8BRMZdSjjQ+wFsZrltGhnIcC3NrF9Zo7u9Nf6AX4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=WFOwG0HCrKKU2fntDxawnOR5r8lk+IBBK2MQnpaaYdftQ2HQIeq+arkrLPb7NhuOKFjudQQcMPyJNwL13kdJdc3HrZoCcR6gcSCBHqchC1CVvbnnVxwwKw5K+yxbz0O9Hw4Ead88TFYU7Yay/s2Y1ZSzBP1zPqnBnq2Uxxwbf2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LwvZOWrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LwvZOWrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3EA1F00899;
	Thu,  8 Oct 2026 16:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791477895;
	bh=EOLWPkdhYi4qVwglYx9ZNkz+Ir/6UM4RLdYhyJK61e8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=LwvZOWrKkGHhS2pwGXL1qw6GzOTlDBVh3AGxxnLso8vWwUKGN9nt2y/9cLMoxXKOS
	 ookn8FRQrHa/BL9IDx+URtnxXV+lraBPS/Rc/JAIAXVKiM7dEvZcHHuRUJa4/6qeCR
	 VLUE+U1xZA3Sj/hdA8tsX3jcOamJo7G6CrrbQOouxUzdAEp+No2FrMSVxdvFbXcYoI
	 xHxP3Ix4XBBcAus8d/2RxoXRadYVSKmM/Uw7aW42rdA9ZxNvoMSN03o5NPTInOMxzt
	 BqxXNzW/3KXJinv3nD/z8fszir3xA5gjiPK3aUe2YWmMsv8SXpabJgTHkDkjTDOcWE
	 vbm//FqHmSD8g==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 27D91F40066;
	Thu,  8 Oct 2026 12:44:54 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Thu, 08 Oct 2026 12:44:54 -0400
X-ME-Sender: <xms:hsjHapdwBb1JALUbXsHPYxLK7WcYz3Ux6hyj8D7ZYi4FQV1l2ehZGg>
    <xme:hsjHaiBuO_fW6FZVnxnom3A8OJVUuxNNMpC6_hIqEvQTWXF89OiGElUpaAqIKhNsO
    GTknRLM55z51CBePQuXjSLm3PkTLKgEDtQqS50IBtp__fNp81mnF80G>
X-ME-Proxy-Cause: dmFkZTGZKaxtIBuY+yj1fQkVEluS1rV9uwLMyU57JUlv6pkSFkT7nyLgauo3S8Imh9UDyg
    3FWL9SEuXDFtDIyqQlADThGRnqD/32GZSBNgrnlLbb0ThypE1eOYN05l2ISkNPCMyIucVR
    hU/WhxBfdG84BD/KZiAfx00WXHwL8ctB5qd0w3sxQXKPW7N0HLOlIHjFpRnOzhKvj85fmj
    1iFN+sdis6Ub8Ox1xGzChegCjUGiwQDK5sn5lBmp3kVDdDDAlrfcUi31TGsvg/nWt1dko6
    ERPhTbUzGSrEI8YBN3q2Bet1VVSYnatZpF+tGXF+txhl9W6m0zIRYem1VNF8/Wbl/PDJJk
    kv3m8fHK6Kv3+H92c3xOV6MM+GE84tBJjzLYEEWJIsEkvgtm/KIaoW4EO+wCEeDxci9gwz
    85IrZmbJd9iBRM4ajExsmHZjGm6dPTLGkqbHxTZBrkFShaNcpur7uuC4yj3++LJUBCgfN7
    CiibBPopWhQAVVf4uzIUiwhHUFIEAzYVeFvbDkYBYSjuLQGBxoj31QPlWZ34pd74nV2PeA
    qcjIMls3coxyImy+WFf4I+JgYHMGN6i/CoPp5i4ecAxLimNHnyl6ZopAocFg8W/uRsQ1DG
    5F/OUeEkBft7aKyIsFd5HPj1Mp13j25V4JhrL20ewBt6RgSCBbrUItxYPirg
X-ME-Proxy: <xmx:hsjHahoIU3yvzCFHdp6ffFYMlQx-9nZFlt8nO1_cPyQ1E4T011yy8w>
    <xmx:hsjHavmN3tUMTu2JlHo2OlgVu2fB6Viu-G0RgCXpo9oPcRUl96hnvg>
    <xmx:hsjHakXFvZXXRXTKgCuvHpENpk3yyCwCI-FPbp7KqKPiH3gxsDufiA>
    <xmx:hsjHajTVShXEE8VbBss11eugx0DPRuBK5EEAEfkoLrIz3lYtlwvP-A>
    <xmx:hsjHavAxGf2vTjVSrPliw1d6EQqu42Y_f7lucL1JkZYzrmVRxqkYOBsY>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0243B780070; Thu,  8 Oct 2026 12:44:54 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ANi-fZsmwLLZ
Date: Thu, 08 Oct 2026 12:44:33 -0400
From: "Chuck Lever" <cel@kernel.org>
To: daejun7.park@samsung.com
Cc: "Jeff Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
 "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>,
 "Tom Talpey" <tom@talpey.com>, "Christoph Hellwig" <hch@lst.de>,
 "Carlos Maiolino" <cem@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, "Dave Chinner" <dgc@kernel.org>,
 "Sergey Bashirov" <sergeybashirov@gmail.com>,
 "Christian Brauner" <brauner@kernel.org>, linux-nfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <235ae19b-fd63-4d01-9fe0-d047a33b55ed@slotpi15m67>
In-Reply-To: <20261008-xfs-nfsd-map-blocks-v1-8-560026cdccb6@samsung.com>
References: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
 <20261008-xfs-nfsd-map-blocks-v1-8-560026cdccb6@samsung.com>
Subject: Re: [PATCH 8/8] nfsd: get all extents of a block layout in one ->map_blocks
 call
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Daejun Park <daejun7.park@samsung.com> wrote:
> @@ -146,42 +124,67 @@ nfsd4_block_proc_layoutget(struct svc_rqst *rqstp, struct inode *inode,
>  		goto out_error;
>  	bl->nr_extents = nr_extents_max;
>  	args->lg_content = bl;
> +	iomaps = kmalloc_array(nr_extents_max, sizeof(*iomaps), GFP_KERNEL);
> +	if (!iomaps)
> +		goto out_error;

nr_extents_max is bounded by PAGE_SIZE so that the per-request buffer
stays small. But a struct iomap is nearly twice the size of an encoded
extent, so this array is nearly twice the layout buffer it sits next
to. On 64 KiB pages that is well over 100 KiB of physically contiguous
memory per LAYOUTGET. A failure here turns into NFS4ERR_DELAY for
every request under fragmentation.

Using kvmalloc_array() would cover the large case, or you could cap
nr_extents_max independently of PAGE_SIZE.


> +	/*
> +	 * Get all extents in one call, so that the filesystem maps them
> +	 * together and they fit.
> +	 */
> +	nr_iomaps = nr_extents_max;
> +	error = sb->s_export_op->block_ops->map_blocks(inode, offset, length,
> +			iomaps, &nr_iomaps, seg->iomode != IOMODE_READ,
> +			&device_generation);

An RW LAYOUTGET with loga_minlength of 0 is refused by
nfsd4_block_iomap_to_extent() on the first unwritten extent, so
currently no write mapping is ever handed out for it. Yet this call
still passes write, so XFS allocates every hole in the range, updates
the inode and forces the log before the result is thrown away. With
one call per request this looks like up to nr_extents_max allocation
transactions instead of one.

Passing write only when loga_minlength is non-zero, and having
nfsd4_block_iomap_to_extent() refuse IOMAP_HOLE for IOMODE_RW the way
it already refuses IOMAP_UNWRITTEN, gives the client the same answer
without allocating anything. Admittedly this is a pre-existing
issue -- perhaps a pre-requisite fix for this series is best, so
that the fix can be backported to LTS.

A note about process: the series touches XFS and exportfs. It will
need to go through the VFS tree, I think, and might conflict with
what's already in nfsd-testing.


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
