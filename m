Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716280;
	b=SryalPIpfH7vdWLm0z+iahgLPa2IQVib4gH2VERmOOoSWuki9T2k8hkoFG34O+1C/8y4
	 bXt/KkngayA1izv6/GAefUVz+My/1CePU08kbmTB6XeVagdqJFRLl6OjiNRIYML4s4fIO
	 sN2ffADw1F6R8bS7BWn3fOOnuKycTyl/tJtq4yYinvNW4gfKBrA0nDrzS50bIkcVwMEDT
	 eGpSR+9CMpV4FVNgSGJjmFWwW/RgkrZXQ8xn5GZRcgL0DVbyjYTUTcvMFSD3W/jLc1XKE
	 SxDVQr4uODnkwqxCVSGVa4eHJvSkB6IeWjIlluUGjM0tKSvSCbiaIITm9aQ8WlzYYSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716280;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3UeWveWGeakrU8+V/v3FLgdqqTFKhZIga4Ey5mDJP2o=;
	b=FTjGX7oY+wsDAx0aIvNgCy+GLOWP8XvCyztSNiBj1En3cgIrb/cDVEtWcfK9Y+O7JNsb
	 CrKf+XGMH2jRDGVYsXfInStfLHVwP6wOSjJCoYiElp0RjmQLhLRuY/tttK09G5ngmznxT
	 vONHJY5ydvts+8VUdN4CD8wYOjp7qIP0rvVf9XMHyCyUj6ANcbBXwxCkDyEmR7k8ql9ji
	 lu4rGXfDB6gd182RWhfTPA0BW3IAVffBUsoMX6hopJIg/Ql/vG5bMbwbP/7qYOV6QdAu5
	 TIXCHN1xT75vTip8FEpoBFP/a2NJSf7mGubQSii62NnxIIGmCKOXia0GWXxLUkDocPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaTKmfir;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC42606D818;
	Tue,  3 Nov 2026 14:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaTKmfir
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E53D1F00A17;
	Tue,  3 Nov 2026 14:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793716279;
	bh=3UeWveWGeakrU8+V/v3FLgdqqTFKhZIga4Ey5mDJP2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EaTKmfirvx82zMrfDI5Q3O9Tff1UgW8RMbOnjHWQX2SHpBv8fKHOcklhK4/hJqZbF
	 1Kf8On1e11aN6CE8lJpmaM2iUCh8TnME1LcEhOrROE4FsiJaHL9F3fPjgNHOmEBokW
	 5Mq7E/zIqW22wNuhDYYfcivIO4bjzZGhuRD2sFeP+UW0FjMQ2rYAwXgdh3aPWRAHVq
	 OpG0vVfCTRGhaT6APlAhz6y8E+/qqqnjFdDsMTQirVQ6SMhNfknBFE7cvXWDc3tW7t
	 B5omm1nSWVnMKA4Bv0QdlVPJBKOsSScJgJoUehwazdjWbmZdjXml/+Yc3EWmh7pQ5H
	 5rvCYz89rQOPA==
Date: Tue, 3 Nov 2026 15:31:15 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	david@fromorbit.com, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 07/15] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <aunvf0_84c4K3s8b@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-8-aalbersh@kernel.org>
 <aumsPwTUaMgsccSb@infradead.org>
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
In-Reply-To: <aumsPwTUaMgsccSb@infradead.org>

On 2026-11-03 01:41:19, Christoph Hellwig wrote:
> On Mon, Nov 02, 2026 at 03:41:37PM +0100, Andrey Albershteyn wrote:
> > The __xfs_bunmapi() is used to remove all extents past EOF. Add
> > XFS_BMAPI_UNWRITTEN to remove only unwritten extents, while leaving
> > written ones in place. This will be used in following patch to clean up
> > unwritten extents on fsverity inodes.
> 
> As discussed before, we either need to fix the Sashiko complains (which
> could get really annoying), or disallow fsverity on RT files with
> rt extent size > 1.  And probably also add a soft assert about this
> to __xfs_bunmapi itself to make the limitations clear.
> 
> Otherwise this looks good.
> 

Yes, I added the check in "[PATCH v18 09/15] xfs: add fs-verity
support" [1] in xfs_fsverity_begin_enable()

+	/*
+	 * fs-verity stores the Merkle tree past EOF in units of the filesystem
+	 * block size, so it cannot support realtime files whose allocation unit
+	 * (extent size) is larger than the block size.
+	 */
+	if (xfs_inode_has_bigrtalloc(ip))
+		return -EINVAL;

1: https://lore.kernel.org/linux-xfs/20261102144147.2393369-10-aalbersh@kernel.org/

-- 
- Andrey
