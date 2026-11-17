Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.89.141.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794941033;
	b=y7K/Bg6FEJhPNPgqqRf81K2tZz0Lz5PTPe7TuaJrsY4/X5x9IS6xGZu3WMvpddsR9QJL
	 NUpnVpIkFlfqGZB1B92LqXACbaTWkt/+/inS62GMxm+tI66oqajSzL55DVrEIAVUUXdqu
	 heiB5n8pZS4IY+AvNwfWrd7rX90X30HX63ff+p8MpYol6vrMKCE/tAH4y+b0C+grOq4Hj
	 4QU9dIotiU8pXospRoFGOF/sjAXtBYulSF4MgcolGNMg78JpY0+Mld+onOZiyhiNJyqOO
	 SPK8Zpz3D9s+4y4bf1r9c3labh+dxhJ01jvOPQSIkBDnqicaRzcUZD/IRFRYX3gKe0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941033;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:Sender;
	bh=4JVoFLBJ14XWuNh6XsjpGCSq0P7wm0pRAB3PoCD11nU=;
	b=cU1yCEkiZslIXE56guOvWzi16I4/dPbOZloZ/d/O1VdB4v1ISR3ROv5fwyB4OkByag0j
	 17ceEyZU+KYEnAwK8a9gTZvokjvJ61fIS+IPHQgsU2KIUKdZGMh2bH/CsVEZa7560NHfn
	 RzPYf8WsctwxcfIqXM6QyTDTwd+jS4UgO13fQmkSSdhaC22u/KQaMDDcvmBnxr68mFnDs
	 wAMMVsDvz6rTh6YF23hRwHTtxvz27ic/G0mM9pVAT6YQuDaBikWwJN3YlkMPMAFQbYTKX
	 pTk5lC+6Th/5WDJcCMyBC1uvHXZ+dzulIoQIuPmc/KfmCJmh7zkDYK/OCdJp44oQVpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zeniv.linux.org.uk;
	spf=none smtp.mailfrom=ftp.linux.org.uk;
	dkim=pass header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=AWxjau5N;
	arc=none smtp.remote-ip=62.89.141.173
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C565606A31C;
	Tue, 17 Nov 2026 18:43:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C565606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=AWxjau5N
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4JVoFLBJ14XWuNh6XsjpGCSq0P7wm0pRAB3PoCD11nU=; b=AWxjau5NBnr1l/1QDGXVWlGoWa
	Ww+3Cp9gDzrunQltGul8fKaM9mZ9YE0cBww0Y5QvNN3Io5vqYAUhHNUYnDxVVW0fKIJPL4fsPq2MI
	EeptawwSLibpDC3BQ0bYPrCp2RNIC9Nfp3VR3VyYzpc7joMQjLfADGBCsNpmUKqO3/GRgM9wJgh2s
	+yS9Rwh4OLTD4dZqCkSP4OsbTDklsJjnv0SqzGZtaZ91OcoSNEIsy1d5ph8FDJY8MvM5Y1HJppoeD
	YqX+V+H3STsOY/NEAfzvzN7psGQ6T4MrVmRbXOC5WUhBvfAzysA4dcQIySD9utIVLFrpKyfwmLPW2
	17UA+rNQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTO9e-00000002Td0-1517;
	Tue, 17 Nov 2026 18:43:42 +0000
Date: Tue, 17 Nov 2026 18:43:42 +0000
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
Subject: Re: [PATCH -next -v4 02/17] LSM: pass struct path to the
 inode_setsecctx hook
Message-ID: <20261117184342.GR989762@ZenIV>
References: <20261117150542.1169451-1-caixinchen1@huawei.com>
 <20261117150542.1169451-3-caixinchen1@huawei.com>
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
In-Reply-To: <20261117150542.1169451-3-caixinchen1@huawei.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Nov 17, 2026 at 11:05:27PM +0800, Cai Xinchen wrote:
> The inode_setsecctx hook and its security_inode_setsecctx() caller in
> fs/nfsd operate on a dentry even though both have a struct path
> available.  Pass a const struct path so that the coming conversion of the
> xattr helpers can be reflected in the implementations; for now SELinux
> and Smack keep passing path->dentry and &nop_mnt_idmap to
> __vfs_setxattr_locked().
> 
> Also document in lsm_hook_defs.h what a struct path argument may be used
> for: it can be passed to VFS helpers taking a struct path, but nothing is
> guaranteed about path->mnt.

No, with the side of Hell, No.

> + * Hooks that take a struct path argument: the VFS only sanctions passing
> + * the path to VFS helpers that take a struct path (e.g. notify_change());
> + * it makes no guarantees with regard to path->mnt, whose layout and
> + * implementation details are subject to change.  Implementations must
> + * not rely on its properties.

NAKed-by: Al Viro <viro@zeniv.linux.org.uk>

If that kind of stuff actually does get passed to any existing hooks, we need
to fix that ASAP.  If not, consider that a blanket NAK on any patch series
that would introduce such.

We are not going there.  At all.  "Must not rely on its properties" ==
"must make sure that no existing functions with struct path * arguments
ever have such malformed instances passed to them".  Which is not going
to be feasible to enforce.  And yes, that very much includes any VFS helpers.
