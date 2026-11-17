Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.89.141.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794940308;
	b=sRzOi9MCHueqMjYvnJ50wjfd3NUFtiH0gRyTBi02uByy09fmz2YE4NvEZ0+ZJHj38itV
	 4svhvdV39xn5quGkko5mdRAkdfH25lClNmtEaLLQ0K8cZ6+b1FVmoqSwGttmzL4Ypx4rO
	 iwsoqRcIjTV3abgGB8u3MZsIwECMsJYan79A6uYejY17gHAfyP5/hcETvJnAzuSmTWRMf
	 Nm/7FL8vd9yl+ByRG4kbodju6wrJ5ac5hzLoS0bxN+uYUZvaEE/7u2WPapsLNSBOnxxT6
	 diYFE6GiuJZ2uESyXwTX5YCnRwK2URF4+U5vzbd+pZfE3h83ufpe2NV+Wm6lPz1uiGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794940308;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:Sender;
	bh=tMKIL4Tw6+P8nxVMgy3ZxNBt370rRgm0QxvRZlxxhD0=;
	b=EClkbosfKAeJf6HCAeKJoO17u1/4G2wsuTm2saFNIgbt9QwRPG30uFhEMFmcDubN+TgA
	 uxFTZmDW8EQjPkHJk4ZfsrzkLhk6wApLINr0kTJxe2dBockrPONqsJy11dnNmYPR057MA
	 rumi48mj2G5fIWRHdCrqjea5FlJs8buaQXIcIjt7QThVSF5zmC4y+NLbKmApYKVQoLr71
	 r3AGzNbXKA6N2lpz7V1qPnqLC0dDpPiKhNNkH2Nlf+zlgS8msCCa6Vloz+Vme4q6qEdf+
	 CLmVw5C2b3qd99KioHX+na6IrcN52Ew/coMz6OtMKATryctc7YQ/AS/Dxv5Y98e0ZyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zeniv.linux.org.uk;
	spf=none smtp.mailfrom=ftp.linux.org.uk;
	dkim=pass header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=TDuWQEHo;
	arc=none smtp.remote-ip=62.89.141.173
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F302606A336;
	Tue, 17 Nov 2026 18:31:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F302606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=TDuWQEHo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tMKIL4Tw6+P8nxVMgy3ZxNBt370rRgm0QxvRZlxxhD0=; b=TDuWQEHovmiau7VCBkXgVGRkK3
	qNI48Oggv+Q9HlViFP5Rd1pkrId3BRYTeyBJkobYwVJZE7XOYZzoqC602DkJXl7YWtyNs8fQ4bQ1L
	M6cPQgYfkx0upaukkTT3E34ETIPOyT4fFspAnBM5n9bcLPULu0wWsA834gK6NUjfnXpbq3TAM82xS
	uV7aZps0RQ5OTIfQqNdoCCC7QUluccfpo2tdFmSFByN7VFcTvuonxWf4PQHfxLS9lo3t3ghaFn1DA
	JcC+4RHlrKT/uuMSV2ANjxnXiR7J0vGVyq2V03OYSPpBUGVE9s0IewlWxIKgY9gMLtnLB721HnM7Q
	+Sab7DYQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTNxL-00000002J6d-49Dd;
	Tue, 17 Nov 2026 18:31:00 +0000
