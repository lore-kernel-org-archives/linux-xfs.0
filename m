Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793331744;
	b=3xTupxsKZjGRhzEbpgzf/sOpeax244df113/8Evr6Hbha/6SW/g/XnaXaZUl434TUYWt
	 NYHSelkVaCiMogKxvlto78o5hn+jAq24cXbUfNBbOvbZnhOu5EOQo/yy/65dmKk/YlOr9
	 BbpFedJd1yd3lx5AKtnFPcLVkdX+reIFDGZcW5vXxUsewTcT0ZNmc4oihALInAA4bPAGr
	 S2TkPjbEI9P1aoYxrm0tl1qjshuln+hG/hXJ7l5S3YlRWjswR2a3G22iUNPyj1W4ryJmu
	 xAnSiEr0XQo3IY+IQPJwQzhClAgZLRmSUjTPDdLOOMJrhx/5RV/2hrUMFUJG3cu4UVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793331744;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Subject:To:CC:
	 References:From:Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=lyCCkGxsVqCH5Jxp2Gx73Ra2R6gYJ0X0+xLM8KV7Nyw=;
	b=Cce5bxcyXsnKfxtSViQeH7U7kdjdN2GXhyL1yiznbCiwv6DP/FFzLdSkX2hNJkojpA3x
	 u0eUahX36f7mqDBX01lioEgHjNPPzus5EDoakjoYNUxmKi2KfwNMbJEYDdsMyLgF6CVb/
	 wgbIuSQQuFKeqO94zOLjmVI7ijk8Gxm4W8KaWQReS6vhD2xv9Ws5+8kUZIUMHLzVVgvzT
	 d3YCzZfUeqrxToaVUeAupwLXFBaDJAKJf6FHJsK9yLNrLrgLdOYK3s6eYk5KJoWivg3cG
	 wBa4KM35tAg1xPiqOg6cB/YOCfXF7pyeB1CQnZAonlVwiH4I+mUDbiOwIw3UJP2gOhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=6lgTf+Ts;
	arc=none smtp.remote-ip=113.46.200.216
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECBA606A31C;
	Fri, 30 Oct 2026 03:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ECBA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=6lgTf+Ts
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lyCCkGxsVqCH5Jxp2Gx73Ra2R6gYJ0X0+xLM8KV7Nyw=;
	b=6lgTf+Ts1V+YHSBCrEFvDEXDhiMC9GXMq3b2wsOqtZVSt4aNi9cNouzzS6JDieVJF34tbk3Eh
	hET2+S5R51zLlg3+fDdAp58YFcw5B6/T2rmuCau0hbz720kofk1l0vMy/ktC5xSYSNUX71IMs/h
	Me1Uuzuu58wyIDDAb/XNnkQ=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jG6NZ0f5mz1T4G5;
	Fri, 30 Oct 2026 11:42:06 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 483B3202E6;
	Fri, 30 Oct 2026 11:42:18 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 30 Oct 2026 11:42:16 +0800
Subject: Re: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
To: Christian Brauner <brauner@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, <ecryptfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <jfs-discussion@lists.sourceforge.net>,
	<linux-nilfs@vger.kernel.org>, <exfat@lists.linux.dev>, <linux-mm@kvack.org>,
	<ntfs@lists.linux.dev>, <ocfs2-devel@lists.linux.dev>,
	<linux-btrfs@vger.kernel.org>, <gfs2@lists.linux.dev>,
	<linux-efi@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
	<linux-xfs@vger.kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <0d472865-6cbb-cbb5-b361-1f2bf71dd528@huawei.com>
Date: Fri, 30 Oct 2026 11:42:15 +0800
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
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemo200011.china.huawei.com (7.152.185.179)

ÔÚ 2026/10/30 0:07, Christian Brauner Ð´µÀ:
> ubifs_ro_mode() sets c->ro_error and SB_RDONLY from whatever context hit
> the error, e.g. a failing write, and without holding s_umount. UBIFS
> can't be frozen but that still races with everyone else changing
> sb->s_flags. And c->ro_error alone already makes every write fail with
> EROFS.
> 
> So only set SB_RDONLY while the filesystem is still being mounted and
> call sb_set_emergency_ro() after that. The xattr setters check
> c->ro_error as well because ecryptfs calls them without write access on
> the lower mount and they change the inode in memory first.
> 
> So far a remount to read-only after an error was refused and a remount
> to read-write went through and cleared SB_RDONLY again because
> c->ro_mount was never set. Now going read-only works and its writes fail
> with EROFS before any I/O, and going read-write is refused by the VFS.
> fsync() fails with EROFS instead of taking ubifs_fsync()'s read-only
> shortcut.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>   fs/ubifs/io.c    | 9 ++++++++-
>   fs/ubifs/super.c | 5 +----
>   fs/ubifs/xattr.c | 6 ++++++
>   3 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
> index 6c6d68242779..7a59aa1ea5ce 100644
> --- a/fs/ubifs/io.c
> +++ b/fs/ubifs/io.c
> @@ -72,7 +72,14 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
>   	if (!c->ro_error) {
>   		c->ro_error = 1;
>   		c->no_chk_data_crc = 0;
> -		c->vfs_sb->s_flags |= SB_RDONLY;
> +		/*
> +		 * Before SB_BORN the mounter holds s_umount, later see
> +		 * sb_set_emergency_ro().
> +		 */
> +		if (!(c->vfs_sb->s_flags & SB_BORN))
> +			c->vfs_sb->s_flags |= SB_RDONLY;
> +		else
> +			sb_set_emergency_ro(c->vfs_sb);
>   		ubifs_warn(c, "switched to read-only mode, error %d", err);
>   		dump_stack();
>   	}
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 38972786817e..ef39da4e780b 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -1977,10 +1977,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
>   		if (err)
>   			return err;
>   	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
> -		if (c->ro_error) {
> -			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
> -			return -EROFS;
> -		}
> +		/* After an error ubifs_remount_ro() can't write but still works. */

Hi, Brauner
If we remove the c->ro_error check, ubifs_remount_ro->ubifs_wbuf_sync 
will return EROFS and trigger ubifs_ro_mode() again, I think we can 
retain the pre-check placement to trigger more error printing.
BTW, a remount to read-write after an error is refused too.
>   		ubifs_remount_ro(c);
>   	}
>   
> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
> index 3b0e8a270f59..572f6f3e52ad 100644
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
The sb_rdonly won't affect the sync_fs_one_sb() after an error, and 
sb_emergency_ro check in not added into sync_fs_one_sb, should we add 
the c->ro_error check in ubifs_sync_fs() to prevent the failure 
ubifs_wbuf_sync executing?
