Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994563;
	b=uige0oKgeJWHNoG03Q1AnC9RbaARJdL19qZ9Cg6wcaiovz6lJg0OI4jSfLdshI6pv/KA
	 jNTbX25cpcj4qJwBTfPw+8JDoufK3Fvp/jbnvx0D+tUohfBDDtOjT6dOISs3ecs2GGbYo
	 G5AThHr8o3ab/U7fSBbVlYmKRXC77kzPLvdQgTB7LxWQH9yN/WhNIVZugbODndFujLfNz
	 mBMbC3/TqZPWxIx7G3SPse7KNk8zpjbUjizLLu+bDk9ihboeT//pRIrBRvxjDfgQgjgpS
	 zYvse4vQKSHZ1TPSXiDV5BeuXCMzxHxJKoPJumVuTsxW5B82CRCALk/SKsDf13HgYPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994563;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=oEtrs9YN++TIvppEtfu/diqt2HKppGf1oq8L8HaJ3VE=;
	b=JHHT6GeaZBO6zG1NBYKWec1cXinR97AX7khOViQRUydYGKs8oRGE8KnVjaK8LhOUL+ZW
	 rYalF4yIvB1/GcW3Gh6XFeHnIQQU1RrVXzJKOiPSF/tmESHYxAltdbu8PyNrFbZKEOwoW
	 ieHmCdmJqFi16QijcxgD4pZ7esxPiMB3xrxcFcFAMWg8QhqrDXE/hVlLi7NE9PhfQa48N
	 m0UHIkDkylbLWRYiv7HzD98MIKFWkl4feBVjd+nwcBXkE1hu2exRzTREtQqK1NE7gs8si
	 zlGbHK7KLZ6EWISue9p52Vro7wvl3vAtremgw33zWnDqWGo+aPs65LeSnimlleR9NSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nahPYjtB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8235B606A31C;
	Wed, 18 Nov 2026 09:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nahPYjtB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F321F000C4;
	Wed, 18 Nov 2026 09:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994563;
	bh=oEtrs9YN++TIvppEtfu/diqt2HKppGf1oq8L8HaJ3VE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nahPYjtBD1Iaas2FHy09zfnsVzzPWV2xfnaZM4o2uDixquvqwuHvQ+/o6Lx3RmcT7
	 A5MLlaaWHi5zeDFe6Pr6Zu/1tZf365UdM7zLPXtacuahcYasmLgD5icYRCqSxPoOAQ
	 apSPaDPnXbhT/Rjv6/c4yyGGAb3a6EIjZs+gpHbG4KtSnFEboWn87xat6LJyla++Jd
	 yjbLXh2HQKcIglQe/QgOIjdxO0MlY4PzADbD2mLPuxiLGazQOP1N6OqiCY11zDd0cS
	 +PtK7soRS49YQWtEbo0XhLlRb2q60FYLSeh5q1DNqhKbRWl7YpSpO779dHK9eKPFp5
	 s/bgKJ6Xw8nfA==
Date: Wed, 18 Nov 2026 10:35:40 +0100
From: Christian Brauner <brauner@kernel.org>
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, mic@digikod.net, gnoack@google.com, 
	paul@paul-moore.com, jack@suse.cz, amir73il@gmail.com, andrii@kernel.org, 
	apparmor@lists.ubuntu.com, ast@kernel.org, axboe@kernel.dk, bpf@vger.kernel.org, 
	casey@schaufler-ca.com, cel@kernel.org, cem@kernel.org, chenxiaosong@chenxiaosong.com, 
	code@tyhicks.com, corbet@lwn.net, Dai.Ngo@oracle.com, dakr@kernel.org, 
	daniel@iogearbox.net, dhowells@redhat.com, dlemoal@kernel.org, 
	dmitry.kasatkin@gmail.com, driver-core@lists.linux.dev, dsterba@suse.com, 
	ecryptfs@vger.kernel.org, eddyz87@gmail.com, emil@etsalapatis.com, 
	eric.snowberg@oracle.com, exfat@lists.linux.dev, georgia.garcia@canonical.com, 
	gregkh@linuxfoundation.org, hch@lst.de, hirofumi@mail.parknet.co.jp, hyc.lee@gmail.com, 
	ihor.solodrai@linux.dev, jlayton@kernel.org, jmorris@namei.org, johan@kernel.org, 
	john.fastabend@gmail.com, john.johansen@canonical.com, jolsa@kernel.org, 
	kpsingh@kernel.org, linkinjeon@kernel.org, linux-api@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, liubaolin12138@163.com, 
	martin.lau@linux.dev, mason@kernel.org, mathieu.desnoyers@efficios.com, 
	matt@bobrowski.net, memxor@gmail.com, mhiramat@kernel.org, miklos@szeredi.hu, 
	neil@brown.name, netfs@lists.linux.dev, ntfs@lists.linux.dev, okorniev@redhat.com, 
	omosnacek@gmail.com, penguin-kernel@i-love.sakura.ne.jp, rafael@kernel.org, 
	rdunlap@infradead.org, roberto.sassu@huawei.com, rostedt@goodmis.org, 
	selinux@vger.kernel.org, senozhatsky@chromium.org, serge@hallyn.com, 
	sj1557.seo@samsung.com, skhan@linuxfoundation.org, song@kernel.org, 
	stephen.smalley.work@gmail.com, takedakn@nttdata.co.jp, tom@talpey.com, yonghong.song@linux.dev, 
	yuezhang.mo@sony.com, zohar@linux.ibm.com, utilityemal77@gmail.com, 
	lujialin4@huawei.com
Subject: Re: [PATCH -next -v4 02/17] LSM: pass struct path to the
 inode_setsecctx hook
Message-ID: <20261118-nordlicht-badeort-daumen-813a1e9fd0b3@brauner>
References: <20261117150542.1169451-1-caixinchen1@huawei.com>
 <20261117150542.1169451-3-caixinchen1@huawei.com>
 <20261117184342.GR989762@ZenIV>
 <20261118001641.GA1669148@ZenIV>
 <bdc22808-9f22-46f7-b42d-e6bd8e1eeaca@huawei.com>
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
In-Reply-To: <bdc22808-9f22-46f7-b42d-e6bd8e1eeaca@huawei.com>

On Wed, Nov 18, 2026 at 04:59:29PM +0800, Cai Xinchen wrote:
> There are two places that violate (1), both introduced by this series of
> patches in ksmbd:
>
> smb2_parent_compressed() and smb_inherit_dacl() pair the directory entry
> returned by dget_parent()
>
> with path->mnt, and problems arise once that directory entry becomes the
> root of its mount point.

No, (1) holds there. dget_parent() never leaves the superblock so the
parent has the same ->d_sb as path->dentry.

What happens at the root of a mount is that the parent isn't below
path->mnt->mnt_root anymore. That's a different property and struct path
doesn't guarantee that (open_by_handle_at(), nfsd with
no_subtree_check). So there's nothing to fix for (1) in those two.
