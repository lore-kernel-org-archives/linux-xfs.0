Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792706697;
	b=lqOaisgXJM/ozZvcOFkqlo+6tf/HpgfGYW+S1UhSMuhtEKSG710zfMRHsSwq7sc9e31y
	 pRXcO2U9QAJYpIwpwHTrdANsyO/w4+sNNVQ76JJl7p18yzMgrSWDbeTHCUUWTxjYSKQOk
	 NByN8EDshiLJTWJOfYADisqphPSaCNDz6mF5LBV+IsKyjbhJj5uw9ABfv7eu8fgXy7nsE
	 RqICgZiNdi2LFgP0OAIhODlUqj/uk1K0e5849tXCvVm4HtHXt388KmqCBWrAheVXjQsGG
	 R3Q9YUYokk07wsl1b0Y0d7LP0D0WSvSj1/MHdnuASeDMbeobtPhcbh5nuDYL22lMHXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792706697;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=zWkFFrCjzJ7Rb09dks5kAI7WSjnHbFizCZlsjSWaW68=;
	b=a/pvRtB6MNZKpbk7Y6uYTuKWApQUChQplZIqWVrkZru1P1kp9gnrovPgrvnpI01JLCJ1
	 55VmYxJZiarm2cgb+cS69DhCX8L8rj0lJXLQYnEvuKdm2ET4GRL6PquHpNhY7Hkdf41uT
	 7/YJDRAecWyva6+6WVHKHKlYz6vsjC8kk8iILIYykL0HVDouRShJyKxp74hR6G51pTEcs
	 a/y5Uwp30MeSYMZCYdYVvnZZHhr1o29thxXcBzoHC5oGjL1rTuqbOncq8G8f6JsvOFpq9
	 Pj8x5zWCeMOUkMOVVALoDslRkqQiYznf08+6EKs9GdCpPW+5BOm84LdYDbtSYNucM1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rqj0HHoS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1B6606A319;
	Thu, 22 Oct 2026 22:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rqj0HHoS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA6B1F01828;
	Thu, 22 Oct 2026 22:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706696;
	bh=zWkFFrCjzJ7Rb09dks5kAI7WSjnHbFizCZlsjSWaW68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rqj0HHoSEP/g7GIhndcGRvVFz5o/sVqSQu6ndjYgZtxC7DdxRLAsff7z4mliNGYo8
	 lxxktvxYqQbjzXcmMePZy0FR/RnvPzQP+AEgq845EUXq/NDHL7Hx08J7vU5xlV1DZn
	 fTZGKPor23cE7I1I8UsxuHBn0TQMd6belOg203h+APRtvAsOnZWy3hnC0A9or29si4
	 eVbZhYMjJ9nBM4Tmkg1mZilMSXDZ4hWubCMb2jjU0a0FNiaB25gBZCpZBqXNtXKYND
	 M72+GUkvcm5ePJvMEz5/LzEfE4CJ3RW2VN0LgkFR/9JqaGIinAYgR1L+8ChAJ6ucyi
	 z7OXIJYHp7VIA==
Date: Thu, 22 Oct 2026 22:04:54 +0000
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
Message-ID: <20261022220454.GC1383716@google.com>
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
 <20261015185325.GG2170687@google.com>
 <625e5190-d43e-4a2b-9296-da15c52d1a9a@linux.alibaba.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <625e5190-d43e-4a2b-9296-da15c52d1a9a@linux.alibaba.com>

