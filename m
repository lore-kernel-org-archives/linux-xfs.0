Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236AE39479F;
	Thu, 15 Oct 2026 18:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792090410; cv=none; b=kpUo6a20DNEM0iDAJg4opSgak0u7srXwBmCUF6mbwVAX0CG5RqEvg46w4kVmk4Flj/N9W/o+D0x0FNoWR1hqUY9gQ5qML6/JIlZezGMObBIJ/m4K7/hdjm13AueBGhgAmsH3N4fqvfQ05eS8YSJiFhp0qIOOP/lxBDNPmLhqNFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792090410; c=relaxed/simple;
	bh=aaLfd5XddwbVr6Ef0BErMJ+M5uKzUjV8MS2I9XJDG7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W+mB+arbsWfB15D2z+TZh/GQQpc5sqMaGAQY9XEy1Y5DGvuzHpMpZpQbm3xH14ELzyRELwmbq5BSEpnkM7kbHpEvMuUSdUnBhJdgjdDVMn1kq48YIJCmWQ5JUxl4GXBkYp0+F2GWKjMoGdEmgCREXiTbxfbkiCmcvz6ihKXYVqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=faswZHKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="faswZHKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE231F000C4;
	Thu, 15 Oct 2026 18:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792090407;
	bh=kJJ45xvwFB2s24TIXne2zfVlIkeThqCThofX0WN1WCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=faswZHKE/vGiDYE2zWZKGji2AchSESYRrOjJC/YSgkMl7J2GoNYGuiS2XtVkmf0cA
	 ZaKkazdrdTZCHW6lCy351/iqfqHH7o/cUb3QX4KapgYBSHX70jtBZNfVXPCRooLOCe
	 yMO436fiR54thJP+bgZFsLfUfae/5lvBzqjNcwzY8T3E8eQMcie8mAo1BcSRBAGJK8
	 jd/nntVppE412p3phDZHFjMUuVpDZiX6FI2NCOXxb/RZkE/FQYGvJljQoY3PgoDYuP
	 R7uajNfel+wEusZ/61dlD/URiURLGftyq4v+f4MptOxNUPsqZQyViCvNTxF+3mBH7k
	 wM6MfYEYBEuHQ==
Date: Thu, 15 Oct 2026 18:53:25 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, jaegeuk@kernel.org, axboe@kernel.dk,
	hch@lst.de, djwong@kernel.org, brauner@kernel.org, tytso@mit.edu,
	berto@igalia.com, adilger.kernel@dilger.ca, jack@suse.cz,
	yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH 00/13] block, ext4: allow encryption with a block size
 larger than the page size
Message-ID: <20261015185325.GG2170687@google.com>
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011170958.1759230-1-libaokun@linux.alibaba.com>

On Mon, Oct 12, 2026 at 01:09:45AM +0800, Baokun Li wrote:
> Motivation
> ==========
> 
> ext4 supports a block size larger than the page size (LBS), e.g. a 32k
> block size on a machine with 4k pages [1].  Encryption, however, is
> still refused on such a filesystem: file contents used to be encrypted
> page by page in the fs-layer path, which cannot handle a folio that
> covers several data units, so the checks that refuse encryption with
> such a block size stayed in place.
> 
> Since commit 5acc6f649a68 ("fscrypt: Always use blk-crypto for
> contents on block-based filesystems") file contents are always
> encrypted through blk-crypto.  Inline encryption hardware can already
> en/decrypt a data unit that spans several pages, but the fallback and
> the block layer cannot carry such a data unit:
> 
>   1. blk-crypto-fallback en/decrypts a data unit with the bio_vecs of
>      a single page-clamped segment, so a larger data unit fails with
>      BLK_STS_INVAL;
>   2. the block layer requires every bio_vec of an encrypted bio to be
>      data unit aligned, and splits such a bio without rounding the
>      split size down to the data unit size;
>   3. iomap cuts the direct I/O bios of an encrypted file only at the
>      logical block size of the device, so a bio can end in the middle
>      of a data unit.
> 
> This series adds the missing pieces on all three layers, removes the
> refusals, and enables large folios for encrypted files on the way.
> 
> [1]: https://lore.kernel.org/all/20251121090654.631996-1-libaokun@huaweicloud.com

A high-level question: most of the complexity in this series is to
support crypto_data_unit_size > PAGE_SIZE, despite the actual goal being
to support fs_block_size > PAGE_SIZE.  It's left unstated that the
default of crypto_data_unit_size == fs_block_size is used.  However,
ext4 and f2fs already support crypto_data_unit_size < fs_block_size.

Would leaving the crypto_data_unit_size at e.g. 4 KiB while increasing
fs_block_size be a simpler way to achieve the goal of this series?

Or do you feel that would be incomplete, and you'd indeed like to
support crypto_data_unit_size = fs_block_size > PAGE_SIZE?

- Eric
