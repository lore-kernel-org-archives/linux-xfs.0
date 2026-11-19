Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.89.141.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795067497;
	b=PizJrPiRdacQOivJN1glKJiYPuAYyuMqqTZl3wR6SZDQCrGB0x8rOMA9QkgdTaT0uV/1
	 bgLOd87vA/SwIr+H+68jWMEIOv5B4NGuBQ+p7yO9tZmKcyqE8vVdCqqAKSihHDS0K7yDP
	 7O8b5P+to3XynZpyLjO5JJjiL8lXNU7SReH3SYW6tM7daU8vm4G6OJm+/TaXmJmMg1gyL
	 Yfxr+8of5GKNaxXhphnWFrQHUHf8SnYjbFzm5o9OfJIDiolqN8uORqfvKszlLXISCHMvK
	 2be/9YMNQdXf5MwcfuM4NkEwLIA2LOfWAAHBXC1JS/fmxCNDNh8KH2VXQLN9kHFF89Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795067497;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:Sender;
	bh=z8G4571aUTPFuGlDRih4WtoT+MR1zWs5KxPfHLJ0IoQ=;
	b=K438CdbgINAZblCj2Vo8NMPTupp/jd8A3pokleOc9gKBuaVvr8hgSpT7r+t88U3xpw4R
	 8lCEgPXLikVJak4pUOOjA4WHRs43tG8gXxCkodM9lU1qGFg3zzn8+XP2CxxHooy1Gayd0
	 juO8N3HMQBBckyCNTsdUDRwj9NuzbHC90rRyc7Aa3H108FuG2cE5256WaeqxJlJN+wkEj
	 takEtrZqw7IUaVDHq3aUOrY1e0ps3JpvqlCFmg12LpqYohT5bh1QbKRiHNRdaq2adobsE
	 vYFosqm6szMv6srf4rGaa0Vd5nVeEHcEzwuULrG4gu1btRDDdAOfuAPwdULTADdmyPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zeniv.linux.org.uk;
	spf=none smtp.mailfrom=ftp.linux.org.uk;
	dkim=pass header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=HUmq9V2f;
	arc=none smtp.remote-ip=62.89.141.173
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD1F606A325;
	Thu, 19 Nov 2026 05:51:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFD1F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=HUmq9V2f
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z8G4571aUTPFuGlDRih4WtoT+MR1zWs5KxPfHLJ0IoQ=; b=HUmq9V2fqWZniya7o9nBaVPeDZ
	hdLnNqA0+VaoySgEJuKHB41/nmyLaGptpyplTvFZpj9ZsUfvW/Uacb0EujAyxoatj/wEjrTHUy1Y8
	Jf/0+dvEia8oYQhTDJ2QTEjT6TZu9xP6N/is4httLR57O2jb4I7x7sybjo+/cFqRcKEnzzz9PN71w
	Fs3s4nF5yw1DIdzaYMKdWCNazNDVu5/+7GdnX+s8wkC+dHul4l8kAJetHVgTfI7IM42m1/kFkA0V+
	e5cVGVGh3fNAY2bVKP02Pyi9IdxpjMoQwmhSMxh71ivIpbruqUDwYbd4JXLlMVMx0hkbK2WWTq4Oa
	k2qmfFmA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTv3O-000000063G7-3IJX;
	Thu, 19 Nov 2026 05:51:26 +0000
Date: Thu, 19 Nov 2026 05:51:26 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
Cc: Cai Xinchen <caixinchen1@huawei.com>, mic@digikod.net,
	gnoack@google.com, paul@paul-moore.com, jack@suse.cz,
	amir73il@gmail.com, andrii@kernel.org, apparmor@lists.ubuntu.com,
	ast@kernel.org, axboe@kernel.dk, bpf@vger.kernel.org,
	casey@schaufler-ca.com, cel@kernel.org, cem@kernel.org,
	chenxiaosong@chenxiaosong.com, code@tyhicks.com, corbet@lwn.net,
	Dai.Ngo@oracle.com, dakr@kernel.org, daniel@iogearbox.net,
	dhowells@redhat.com, dlemoal@kernel.org, dmitry.kasatkin@gmail.com,
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
Message-ID: <20261119055126.GU989762@ZenIV>
References: <20261117150542.1169451-1-caixinchen1@huawei.com>
 <20261117150542.1169451-3-caixinchen1@huawei.com>
 <20261117184342.GR989762@ZenIV>
 <20261118001641.GA1669148@ZenIV>
 <20261118-woher-duften-bejubeln-7a8a2099f89f@brauner>
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
In-Reply-To: <20261118-woher-duften-bejubeln-7a8a2099f89f@brauner>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Nov 18, 2026 at 09:51:27AM +0100, Christian Brauner wrote:
> On Wed, Nov 18, 2026 at 12:16:41AM +0000, Al Viro wrote:
> > On Tue, Nov 17, 2026 at 06:43:42PM +0000, Al Viro wrote:
> > > > + * Hooks that take a struct path argument: the VFS only sanctions passing
> > > > + * the path to VFS helpers that take a struct path (e.g. notify_change());
> > > > + * it makes no guarantees with regard to path->mnt, whose layout and
> > > > + * implementation details are subject to change.  Implementations must
> > > > + * not rely on its properties.
> 
> That comment is a garbled version of an earlier review. It meant that
> LSMs get no guarantees about struct vfsmount internals and don't get to
> poke at them. I'm not sure how this can be read as path->mnt being a
> random mount.