On Fri, Oct 23, 2026 at 12:30:39AM +0800, Baokun Li wrote:
> Hi Eric, Thank you for your feedback!
> On 2026/10/16 02:53, Eric Biggers wrote:
> > On Mon, Oct 12, 2026 at 01:09:45AM +0800, Baokun Li wrote:
> >> Motivation
> >> ==========
> >>
> >> ext4 supports a block size larger than the page size (LBS), e.g. a 32k
> >> block size on a machine with 4k pages [1].  Encryption, however, is
> >> still refused on such a filesystem: file contents used to be encrypted
> >> page by page in the fs-layer path, which cannot handle a folio that
> >> covers several data units, so the checks that refuse encryption with
> >> such a block size stayed in place.
> >>
> >> Since commit 5acc6f649a68 ("fscrypt: Always use blk-crypto for
> >> contents on block-based filesystems") file contents are always
> >> encrypted through blk-crypto.  Inline encryption hardware can already
> >> en/decrypt a data unit that spans several pages, but the fallback and
> >> the block layer cannot carry such a data unit:
> >>
> >>   1. blk-crypto-fallback en/decrypts a data unit with the bio_vecs of
> >>      a single page-clamped segment, so a larger data unit fails with
> >>      BLK_STS_INVAL;
> >>   2. the block layer requires every bio_vec of an encrypted bio to be
> >>      data unit aligned, and splits such a bio without rounding the
> >>      split size down to the data unit size;
> >>   3. iomap cuts the direct I/O bios of an encrypted file only at the
> >>      logical block size of the device, so a bio can end in the middle
> >>      of a data unit.
> >>
> >> This series adds the missing pieces on all three layers, removes the
> >> refusals, and enables large folios for encrypted files on the way.
> >>
> >> [1]: https://lore.kernel.org/all/20251121090654.631996-1-libaokun@huaweicloud.com
> > A high-level question: most of the complexity in this series is to
> > support crypto_data_unit_size > PAGE_SIZE, despite the actual goal being
> > to support fs_block_size > PAGE_SIZE.  It's left unstated that the
> > default of crypto_data_unit_size == fs_block_size is used.  However,
> > ext4 and f2fs already support crypto_data_unit_size < fs_block_size.
> >
> > Would leaving the crypto_data_unit_size at e.g. 4 KiB while increasing
> > fs_block_size be a simpler way to achieve the goal of this series?
> 
> I initially followed the LBS approach of lifting the page-size
> restriction, keeping the existing default crypto_data_unit_size
> equal to fs_block_size. I had not considered using sub-block DUs.
> 
> After your reply, I implemented a variant using min(bs, PS) for
> new default v2 policies, recording a smaller DU explicitly on disk.
> This avoids patches 3-6 and the per-bvec alignment relaxation in
> patch 10, and is indeed much simpler.
> 
> Both variants retain large-folio support and showed similar gains,
> about twice their respective 4K-block controls. Although 32K DUs reduced
> decryption calls eightfold, I did not observe a consistent additional
> throughput benefit, or CPU savings at matched bandwidth, in the tested
> workloads.
> 
> > Or do you feel that would be incomplete, and you'd indeed like to
> > support crypto_data_unit_size = fs_block_size > PAGE_SIZE?
> 
> However, keeping DU = bs has a compatibility advantage for existing
> encrypted filesystems.
> 
> For example, a 64K-block filesystem created with a default v2 policy
> on a 64K-page machine uses 64K DUs. Supporting DU > PAGE_SIZE would
> allow a 4K-page machine to use that format without re-encryption,
> assuming the other policy and backend requirements are met.
> 
> This also covers otherwise-supported legacy v1 policies, which cannot
> encode smaller DUs.
> 
> Explicit 4K v2 DUs can also be portable across page sizes, but
> choosing a smaller DU for new files does not make existing large-DU
> ciphertext readable on a smaller-page machine. I have not yet tested
> the cross-page-size migration.
> 
> If you think supporting DU = bs > PS makes this series too broad,
> I can use the simpler sub-block version in the next revision and
> develop larger-DU support separately.
> 
> Looking forward to hearing your thoughts.

I think I prefer the simpler version for now.  If someone wants to
create encrypted files on a 64K block size filesystem on a 64K PAGE_SIZE
system that are also readable on a 4K PAGE_SIZE system, for now they can
just set crypto_data_unit_size = 4K.  v1 policies were deprecated 7
years ago, so they shouldn't really factor into considerations here.

Note also that setting crypto_data_unit_size too high can break write
atomicity as well as compatibility with inline encryption hardware.

(Also, the more common use case these days is that someone is
*increasing* their page size, not decreasing it.)

I understand there's been a trend to lift limitations like these and
make every size work on every system.  But the large crypto data unit
sizes are difficult to implement correctly, and the proposed
implementation slows down common cases that matter.  Let's focus on
fs_block_size > PAGE_SIZE by itself first.

- Eric
