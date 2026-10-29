Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275763;
	b=Y/h6VXHwytceR1oukMDDvs2iQb55VtdQRmMBCX6dcwCWk6jDP6y09guWFVLtXKHsJsbn
	 oboT0S44QSR+JNjtUqT3aYgjxYSPWkYY22SzicHuvCGzBFsI2gL+8W8IEfN6JxYhyl3dB
	 DIALLYXoKyU2NQEocq0e0TXjdg3DEfobT8Pr9NK+UF/wRdYX6HrT1u9ZX8dgSXQrjuvka
	 cLuHEGKL+8I9wKTXAYzkkgHIdiaq2BsI1SJyh3GEFOvRfQ6npz9vD5XbQMLA9Z5Z9aZDF
	 I428OIwnO8PNVZ1RS7JG6BrMRGGKijwFy8wd521+r6OzD7P/NfRyExuy0Sz7sDRFOxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DFSgas54YOoc8+ppglr4uQd3C9vJI9wX6iAiEpUBPsI=;
	b=hzT+Z8M7hIyiqFu0MKM5bIHIk5U56ffyhb5a+1Ql0R+7gWv1hpoyG40juyYy/OkGI01k
	 GkYqMsYuQOHxxx7gAIXD4tztM/iMWbg0r+bGq9bRCeCyQLfxeohPclqZGrdAaGooFoKFg
	 dcXrmB8jPjqvgRDLXJkmbCClKxljI/abpMowbZew7Rs1h0Yg3AxunvK2r23k5kT2USWmx
	 vcwO3fpnfUrZKNsXvYa8mCoCA8xi8KhEtD9nKoQ0XWyiE08il+YblJVEnPJ9EWJcy6v9/
	 RO8YVoQau4OXxwSCaPucZVwqummuh753FWPhgO04nijvJosek15xRjCs9KFlRdSJuCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LiI55I8C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3DE606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LiI55I8C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3556E1F01825;
	Thu, 29 Oct 2026 12:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275763;
	bh=DFSgas54YOoc8+ppglr4uQd3C9vJI9wX6iAiEpUBPsI=;
	h=From:To:Cc:Subject:Date;
	b=LiI55I8COgipybj7Ok2q7eI/Mz44p9tLitu2EakmL2DeQWOwew9fFVx2SOn9fbfxZ
	 qfJYonS0Qc9zXkjlT/k6EWZrQN2tcqWL4a+6VufCpd9ak0Z/w1C796lnTcUwxCtNtM
	 MokF0SZDwMjCnU5iqDkqHiVZZ21aF0es1b6yAU8439cIxnFBwLpH6UYJNHJkR3KPXe
	 KVQOrC66f8oyTA1mH9RinaAELaRP/WEjQSooGixP1scTZfUVDlzGOdvXP6cEfi/TBW
	 Cuqf5WToL7e9H/dS4Tj0+eh3OEq0+MAyZpqA2KqJadJ46eOvDXqKhGzxzJ1k9G81El
	 2/68sIxGrF3hQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 00/28] xfsprogs: libxfs sync for v7.3
Date: Thu, 29 Oct 2026 13:05:57 +0100
Message-ID: <20261029120631.803074-1-aalbersh@kernel.org>
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

Resending Darrick's libxfs sync for v7.2..v7.3 with comments from hch
addressed.

(not sure if Darrick planned to resend it, I've just pulled it from his
branch)

Christoph Hellwig (2):
  xfs: remove spurious XBF_DONE clearing on readahead validation failure
  xfs: hide b_flags manipulation from code outside of xfs_buf.c

Cihan Karadag (1):
  xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int

Darrick J. Wong (8):
  xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
  xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
  xfs: preserve owner on in-memory btree creation
  xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
  xfs: fix under-reservation of blocks when repairing sf directories
  xfs: don't let hidden_space go negative in xfs_metafile_resv_init
  xfs: fix wild memcpy access when formatting ondisk rtrefcount btree
    roots
  xfs: fix exchange-range-to-eof file size exchange

Hemanth Selam (1):
  xfs: fix typos and repeated words in comments

Hongling Zeng (1):
  xfs: validate attr entry pointer before field access

Javier Tia (6):
  xfs: initialise error in xfs_defer_finish_one()
  xfs: give the deferred barrier op type a name
  xfs: report the error that made deferred work shut down the fs
  xfs: correct the parent pointer space reservation comment
  xfs: initialise args->total for parent pointer updates
  xfs: assert the reservation covers each da fork growth

Jiangshan Yi (1):
  xfs: remove duplicate INO1_WRITTEN check

Johannes Thumshirn (4):
  xfs: add xfs_metadir_create_file helper
  xfs: create quota metadir inodes using xfs_metadir_create_file
  xfs: create rtgroup metadir inodes using xfs_metadir_create_file
  xfs: mark internal metadir file creation helpers static

Kees Cook (1):
  treewide: refresh kmalloc_obj() conversions

Lin Jiapeng (1):
  xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Norbert Szetei (1):
  xfs: stop exchanging reflink flags when exchanging mappings

Yun Zhou (1):
  xfs: don't hold buffer locks across sync transaction commit in
    xfs_sync_sb_buf

 include/kmem.h                | 14 ++++++
 libxfs/stubs/xfs_mount.h      |  4 ++
 libxfs/xfs_ag.h               |  2 +-
 libxfs/xfs_alloc.c            |  4 +-
 libxfs/xfs_attr_leaf.c        | 16 +++++-
 libxfs/xfs_btree_mem.c        |  2 +
 libxfs/xfs_btree_staging.c    | 11 ++--
 libxfs/xfs_da_btree.c         | 10 ++--
 libxfs/xfs_da_btree.h         |  2 +
 libxfs/xfs_defer.c            | 18 ++++++-
 libxfs/xfs_dquot_buf.c        | 47 ++++++-----------
 libxfs/xfs_errortag.h         |  2 +-
 libxfs/xfs_exchmaps.c         | 95 ++++++-----------------------------
 libxfs/xfs_format.h           |  2 +-
 libxfs/xfs_ialloc.c           |  2 +-
 libxfs/xfs_inode_buf.c        | 17 ++++---
 libxfs/xfs_log_format.h       |  4 +-
 libxfs/xfs_metadir.c          | 84 ++++++++++++++++++-------------
 libxfs/xfs_metadir.h          |  8 +--
 libxfs/xfs_metafile.c         |  8 +--
 libxfs/xfs_parent.c           | 12 ++++-
 libxfs/xfs_platform.h         |  5 ++
 libxfs/xfs_rtgroup.c          | 58 ++++++++++-----------
 libxfs/xfs_rtgroup.h          |  6 ++-
 libxfs/xfs_rtrefcount_btree.c | 11 ++--
 libxfs/xfs_rtrmap_btree.c     |  6 ++-
 libxfs/xfs_sb.c               | 37 +++++++-------
 libxfs/xfs_trans_space.c      | 19 ++++++-
 28 files changed, 259 insertions(+), 247 deletions(-)

-- 
2.54.0