"no guarantees with regard to path->mnt" is easy to parse that way when one
is stuck with a caller that needs to be converted to new API with no relevant
mount reference in sight.

> > > If that kind of stuff actually does get passed to any existing hooks, we need
> > > to fix that ASAP.
> 
> Of course there is one...
> 
>   dent = lookup_one_unlocked(idmap, &QSTR_LEN(...),
>                              priv->dir_fp->filp->f_path.dentry);
>   [...].
>   rc = ksmbd_vfs_fill_dentry_attrs(priv->work, idmap, dent, &ksmbd_kstat);
> 
> It passes only the bare dentry, and ksmbd_vfs_fill_dentry_attrs() then
> makes up a path from the share's root mount:
> 
>   struct path path = {
>           .mnt = share_conf->vfs_path.mnt,   /* mount the share is exported from */
>           .dentry = dentry,                  /* entry inside the listed dir */
>   };
>   rc = vfs_getattr(&path, ...);
> 
> since 5614c8c487f6 ("ksmbd: replace generic_fillattr with vfs_getattr").
> 
> So a client that lists a directory on a submount below the share then
> that dentry belongs to another superblock. So security_inode_getattr()
> and ->getattr() get a mixed path.

So e.g. apparmor hits
        vfsuid_t vfsuid = i_uid_into_vfsuid(mnt_idmap(path->mnt),
					    d_backing_inode(path->dentry));
with path->mnt having nothing to do with path->dentry there?  Fun...

> The third patch in this series fixes this. But we should make this a
> Fixes: patch really... Something like [1].
> 
> > To elaborate a bit: correctness of quite a few places does depend upon the
> > following invaraint:
> > 	path->mnt->mnt_sb == path->dentry->d_sb		(1)
> > for all struct path pointers they might possibly run into.
> >
> > _IF_ you can guarantee that (1) is not violated, we have something to
> > talk about; otherwise, don't call your object struct path and don't
> > pass it to anything that expects to deal with struct path.
> 
> Every struct path the series constructs:
> 
>   - devtmpfs
>   - nfsd
>   - cachefiles
>   - ecryptfs
>   - overlayfs
>   - ksmbd
> 
> doesn't have this bug.
> 
> [1]:
> 
>   --- a/fs/smb/server/smb2pdu.c
>   +++ b/fs/smb/server/smb2pdu.c
>   @@ -6375,13 +6375,14 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
>                           continue;
>                   }
> 
>   +               path.mnt = priv->dir_fp->filp->f_path.mnt;
>   +               path.dentry = dent;
>   +
>                   if (test_share_config_flag(priv->work->tcon->share_conf,
>                                              KSMBD_SHARE_FLAG_HIDE_UNREADABLE)) {
>                           __le32 daccess = FILE_READ_DATA_LE | FILE_READ_EA_LE |
>                                   FILE_READ_ATTRIBUTES_LE;
> 
>   -                       path.mnt = priv->dir_fp->filp->f_path.mnt;
>   -                       path.dentry = dent;
>                           rc = smb_check_perm_dacl(priv->work->conn, &path,
>                                                    &daccess, daccess,
>                                                    priv->work->sess->user->uid,
>   @@ -6397,7 +6398,7 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
>   @@ -6397,7 +6398,7 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
>                   if (priv->info_level != FILE_NAMES_INFORMATION) {
>                           rc = ksmbd_vfs_fill_dentry_attrs(priv->work,
>                                                            idmap,
>   -                                                        dent,
>   +                                                        &path,
>                                                            &ksmbd_kstat);
>                           if (rc) {
>                                   dput(dent);
>   --- a/fs/smb/server/smb_common.c
>   +++ b/fs/smb/server/smb_common.c
>   @@ -472,32 +472,36 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
>           for (i = 0; i < 2; i++) {
>                   struct kstat kstat;
>                   struct ksmbd_kstat ksmbd_kstat;
>   -               struct dentry *dentry;
>   +               struct path path = { .mnt = dir->filp->f_path.mnt };

That's just asking for breakage down the road.  Just pass it
the address of ->f_path for "." and
	&(struct path){.mnt = dir->filp->f_path.mnt, .dentry = dentry}
for ".." (and sod the dentry = dget(...) for "." - just have it NULL there)
