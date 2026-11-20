Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795181931;
	b=geeOsXrOIGnV7BpdPVGy9Cai2ULTwQQxf79smLaQFMv9PfbQjPMID0PsHmHTKcqHGOyd
	 XB/tAVqnGlol0UYOcxEgGFoHdwO/u7lcX+s5FO3e75rRLDvx7BwPiGB0/tDvKd3ERH5SE
	 VSLjCn0iUPiCaDKhaPuDaQdsFg3Vh3+VKzwjEhSkUQUkfHJGmMYYmaHXB3WDZ6ZXvnEdQ
	 7mpq/1rsgG1K1ZkdncV9Umuv2b249AAAUFIxw02ivRnepAnppseXy3QXRl4qPbN8SNOJm
	 EAbiXTGCQOOFo3JjNjjktODrpGrdffBIFIY+Xmwf+qe1YuEn+gxBzaCVYofxMN1Mjjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795181931;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qZNnoG+Fb9/W4ISE55dTt9q7EvNYjApPu7ZJ7FyZ+gg=;
	b=pclD1DI3fRYP5h2blMsWKJUEpLQ9Ra3SGU60i2VwjeDU9Pr0XmMo8r4T7wnyk2ggqR4u
	 eRvQb3SzY8EwY1M79LXQS3T14jTBuS5ZGykXoeb4q/P8P58tX35IWKJAPnvIHkKoHFP7I
	 JG717ofENdLKQNLRp43wma/zhFGhXrO8Xtfuu6fpET6mKgXdtIPGPHXGpHR50PNh7YfhR
	 y3amB+uN2DVPM9BH9+ZFVqSCaYFAhbaAC/yEkHYBx2OW0+zfEVaaUxuj1wEh63XxWFU3y
	 2bwT3GD0MV2w1PIvT8vsGJefQbFL6O4K8UjDYYBa2vLR0BIg2iDEFmZZg0zVcjlPUSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ZVt/gpeT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B957606A320;
	Fri, 20 Nov 2026 13:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZVt/gpeT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5DE1F000CA;
	Fri, 20 Nov 2026 13:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795181930;
	bh=qZNnoG+Fb9/W4ISE55dTt9q7EvNYjApPu7ZJ7FyZ+gg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZVt/gpeT+QwOmnfJsc/3ftB9+K4CjZ3YSI88OOCcUEyqT8stAjszp+96a1oJ8+0Ns
	 tJ28EUnrlrLw9TlUOid9CZzjfn9sO4YAFQTD69kTlmyLwU5FrG5okc44xqgyYHPO9k
	 72COaeHn+Gxg6/5DfuobCFUQxlXa/5iZuMi/kBejSCtB4CLtllAXZ9ODJZwsH/NGBR
	 me1qLoTncPhWjF3BwjgrOy0tCk4+03m+KRYy5i/BYG3pC+wuQs7E2NKAfbcsFxCgsT
	 UgMCojc7Jqf5gf7TYm5o8CJidfwqwilfz1646EEe12O0PTjnF7rI/OQf91AzOYM3w9
	 eAvB4es4XUd3A==
Date: Fri, 20 Nov 2026 14:38:43 +0100
From: Christian Brauner <brauner@kernel.org>
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Jan Kara <jack@suse.cz>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	linux-kernel@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-fsdevel@vger.kernel.org, 
	linux-um@lists.infradead.org, ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] procfs: drop parent lock for d_alloc_parallel()
 in iterate_shared()
Message-ID: <20261120-visier-dortig-gutachten-7a478b74ea10@brauner>
References: <20261117000115.1433875-1-neilb@ownmail.net>
 <20261117000115.1433875-5-neilb@ownmail.net>
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
In-Reply-To: <20261117000115.1433875-5-neilb@ownmail.net>

On Tue, Nov 17, 2026 at 10:55:01AM +1100, NeilBrown wrote:
> +	if (child == ERR_PTR(-EWOULDBLOCK)) {
> +		/*
> +		 * Need to drop directory lock, which isn't really
> +		 * needed here anyway.  As rmdir never happens in procfs
> +		 * we don't need to be concerned about S_DEAD being set
> +		 * while unlocked.
> +		 */
> +		inode_unlock_shared(dir->d_inode);
>  		child = d_alloc_parallel(dir, &qname);
> [...]
> +		inode_lock_shared(dir->d_inode);
> +	}

I think this can deadlock.
If we're colliding with the failed lookup because the fd was closed, the
task exited or the sysctl unregistered then the  dentry is unhashed and
d_alloc_parallel() hands us a new in-lookup dentry.

We then retake the lock while still owning it. But the VFS waits for
in-lookup dentries with the lock held, e.g., open() with O_CREAT:

P1: getdents(/proc/$pid/fd)         P2: open("/proc/$pid/fd/5", O_CREAT)
proc_fill_cache("5")
-> d_alloc_trylock() == -EWOULDBLOCK
-> inode_unlock_shared(dir)
                                    lookup_open()
                                    -> inode_lock(dir)
                                    -> d_lookup("5") == NULL
-> child = d_alloc_parallel("5")
                                    -> d_alloc_parallel("5")
                                       -> d_wait_lookup(child)
-> inode_lock_shared(dir)

Both sleep uninterruptibly.
A shell redirect to /dev/fd/5 is enough for P2.

I don't tink it even needs O_CREAT. Any queued writer like a mkdir in
the directory or chmod on it plus a lookup_slow() of the same name that
holds the lock shared and waits on the child has the asme issue.

And under /proc/sys/net it doesn't need a failing lookup either.
proc_sys_compare() matches any in-lookup dentry but after the wait
sysctl_is_seen() rejects a dentry from another netns and we get our
own.

d_add_ci() in 1/4 gets this right and finishes all in-lookup dentries
before relocking. So I think procfs needs to do the same, sm like
(UNTESTED):

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5f9ec52..d30f877 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2105,19 +2105,19 @@ bool proc_fill_cache(struct file *file, struct dir_context *ctx,
 	struct inode *inode;
 	unsigned type = DT_UNKNOWN;
 	ino_t ino = 1;
+	bool relock = false;
 
 	child = d_alloc_trylock(dir, &qname);
-
 	if (child == ERR_PTR(-EWOULDBLOCK)) {
 		/*
-		 * Need to drop directory lock, which isn't really
-		 * needed here anyway.  As rmdir never happens in procfs
-		 * we don't need to be concerned about S_DEAD being set
-		 * while unlocked.
+		 * Wait for the other lookup without the directory lock and
+		 * don't take it back while @child is in-lookup: lookup_open()
+		 * waits for in-lookup dentries with the lock held exclusive.
+		 * procfs never sets S_DEAD.
 		 */
 		inode_unlock_shared(dir->d_inode);
+		relock = true;
 		child = d_alloc_parallel(dir, &qname);
-		inode_lock_shared(dir->d_inode);
 	}
 	if (IS_ERR(child))
 		goto end_instantiate;
@@ -2137,6 +2137,8 @@ bool proc_fill_cache(struct file *file, struct dir_context *ctx,
 	type = inode->i_mode >> 12;
 	dput(child);
 end_instantiate:
+	if (relock)
+		inode_lock_shared(dir->d_inode);
 	return dir_emit(ctx, name, len, ino, type);
 }
 

The sysctl side needs the same.

This also has the same lookup_one_qstr_excl() problem as the earlier
patch.