Date: Tue, 17 Nov 2026 18:30:59 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: mic@digikod.net, gnoack@google.com, paul@paul-moore.com,
	brauner@kernel.org, jack@suse.cz, amir73il@gmail.com,
	andrii@kernel.org, apparmor@lists.ubuntu.com, ast@kernel.org,
	axboe@kernel.dk, bpf@vger.kernel.org, casey@schaufler-ca.com,
	cel@kernel.org, cem@kernel.org, chenxiaosong@chenxiaosong.com,
	code@tyhicks.com, corbet@lwn.net, Dai.Ngo@oracle.com,
	dakr@kernel.org, daniel@iogearbox.net, dhowells@redhat.com,
	dlemoal@kernel.org, dmitry.kasatkin@gmail.com,
	driver-core@lists.linux.dev, dsterba@suse.com,
	ecryptfs@vger.kernel.org, eddyz87@gmail.com, emil@etsalapatis.com,
	eric.snowberg@oracle.com, exfat@lists.linux.dev,
	georgia.garcia@canonical.com, gregkh@linuxfoundation.org,
	hch@lst.de, hirofumi@mail.parknet.co.jp, hyc.lee@gmail.com,
	ihor.solodrai@linux.dev, jlayton@kernel.org, jmorris@namei.org,
	johan@kernel.org, john.fastabend@gmail.com,
	john.johansen@canonical.com, jolsa@kernel.org, kpsingh@kernel.org,
	linkinjeon@kernel.org, linux-api@vger.kernel.org,
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, liubaolin12138@163.com,
	martin.lau@linux.dev, mason@kernel.org,
	mathieu.desnoyers@efficios.com, matt@bobrowski.net,
	memxor@gmail.com, mhiramat@kernel.org, miklos@szeredi.hu,
	neil@brown.name, netfs@lists.linux.dev, ntfs@lists.linux.dev,
	okorniev@redhat.com, omosnacek@gmail.com,
	penguin-kernel@i-love.sakura.ne.jp, rafael@kernel.org,
	rdunlap@infradead.org, roberto.sassu@huawei.com,
	rostedt@goodmis.org, selinux@vger.kernel.org,
	senozhatsky@chromium.org, serge@hallyn.com, sj1557.seo@samsung.com,
	skhan@linuxfoundation.org, song@kernel.org,
	stephen.smalley.work@gmail.com, takedakn@nttdata.co.jp,
	tom@talpey.com, yonghong.song@linux.dev, yuezhang.mo@sony.com,
	zohar@linux.ibm.com, utilityemal77@gmail.com, lujialin4@huawei.com
Subject: Re: [PATCH -next -v4 01/17] fs: pass struct path to notify_change()
Message-ID: <20261117183059.GP989762@ZenIV>
References: <20261117150542.1169451-1-caixinchen1@huawei.com>
 <20261117150542.1169451-2-caixinchen1@huawei.com>
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
In-Reply-To: <20261117150542.1169451-2-caixinchen1@huawei.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Nov 17, 2026 at 11:05:26PM +0800, Cai Xinchen wrote:

> +notify_change() and do_truncate() now take a const struct path * instead
> +of a struct dentry *.  They use path->dentry, so callers that only have a
> +dentry must provide a struct path.  struct iattr has a new ia_path member,
> +which notify_change() sets for the duration of the call; it must not be
> +stored beyond that.  Filesystems that forward a change to another inode
> +can use notify_change_target() to update the target dentry while keeping
> +the caller-supplied path in ia_path.

That needs a bit along the lines of "path MUST be consistent - don't combine
a dentry from one filesystem with mount of another".  All in-kernel callers
might have appropriate struct mount references on hand, but for out-of-tree
code that might be not true and we'd better be upfront about the headache
we are inflicting.

I'm not sure we really want to provide those mount references, TBH - it does
add a constraint not just on out-of-tree callers, but upon the future uses
in the kernel.  If NTFS is the only reason... ugh.

> diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
> index 11c70888f38b..410906a66ee9 100644
> --- a/drivers/base/devtmpfs.c
> +++ b/drivers/base/devtmpfs.c
> @@ -284,13 +284,14 @@ static int handle_create(const char *nodename, umode_t mode, kuid_t uid,
>  			dev->devt, NULL);
>  	if (!err) {
>  		struct iattr newattrs;
> +		struct path attr_path = { .mnt = path.mnt, .dentry = dentry };
>  
>  		newattrs.ia_mode = mode;
>  		newattrs.ia_uid = uid;
>  		newattrs.ia_gid = gid;
>  		newattrs.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID;
>  		inode_lock(d_inode(dentry));
> -		notify_change(&nop_mnt_idmap, dentry, &newattrs, NULL);
> +		notify_change(&nop_mnt_idmap, &attr_path, &newattrs, NULL);

BTW, why not something like

		notify_change(&nop_mnt_idmap,
			      &(struct path){.mnt = path.mnt, .dentry = dentry},
			      &newattrs, NULL);
instead of that named local?  Same question for other places like that...

> +int notify_change_target(const struct mnt_idmap *idmap,
> +			 const struct path *path, struct dentry *target,
> +			 struct iattr *attr,
> +			 struct delegated_inode *delegated_inode)
> +{
> +	if (WARN_ON_ONCE(!target))
> +		return -EINVAL;
> +	return do_notify_change(path, idmap, target, attr, delegated_inode);
> +}

