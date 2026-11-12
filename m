Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519968;
	b=0YkWZClwChg0uo7wpUVLBPFXKQ+aGj+ItXfCG9wuW1ifXHfwQTRQPcUflWV6r+mLd7m0
	 J67ZZ7ATJ6qcQ/MKRd4rk9Y2fEk+/TKhqeNbm+qqzyzXsyMKyWczLrQkkh4jC/W61SqNc
	 rEajQY3OeOZGtfeewdA/JNbRs85/qY8OfoaBrC0ed6IiIVd+Ca7njFv+HcbhRrd556wMf
	 h+DOzaN++fgop06QGraSJCXG77wFEjM4vRB9dr8ueYzTZZl/O5IlCNbIvmL0vUT/Vjman
	 907krWexPFMhtSqsvY5asbs4ObPzKl2fxpAytGQzCtRIaLxnwj2UmuV1gWkWWJ0IJhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519968;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=/5fzotXqq499saxRwEWB8o+Vbe9djwNEj7vMrrb2wmc=;
	b=hjedfwoVuhx2T6Vv+js0QhWcyq8j/0cyIy1Juw5ClAHOCHZ5Gq8WYW3Gs7ZSDmVkMS0+
	 sWbiJH/HIUhtvst1POmSI/c0FYHKytJe6uFvKyhx2M5NwX2h0ZqpY4CkZAHo7DIOUULjT
	 AGUXghpoxXAeGqG3wNI5fO1uncNEWSapW2QmvOfz4d7CoDjFZ8jVFGbGeNDjxiOM/U5Fk
	 5Er6tqZioNfPZo8VjCZusSlLj3kbC5KLMSj4UCUiFBOK29aa6NSCIMB1kDXAvFEYACanF
	 dR8EgQKvJSvolmuE7S0CrjxfJIHwCDi9p0OwL25fU3iF1JphqwAv61k1d6arqRaN6lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MEKOqyKG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4129606A31C;
	Thu, 12 Nov 2026 21:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MEKOqyKG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F801F000C4;
	Thu, 12 Nov 2026 21:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519967;
	bh=/5fzotXqq499saxRwEWB8o+Vbe9djwNEj7vMrrb2wmc=;
	h=From:To:Subject:Date;
	b=MEKOqyKG3xHDw8Zb+f8YBCK0gysMLxLSUPoS4gq7UK+8wNuu26CFFVHn0smbpRJqh
	 F7+ujDX8Nl1prwFO/FBuZKS1LGSWmf96bl3Iyn6XNIiYgRcT4DtYhb7iOwQSU/g+Ng
	 j/mM+pxkxK8/AAZwvIbAZ31wKTwzn9njJeQi0+uoB2lwXoVN8VHWTV/hurHLAYTK7Y
	 gmGQT2taq7HWH4bS40tBO9vWDQJ+xslH+UNakRJzBQqAl0STREtEVyB3XNZBFF7lnr
	 5ZwBvopaKYmO+TOr07k1Cw3FOeIMTQV/FkrvxcVPw/15me+ni7hsq45bRaFqMSP+Hs
	 hydGklKCuRUwg==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v9 00/14] reflink and atomic write bugs
Date: Thu, 12 Nov 2026 16:46:04 -0500
Message-ID: <20261112214604.67875-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The meat of the series is fixing reflink corner cases that incorrectly
let you write into the source of a reflink.  LLMs also tripped over a
few ways to use atomic writes to expose stale blocks on the drive, and a
few races with realtime flag and extent size hint manipulations.

Carlos has accepted patches 1-4, but I've kept them here so the whole
series can still be tested.

Except for Christoph's patch, these were all found and fixed
by an LLM.

v8->v9:

Christoph suggested taking the MMAPLOCK in xfs_fileattr_set() instead of
chasing flag and hint changes down in the iomap code.  Page faults only
hold the MMAPLOCK, so FS_IOC_FSSETXATTR now waits for them.  That's the
new "xfs: take the MMAPLOCK in xfs_fileattr_set()".

It replaces the two "resample" patches.  It also replaces "xfs: test for
an extsize hint again under the ILOCK". With the new lock the hint can't
change between its two tests.

"xfs: restart faults racing with realtime flag changes" is down to one
test in __xfs_write_fault(), because zoned space is still reserved
before the lock.  xfs_iomap.c is back to what's in 7.4-rc2, so the
-EAGAIN and the -EINVAL are both gone.

One more existing pnfs bug fell out, LAYOUTGET can race with a clone and
hand shared blocks to the client for writing.  The new "xfs: test for
realtime and reflink under the pNFS locks" deals with that.  That one is
from reading the code, and I haven't set up a pNFS server to test it.

Christoph also pointed out that DAX doesn't require writing in place,
the zoned code just doesn't support it.  "xfs: don't enable DAX on zoned
inodes" has the same code with a new commit log and comments.

v7->v8:

Christoph pointed out that only page faults can cope with the -EAGAIN
from "xfs: restart faults racing with realtime flag changes".  pNFS is
the one other caller that can really get there, so now faults get
-EAGAIN and everyone else gets -EINVAL.

Sashiko had two complaints about the same patch.  The stale reservation
is fixed by the two "resample" patches.  Those are the rest of the 3
additional patches I promised in v7, I just managed to leave them out of
the posting.

The second complaint turned out to be on disk corruption for realtime
filesystems with extents bigger than one block, with nothing returning
an error.  That's the new "xfs: test for an extsize hint again under the
ILOCK".

While checking what a DAX fault does with the -EAGAIN, we found that DAX
and zoned inodes don't work together at all.  With a zoned filesystem on
pmem and dax=always, the first store into a mapped file oopses on
7.4-rc2, and so does ftruncate().  "xfs: don't enable DAX on zoned
inodes" turns DAX off for zoned inodes.

Added Christoph's review to "xfs: test for always COW after the dio
write checks".

v6->v7:

Sashiko noticed a few pre-existing corners that I had ignored, so we
have 3 additional patches dealing with races between FS_IOC_FSSETXATTR
and decisions about file writes.

"xfs: restart faults racing with realtime flag changes" changed enough
that I dropped Christoph's review.

Chris Mason (13):
  xfs: don't skip the flush before shifting extents
  xfs: flush the shifted range before changing the file
  xfs: don't change the block map under a dirty folio
  iomap: don't punch delalloc under a dirty EOF block
  fs: validate atomic writes after O_APPEND and limits
  xfs: recheck direct write alignment after write checks
  xfs: test for reflink after the dio write checks
  xfs: test for always COW after the dio write checks
  xfs: refuse fallocate racing with realtime flag changes
  xfs: take the MMAPLOCK in xfs_fileattr_set()
  xfs: restart faults racing with realtime flag changes
  xfs: don't enable DAX on zoned inodes
  xfs: test for realtime and reflink under the pNFS locks

Christoph Hellwig (1):
  xfs: refuse writes to files racing with realtime inode flag changes

 fs/ext4/file.c         |   4 -
 fs/iomap/buffered-io.c |  34 +++++++-
 fs/read_write.c        |  13 +++
 fs/xfs/xfs_bmap_util.c |  19 ++++-
 fs/xfs/xfs_file.c      | 182 ++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_inode.c     |   3 +-
 fs/xfs/xfs_ioctl.c     |  25 ++++--
 fs/xfs/xfs_iops.c      |   4 +
 fs/xfs/xfs_pnfs.c      |  32 ++++----
 fs/xfs/xfs_reflink.c   |   2 +-
 10 files changed, 248 insertions(+), 70 deletions(-)

