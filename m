Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347656;
	b=R8WEAsjnXDRYaiiljlQCvZL14md37kJ5byunm7I72FGajSxP3cPW0Wndwc0P+KvLZtTz
	 dp4nT69EM6OW8DqZTA7cE9s9yv284HUUKQOQ/JIDojTZ8WYYIrfKYdb6g+StxB2fdGdEC
	 Xxkc+6Z8Ch4Rm0ANqhDW5tn1IWz5pqhPW4tMwhSZQ+noc1Dd/W3hzvyFL3MKfmBnw9bLC
	 x5wkgAZRCDckcnMzrWjX9/WwvUJCp2th6tqiSlhi32il7TnJtTZvjIug9rG5nDcc4rz4G
	 fn6y2AzeffjP8/prfjFnNbBzn9k+1/oPZjcLkuJiyefzdeG2c7qzH7J6uGwmr/cWDaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347656;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kvR+7LpUq2XDou+hL2YOto2Xs7eBH6ZEazzzuluspMo=;
	b=zLv67wtRWqtOxmKqW3umQltdJXdPzyUt5B4i5EryHpM6p3B//6vbplNA+TF6A6yiQ1nb
	 q6uwUO1lMnSzdIHVZ92K0P3/MIrj8ctYKYDWHuHvNgW2aa3Z0+BvGx0NIXo7iuxQ5hKXj
	 Qml7Tb/bzuvCWacc6x1Xnigen1wQEhzzJFqGGK5/pSt4L46a7yJEeC1kgCeQ4PRa/X3On
	 Wst6l2Rb/IE/7W6QEdDuBhJcrvF81EAgd/fBoS2ask7Uf/lWug/6NDj4Qx4RbzTRvgpN4
	 d2S1y/LxMit+yCBqj8wjEkovyVZXEzJHRhF3CD0AqrS0BD2Vaqa+1rxIr7syQbK49Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="eaD/EfjD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46088606A32A;
	Tue, 10 Nov 2026 21:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eaD/EfjD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1531F0089F;
	Tue, 10 Nov 2026 21:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347655;
	bh=kvR+7LpUq2XDou+hL2YOto2Xs7eBH6ZEazzzuluspMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eaD/EfjDchFyH1dENQH1aadvOuz1bw9jbkiQnmwV7pFQSv0SPcCuHPSy3cg1AgrZf
	 u3NXwYhS+orvWDPCpPXaZyNSS+GoUOox6PG5uSdjRvqr3AzMoDafKsT4tR++Y52zyq
	 O4s6HPV/ywyAlQatnavFQ0pBIjmeaDW+xUB5+IzysLQjiA6eAAw0QEBP/TtTETgLFl
	 inp8RjcCw8Shmo9xA+CQnGybqXHfRUFl8MavInvwFF2mGgTJTmUjNtLd4cxgdb5YmJ
	 zo9nAVwddgdwCbsFwqFgDPymJKL5pmccIM+9BnPTJunzaUztEcw+2CGbHe8zKjhAGe
	 JD2NE+KXutgNA==
Date: Tue, 10 Nov 2026 22:54:09 +0100
From: Christian Brauner <brauner@kernel.org>
To: Zhihao Cheng <chengzhihao1@huawei.com>, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
Message-ID: <20261110-erfanden-dossier-zahntechnik-efcb7a6439b0@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
 <0d472865-6cbb-cbb5-b361-1f2bf71dd528@huawei.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0d472865-6cbb-cbb5-b361-1f2bf71dd528@huawei.com>

On Fri, Oct 30, 2026 at 11:42:15AM +0800, Zhihao Cheng wrote:
> If we remove the c->ro_error check, ubifs_remount_ro->ubifs_wbuf_sync
> will return EROFS and trigger ubifs_ro_mode() again, I think we can
> retain the pre-check placement to trigger more error printing.

ubifs_ro_mode() doesn't do anything once c->ro_error is set so that
won't print anything again. But there's no point in syncing the
write-buffers and writing the master node after an error.

So I'll skip both in ubifs_remount_ro() when c->ro_error is set like
ubifs_put_super() does and only cancel the write-buffer timers. The
remount to read-only itself has to keep working because the error
doesn't set SB_RDONLY anymore.

> BTW, a remount to read-write after an error is refused too.

Only if c->ro_mount is set. ubifs_ro_mode() sets SB_RDONLY but never
c->ro_mount. So after an error on a read-write mount ubifs_reconfigure()
takes neither branch and reconfigure_super() clears SB_RDONLY again.

> The sb_rdonly won't affect the sync_fs_one_sb() after an error, and
> sb_emergency_ro check in not added into sync_fs_one_sb, should we add
> the c->ro_error check in ubifs_sync_fs() to prevent the failure
> ubifs_wbuf_sync executing?

Yes, I'll return -EROFS from ubifs_sync_fs() when c->ro_error is set.
After the !wait check so sync_filesystem() still gets to sync_inodes_sb().
