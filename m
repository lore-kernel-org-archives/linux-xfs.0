Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794513903;
	b=21n55ut/jhT6kMLwPaClZhXXafqN+oINBdSv4oKUnDwvitYY4VgtVxUu/xrYYLkxCfhA
	 /Atam2GuVFvEdrK12fs7Jsbx5FgK0hft0V4jO3C5hB9n89VE1fb7/bS41kQn5uCG03kwD
	 9jDellcS1i+MQCKHmULfDvYrht+V6RJnBijDBdjXIoxK2WZw6GTT6+ftkxB6tPyxpxUze
	 h6vNvyEpwyLrGQX7DedFzi7ZJWyo3XW+GENv7aiAweclNuKC6snwjrjpjvJCFWbI9VyAX
	 OfKhuyhML4LIb0hcObqzCzZlH6vsbJPKyZay8tAYFQmSVtd1l7EFO7vsKXAoNJWaWZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794513903;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=e/9XtLf1/seQXU14efIT7GgTlHiVF3SyFuteO0A0dz0=;
	b=vgp/07P5gh2LBLRQQobNv7f+L1yRJ7hWYMcYqIKyHtnIIHL8ZK8sArnjVzu9a32ALeKv
	 U3TfXzD9BOGFb65gXlawbTXGw6X6APbURKFB7gI0+N5HIqC9Y+Tkx8k7FZ4u9Nl+W39Sg
	 5j4Lj4kUR5hlb3WEwAnt0ada9+lmTb1MkUWIT61dcD8FHNFMoXxJHy1kc0CYUXiWiUxJq
	 QTYfPNeTfh6rCD6m0LAc2ooW1fPauy1Ry4/DpsOC6Rvajds0l2GHEUIydP/ODN9qU25Ql
	 PMIvxWV97d3xgWelBOGAK0+x3WgUzUNIuHiV6g9JxBKUJZlnB4OhXH440TdJfgF1CJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=I1gI4Rv2;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781C5606A31C;
	Thu, 12 Nov 2026 20:05:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 781C5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=I1gI4Rv2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=e/9XtLf1/seQXU14efIT7GgTlHiVF3SyFuteO0A0dz0=; b=I1gI4Rv2t0pTMfIbgIjF02KAls
	z76OX311HlbjXRlaZ3NmPqo05dsjHrMmP2IpEX9WBDtCya+x1EGyaIjc6HQZoyCod3RLVduOBaV/E
	Pc623NWuxVKTmke0i2QRTeLBjxujw8Dfvnt4PF3CEaM4Sezlc2AWtW3/+rg4hhGCBi0/E4iCF+Hfo
	Bakb/jf3lT6AheUFRpMhyGi4Xo86wSdvaiJBqZfN4AbTNbFnFAMuyPVQTIQBm+KA4ygM1LBpHJkDl
	2eIR1zItGCETAR2aIb2NwGZFp6+ynskaS/dyEYtthU2z9kOuTVuw3gTMJV0SFvyWcePLPq+bXvjnc
	kPCKo8fQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRb2a-0000000AzZ2-3ibC;
	Thu, 12 Nov 2026 20:05:00 +0000
Date: Thu, 12 Nov 2026 12:05:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lauri Gates <lauri.gates@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
Message-ID: <avYb7D3bCmnw0Mbw@infradead.org>
References: <au3wJNbRPXQZG5Op@infradead.org>
 <20261106204026.14530-1-lauri.gates@gmail.com>
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
In-Reply-To: <20261106204026.14530-1-lauri.gates@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 06, 2026 at 10:40:26PM +0200, Lauri Gates wrote:
> The other is that for a "may share" bit, clear is the unsafe answer,
> so a filesystem that cannot answer should not look like one that
> answers "not shared". As I understand it, stx_attributes_mask makes
> that distinction, while struct file_attr has no validity mask today
> (it is size-versioned, so one could be added), so through
> file_getattr() btrfs would currently read as never shared. A spare
> bit in stx_attributes adds no field to struct statx, which I hope
> meets the concern Christian raised about spending statx space on the
> case-folding RFC [2]. If fileattr is preferred, the bit could instead
> mean "no shared extents", so that clear is the safe default, as it is
> for FS_XFLAG_CASEFOLD.

statx sounds good to me, but I'd really like to hear from Christian.

> 
> > Besides xfs, btrfs and ocfs2 also support reflinks, and nfs (and maybe
> > cifs?) can export the semanics remotely.  So we really need a way
> > to indicate if the file system could support reflinks to start with,
> > and then one that the file could, so we probably need two bits
> 
> For du, I think the mask could stand in for the "could support
> reflinks" bit if it means "this filesystem can answer for this file":
> 
>   mask clear            not reported, fall back to FIEMAP
>   mask set, bit clear   no shared extents
>   mask set, bit set     may have shared extents
> 
> A filesystem that cannot share extents at all would set the mask and
> leave the bit clear.

Sounds good.

>  - nfs, cifs: I could not find a per-file attribute in NFSv4.2 or
>    MS-FSCC that could carry it (space_freed comes closest, and nfsd
>    does not implement it), so no mask bit there.

There's definitively nothing in NFS, speaking as the person who added
the clone support.  If your new Linux syscall API becomes widely useful,
we could add the equivalent to NFS in a new draft.

> A filesystem-level "could reflink" bit might be a separate need:
> nfsd encodes clone_blksize for every export and ksmbd advertises
> FILE_SUPPORTS_BLOCK_REFCOUNTING unconditionally, I assume because
> neither can ask the exported filesystem. Did you have nfsd and ksmbd
> in mind for that bit?

I just mean we need some way to discover it.  I think the three states
in statx should cover everything.

> On reliability, my tentative answer is that the bit does not need to
> be exact for this use. A clear bit must never be wrong,

Yes.

> Stale bits do limit what it saves, though. The flag stays set when
> the other copy is deleted or the file is overwritten; only truncation
> to zero and FALLOC_FL_UNSHARE_RANGE (see the caveat below) clear it.

Yes.

> Would there be a reasonable point for XFS to clear the flag once
> sharing ends? I don't know the code well enough to tell what that
> would cost.

It is hard to know that nothing is shared, because nothing in the
inode tracks the shared space, except for XFS_DIFLAG2_REFLINK only
the reflink btree shared if anyting is reflinked.   To efficiently
clear the bit in an exact way we'd need to track the number of
blocks or extents that are shared in the inode, which would be
an on-disk format change.  But if you run xfs_scrub with online
repair enable, the online repair can fix the value up as background
operation, which should be useful once that feature has matured a
bit and users enable it by default.

> 
> The caveat, which may be unintended or may be my misreading:
> FALLOC_FL_UNSHARE_RANGE over a whole shared file does not clear the
> flag on the first call. bpftrace on 7.2 shows
> xfs_reflink_clear_inode_flag() entered and
> xfs_reflink_inode_has_shared_extents() not, so it looks like
> xfs_can_free_cowblocks() returned false, perhaps on I_DIRTY_PAGES
> left by the unshare. A second call after sync clears the flag.

Interesting.  Maybe we need a sync before calling
xfs_reflink_inode_has_shared_extents?

> If the statx direction sounds reasonable, I would be glad to put
> together an RFC with the uapi bit, xfs and ocfs2 support, a man-pages
> patch and an xfstest. This would be my first kernel patch, so
> corrections on any of the above are very welcome.

Happy to help reviewing this if you take on a word.  Just as a warning
I'm a bit overloaded currently, so some replies might take longer than
I'd want.

