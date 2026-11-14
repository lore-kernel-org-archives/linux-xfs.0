Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622646;
	b=OG53jzqQ3f9OPJ2c2tR5XejNnQ0BLSWaI6GcV+IEIrq6h0EuXsm7OhyhEeGnTlhrOVeh
	 3pdI5/KmBbf853tu7cWmRk67RoPU1cytgJGEb+Y8lhmYkgOTh8JXPllb9/fd/yeQv+Gbs
	 yOQbFgJnwEuA5jLduvwVVDee+rU0MMV2qKT/dj6+h90ogLrfLNvPyUdSaYmgD6TPInLgt
	 6iN4VUj6WlDkPw7UUSbBjyH1cHbWlEm8R7k8OESWAd6ifU05keeydydP41dfiZgVylgNu
	 da6CEcs32U9Aixut2/e3UtTepezy3oeVFxhqlSF0jekB3fIDLjZG3XmYxyHQxL0rVNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622646;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Subject:To:CC:
	 References:From:Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=lamjSy1jct+Y32LWUG/7mqOA0l+lzlvT/xdWWaLZFKQ=;
	b=N2bc503U/mCw2zrPZsKSPq3WYDTgWGDpRhDOTuWt7pSGYpbLNBUylCXXnJi0m29yAEUJ
	 uUEjGURasXuJRFllIuEWl6/guO6JdaPUeZal9g2BJP4f9A//zSy0Fdd0oB1bO3JK0sqZu
	 B5P32BOFhY+y219dLdOCr84Eilm+kPRn44Td1y9OkLhXkWmxoqiZ/DGxPbRKzJ/eQuX3F
	 yBbLDO10hzrQvRYOFoujp4Fm/gCay+i7aOAa1NxqMWpyAADSwAn2TNpIsO7qSUpHKaXV1
	 B0EpOYLKKqkfnRZ8egqK0tbZSR5GyFQ+Y0hRgRbQyfJzgMYf/0NT1g09+PTjtOAvtxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=dmJo6jxo;
	arc=none smtp.remote-ip=113.46.200.225
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3843A606A327;
	Sat, 14 Nov 2026 02:17:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3843A606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=dmJo6jxo
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lamjSy1jct+Y32LWUG/7mqOA0l+lzlvT/xdWWaLZFKQ=;
	b=dmJo6jxorxqj/soF5hgiJAk0L/VbZ+b6NQ150G77AKdiKykroxkSgy9jha28sMjYHaadv7xU4
	gX5qGcCNkavMkbqMIDp0Pr2diskt5hVLJa0+T41ntlJJoc8GUBBS7KeBABGtvyISA72TUzk8pOV
	JKQ3g1KA+Ky1blIGX4Su+70=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jRHnX4bKrz1K98l;
	Sat, 14 Nov 2026 10:17:04 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F8174048B;
	Sat, 14 Nov 2026 10:17:15 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 14 Nov 2026 10:17:13 +0800
Subject: Re: [PATCH v3 30/33] ubifs: don't set SB_RDONLY after errors
To: Christian Brauner <brauner@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, <ecryptfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <jfs-discussion@lists.sourceforge.net>,
	<linux-nilfs@vger.kernel.org>, <exfat@lists.linux.dev>, <linux-mm@kvack.org>,
	<ntfs@lists.linux.dev>, <ocfs2-devel@lists.linux.dev>,
	<linux-btrfs@vger.kernel.org>, <gfs2@lists.linux.dev>,
	<linux-efi@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
	<linux-xfs@vger.kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-30-0be92bb73709@kernel.org>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <17287026-cccc-f56c-15a3-029b9a2c38c9@huawei.com>
Date: Sat, 14 Nov 2026 10:17:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-30-0be92bb73709@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemo200011.china.huawei.com (7.152.185.179)

