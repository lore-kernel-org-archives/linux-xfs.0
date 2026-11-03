Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716754;
	b=KldHjGZiSycd0/e96Ht/CXnfHJsfJa/SIeWk2kwSAcc6faxBac+GTfateA8z5I37dYH3
	 PrgOvBPqlISBvLQcGOqxGaemFw0Boh9W5h35NwSoYF8qaRILXtKWej115FVi3R0N9umlA
	 kQtIXuqLB9lh2oocTGeMMwqORqInL9UpfSsbP6o51P1mMUshSQxgUNhBk9ZCntf1rbKNT
	 ADozcID6CKEksh8How5NI66XDLfHlYTcbdXqS4Ho5Doj5rmvTM6zAHXBBHaLWpP6UlcmI
	 I3IGvq41Nj1OHaGEqVx6bAtBDqa5ZKLR7lpM/i0YKfCgwdONvRCsP77WIpaRmWXvjxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716754;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=fSDQsLHVFNp8QSO5EhdEXpCZA5SuRCXE+w6vKKtRHZ0=;
	b=OtkEK8OPjKekce+T1tG/e+73mh6lNNqDa98Z8MeTyWO6bkUFaWzuLttQq10Fq7UwW/55
	 WhTzrJ4Nrs1io2rB5bt1Mu4PQnD5N++QcylRMJS/fUdiUlghvusfB+uVtPJDhdi81aHO8
	 mWZrWcBOOnFLDL5cZsGiT5vZg+Kzh+e38F5MuUjdDStfVvnhQ00BErS3ukfzC23tD9W3H
	 wmfsFxkJx4HWqAXawSXrkelS6jdWRg9/hHSc2qSv6MHWm6aAraXxo8bep742ynOx8RJqe
	 hnCB3ABXRFkmC/DF3HZhgzp3bd9J0egXhl4jBJnK19Pf7/H0NktZUCTOxLVVAb8vXPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=U1BXV5Wk;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8A1606A324;
	Tue,  3 Nov 2026 14:39:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A8A1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=U1BXV5Wk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fSDQsLHVFNp8QSO5EhdEXpCZA5SuRCXE+w6vKKtRHZ0=; b=U1BXV5WkfIOnXNYRQr2VzR7di6
	Mwabj5oPT5vUntTB+BA4Q4FUmDjoLHCId3qWzs72L9lz4ZbQe61CjX0pAQAdUJPBfBN2pdoVWpZQi
	aCKICSCI1RzhTVyChAVBzkP7Vxm53yF6f3OGtS9D4N9ycyR2JhqKAZPT9rAhY9HxF49yrk546EV0c
	vuBCCpDAuDcojzp+2sO8zkF94dXiUkSKnhxxbRX0SSvPgwWeuGB1PgixB4Om1YI/gbTo+qlh+c6Gk
	6U8znhO4Q5zdYtd5fue5Cpopgd/4xKfXognslJSi8xUvLXznjKZrzn9Fsgr/D4vB8lhZe2tI56J/o
	X29s5AXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOFfM-00000002jvm-42ZR;
	Tue, 03 Nov 2026 14:39:12 +0000
Date: Tue, 3 Nov 2026 06:39:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, ebiggers@kernel.org, hch@lst.de,
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 07/15] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <aunyEHubncj93edp@infradead.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-8-aalbersh@kernel.org>
 <aumsPwTUaMgsccSb@infradead.org>
 <aunvf0_84c4K3s8b@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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
In-Reply-To: <aunvf0_84c4K3s8b@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 03, 2026 at 03:31:15PM +0100, Andrey Albershteyn wrote:
> On 2026-11-03 01:41:19, Christoph Hellwig wrote:
> > On Mon, Nov 02, 2026 at 03:41:37PM +0100, Andrey Albershteyn wrote:
> > > The __xfs_bunmapi() is used to remove all extents past EOF. Add
> > > XFS_BMAPI_UNWRITTEN to remove only unwritten extents, while leaving
> > > written ones in place. This will be used in following patch to clean up
> > > unwritten extents on fsverity inodes.
> > 
> > As discussed before, we either need to fix the Sashiko complains (which
> > could get really annoying), or disallow fsverity on RT files with
> > rt extent size > 1.  And probably also add a soft assert about this
> > to __xfs_bunmapi itself to make the limitations clear.
> > 
> > Otherwise this looks good.
> > 
> 
> Yes, I added the check in "[PATCH v18 09/15] xfs: add fs-verity
> support" [1] in xfs_fsverity_begin_enable()
> 
> +	/*
> +	 * fs-verity stores the Merkle tree past EOF in units of the filesystem
> +	 * block size, so it cannot support realtime files whose allocation unit
> +	 * (extent size) is larger than the block size.
> +	 */
> +	if (xfs_inode_has_bigrtalloc(ip))

Please also add a similar check/comment in __xfs_bunampi for the
XFS_BMAPI_UNWRITTEN case as a safeguard and documentation of the
limitations.

