Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792591849;
	b=iJjr7RBc9oKS/vFC7uMcwuwFgG/zULIi6O7dgmlbVi342HebWaIcXH7sJBBx552sMLCH
	 cxcjpQEp8rNwe3tEd1rupa3PC2OBjT2ggunXe0ZlXL50C+stG9hs7jxrfY1IZ1IRN8wk5
	 b4nGmQWL2E8uHocXskBtjTxthpNzOlwd3FI03KYFWAQ8AomwPLR+ozIpPiNkYEPwdDTqw
	 7Prtfy6T33pn78ukzowTk7mKh/Kd1lp99akAehSl84kFdhuGwMFJJ00evGhMvNp++e7e0
	 1rzP+/if5/PszgHXB1ZmIHdQ0QRbwRQKcxTWCX2aJuQkMw9nF7OE9e0+1gogvOojIlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792591849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cv6/eLa7YeLcn9KqPFfdkN+ZTh1nEyFi4NtZegl2CME=;
	b=dIRh5g3S5sXDcIIBcVnG99S47ph4g8FkC6KKfya+yhQuOq/FdppZwOQtlOUfiy8zfk++
	 oPZ5BQeO40IatFjrMU6oPlfPgvaTnba7oSMxbDDQGKnlZHIU8xFQ0jNAmEKHmBo/3ABT3
	 FjQWHk5x4Dp4X4Cq6ZbEbM5QJLiIXShoePbPe9DGIVsu1bJ6bMz1V4FwZ95/OuH0NnkuA
	 4Gjdl1uWzkLj8B2vJbKt/eor1f3yGYr5dd/bv6Hr1vyh3zSA7lTMrDghyBmA6fyh+2ixX
	 WsHWJNJVny0dGt8KYooEMamRoAO7i32lvhLgm/WSjVrDYzARoFYMtN2Kr6Wf6URD7Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dNDAVZrt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE1F606A31A;
	Wed, 21 Oct 2026 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dNDAVZrt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAEB1F000C4;
	Wed, 21 Oct 2026 14:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792591848;
	bh=Cv6/eLa7YeLcn9KqPFfdkN+ZTh1nEyFi4NtZegl2CME=;
	h=From:To:Cc:Subject:Date;
	b=dNDAVZrtWJ0XfeqLABWUwvYv5H8i/0Lbmv6x4QOIpAF7o+8cVyGX1Y6z5nCgJnBUO
	 hxnNKvralu4sGjGMtViQBk05IZYitJ1JAHQWcCF2fS48sfC/OzlRM3f20qaIzsbgMG
	 o+ycxZdfsKQ5hj3cBz6NkWb9+LH0ndS5iV5y9tptuhKaBGt0vTnvrqKFi1YCgwN4D6
	 XPAibIDKA1P7ZWGZJyB2qX6bl4bmzRO+hkNGMTOsIaoKFASotyNmKzjSc2ktVFvgQt
	 VNQ2eYRYgbcGkgxa72lSLFZzMpGX95CnBIRfRo7tiwVqPVPJPnSEqM5qdZS2u1Cv3e
	 QowvMnFPDAF0Q==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-api@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 0/2] Introduce man pages for file_getattr() and file_setattr()
Date: Wed, 21 Oct 2026 16:10:03 +0200
Message-ID: <20261021141010.314835-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This series introduce 2 man pages for file_getattr() and file_setattr()
syscalls.

Changes from v5:
- rebase to 6.20 and dropped "struct file_attr" patch (merged)
- change description of dirfd & path args to reference openat(2)
Changes from v4:
- Split single patch into 3 separate ones
- Mark examples for linters
- Use special char for empty lines in examples
- Use w64/w32 in printf() in examples
- Use const fattr in file_setattr() definition
- Other minor fixes
- A few fixes found by lint in examples

Changes from v3:
- dropped VERSIONS section in file_attr.2type
- reference arguments and errors from file_setattr to file_getattr
- Minor wording fixes
- Minor formatting fixes
- Removed zero-initialized requirement
- Interdiff with v3 below

Changes from v2:
- a few grammar fixes
- styling fixes
- sashiko.dev fixes (wrong AT_FDCWD combined with AT_EMPTY_PATH
  description, unused "dfd")
- dropped requirement to zero fattr before using file_setattr()
- Pathname -> path
- Dropped description of why FS_IOC_ aren't usable with special files
- Fixed backslashes in the code examples

Andrey Albershteyn (2):
  man/man2: introduce man page for file_getattr(2) syscall
  man/man2: introduce man page for file_setattr(2) syscall

 man/man2/file_getattr.2 | 252 ++++++++++++++++++++++++++++++++++++++++
 man/man2/file_setattr.2 | 183 +++++++++++++++++++++++++++++
 2 files changed, 435 insertions(+)
 create mode 100644 man/man2/file_getattr.2
 create mode 100644 man/man2/file_setattr.2

Range-diff against v5:
1:  bfff306908cf ! 1:  c7df8a930c70 man/man2: introduce man page for file_getattr(2) syscall
    @@ man/man2/file_getattr.2 (new)
     +of the file
     +specified by path.
     +.P
    -+As with
    ++The
    ++.I dirfd
    ++and
    ++.I path
    ++arguments behave in the same way as in
     +.BR openat (2),
    -+if
    ++with the difference that
     +.I path
    -+is relative,
    -+then it is interpreted relative to the directory
    -+referred to by the file descriptor
    -+.IR dirfd .
    -+The special
    -+.I dirfd
    -+value
    -+.B AT_FDCWD
    -+can be used to refer to the current working directory of the calling process.
    -+If
    -+.I path
    -+is absolute,
    -+then
    -+.I dirfd
    -+is ignored.
    ++can be NULL meaning an empty string.
     +.P
     +The
     +.I fattr
2:  d81d763c4223 = 2:  9c7fbaab27e5 man/man2: introduce man page for file_setattr(2) syscall
-- 
2.56.0