ÔÚ 2026/11/13 19:59, Christian Brauner Ð´µÀ:
> ubifs_ro_mode() sets c->ro_error and SB_RDONLY from whatever context hit
> the error, e.g. a failing write, and without holding s_umount. UBIFS
> can't be frozen but that still races with everyone else changing
> sb->s_flags. And c->ro_error alone already makes every write fail with
> EROFS.
> 
> So call sb_set_emergency_ro() instead. The background thread can hit
> the error before SB_BORN but doesn't hold s_umount either. The xattr
> setters check c->ro_error as well because ecryptfs calls them without
> write access on the lower mount and they change the inode in memory
> first.
> 
> So far a remount to read-only after an error was refused and a remount
> to read-write went through and cleared SB_RDONLY again because
> c->ro_mount was never set. Now going read-only works. Nothing is synced
> for it in that state and ubifs_remount_ro() skips the write-buffer syncs
> and the master node like ubifs_put_super() does and only cancels the
> write-buffer timers. Going read-write after that is refused by the VFS.
> 
> The flusher still gets to the folios and inodes that were dirty before
> the error, also after the remount which sets c->ro_mount and frees the
> write reserve buffer. Every journal write fails with EROFS after an
> error anyway. So do_writepage() and ubifs_write_inode() drop them
> without going near the journal. Otherwise reserve_space() trips its
> !c->ro_mount assert for every folio after the remount.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>   fs/ubifs/file.c  | 12 ++++++++++++
>   fs/ubifs/io.c    |  6 +++++-
>   fs/ubifs/super.c | 40 ++++++++++++++++++++++++++--------------
>   fs/ubifs/xattr.c |  6 ++++++
>   4 files changed, 49 insertions(+), 15 deletions(-)

Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index 99dd52715eee9..4eae6c2ae2eea 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -898,6 +898,13 @@ static int do_writepage(struct folio *folio, size_t len)
>   
>   	folio_start_writeback(folio);
>   
> +	/* Nothing gets written after an error, drop the folio. */
> +	if (unlikely(c->ro_error)) {
> +		err = -EROFS;
> +		mapping_set_error(folio->mapping, err);
> +		goto out;
> +	}
> +
>   	block = folio->index << UBIFS_BLOCKS_PER_PAGE_SHIFT;
>   	for (;;) {
>   		blen = min_t(size_t, len, UBIFS_BLOCK_SIZE);
> @@ -918,6 +925,7 @@ static int do_writepage(struct folio *folio, size_t len)
>   		ubifs_ro_mode(c, err);
>   	}
>   
> +out:
>   	ubifs_assert(c, folio->private != NULL);
>   	if (folio_test_checked(folio))
>   		release_new_page_budget(c);
> @@ -997,6 +1005,10 @@ static int ubifs_writepage(struct folio *folio, struct writeback_control *wbc)
>   		goto out_unlock;
>   	}
>   
> +	/* After an error do_writepage() drops the folio. */
> +	if (unlikely(c->ro_error))
> +		return do_writepage(folio, len);
> +
>   	spin_lock(&ui->ui_lock);
>   	synced_i_size = ui->synced_i_size;
>   	spin_unlock(&ui->ui_lock);
> diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
> index 6c6d682427793..931a88329b5f5 100644
> --- a/fs/ubifs/io.c
> +++ b/fs/ubifs/io.c
> @@ -72,7 +72,11 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
>   	if (!c->ro_error) {
>   		c->ro_error = 1;
>   		c->no_chk_data_crc = 0;
> -		c->vfs_sb->s_flags |= SB_RDONLY;
> +		/*
> +		 * SB_RDONLY needs s_umount, see sb_set_emergency_ro(). The
> +		 * background thread runs before SB_BORN already.
> +		 */
> +		sb_set_emergency_ro(c->vfs_sb);
>   		ubifs_warn(c, "switched to read-only mode, error %d", err);
>   		dump_stack();
>   	}
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 38972786817e7..2d71274e89ad0 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -312,6 +312,12 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
>   		return 0;
>   	}
>   
> +	/* Nothing gets written after an error, drop the change. */
> +	if (unlikely(c->ro_error)) {
> +		err = -EROFS;
> +		goto out;
> +	}
> +
>   	/*
>   	 * As an optimization, do not write orphan inodes to the media just
>   	 * because this is not needed.
> @@ -327,6 +333,7 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
>   			err = dbg_check_inode_size(c, inode, ui->ui_size);
>   	}
>   
> +out:
>   	ui->dirty = 0;
>   	mutex_unlock(&ui->ui_mutex);
>   	ubifs_release_dirty_inode_budget(c, ui);
> @@ -1839,19 +1846,26 @@ static void ubifs_remount_ro(struct ubifs_info *c)
>   
>   	dbg_save_space_info(c);
>   
> -	for (i = 0; i < c->jhead_cnt; i++) {
> -		err = ubifs_wbuf_sync(&c->jheads[i].wbuf);
> +	/* Like ubifs_put_super(), don't write anything after an error. */
> +	if (!c->ro_error) {
> +		for (i = 0; i < c->jhead_cnt; i++) {
> +			err = ubifs_wbuf_sync(&c->jheads[i].wbuf);
> +			if (err)
> +				ubifs_ro_mode(c, err);
> +		}
> +
> +		c->mst_node->flags &= ~cpu_to_le32(UBIFS_MST_DIRTY);
> +		c->mst_node->flags |= cpu_to_le32(UBIFS_MST_NO_ORPHS);
> +		c->mst_node->gc_lnum = cpu_to_le32(c->gc_lnum);
> +		err = ubifs_write_master(c);
>   		if (err)
>   			ubifs_ro_mode(c, err);
> +	} else {
> +		/* Syncing the write-buffers would have canceled them. */
> +		for (i = 0; i < c->jhead_cnt; i++)
> +			hrtimer_cancel(&c->jheads[i].wbuf.timer);
>   	}
>   
> -	c->mst_node->flags &= ~cpu_to_le32(UBIFS_MST_DIRTY);
> -	c->mst_node->flags |= cpu_to_le32(UBIFS_MST_NO_ORPHS);
> -	c->mst_node->gc_lnum = cpu_to_le32(c->gc_lnum);
> -	err = ubifs_write_master(c);
> -	if (err)
> -		ubifs_ro_mode(c, err);
> -
>   	vfree(c->orph_buf);
>   	c->orph_buf = NULL;
>   	kfree(c->write_reserve_buf);
> @@ -1977,10 +1991,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
>   		if (err)
>   			return err;
>   	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
> -		if (c->ro_error) {
> -			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
> -			return -EROFS;
> -		}
> +		/* After an error ubifs_remount_ro() can't write but still works. */
>   		ubifs_remount_ro(c);
>   	}
>   
> @@ -1994,7 +2005,8 @@ static int ubifs_reconfigure(struct fs_context *fc)
>   		mutex_unlock(&c->bu_mutex);
>   	}
>   
> -	if (!c->need_recovery)
> +	/* Only valid without a media failure, see ubifs_put_super(). */
> +	if (!c->need_recovery && !c->ro_error)
>   		ubifs_assert(c, c->lst.taken_empty_lebs > 0);
>   
>   	return 0;
> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
> index 3b0e8a270f594..572f6f3e52ad3 100644
> --- a/fs/ubifs/xattr.c
> +++ b/fs/ubifs/xattr.c
> @@ -260,6 +260,9 @@ int ubifs_xattr_set(struct inode *host, const char *name, const void *value,
>   	if (check_lock)
>   		ubifs_assert(c, inode_is_locked(host));
>   
> +	if (c->ro_error)
> +		return -EROFS;
> +
>   	if (size > UBIFS_MAX_INO_DATA)
>   		return -ERANGE;
>   
> @@ -564,6 +567,9 @@ static int ubifs_xattr_remove(struct inode *host, const char *name)
>   
>   	ubifs_assert(c, inode_is_locked(host));
>   
> +	if (c->ro_error)
> +		return -EROFS;
> +
>   	if (fname_len(&nm) > UBIFS_MAX_NLEN)
>   		return -ENAMETOOLONG;
>   
> 

