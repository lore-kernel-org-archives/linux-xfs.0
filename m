Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794991916;
	b=BAcA6bBNnhpuhaB8nQp5C2ZfxL04/0F//2yzKnmaRV0A8EcuexIp1ajQykEN24/SJ64m
	 qbyBVZOKjCs/CkM/LgXAcbdfqguggfSOl/5NpmQtdmoFOdgLnZLxqHUpXnZxBPKpmzgNt
	 sc0eh+hPVjrzTlmCT6/JXLrfkjOx9+oiQ4EGGKbg+7rj3BTRgQ9zhk89yWU82kYLFWNF0
	 WkPRtJ11H1QGt8Lq5Xj6+wIkNc5aHn1mI/HbVRdEkLfYqwDABTfSTmZCqNZg03syEOoyg
	 7YZaS8uHBaJGQYrRyLV2Uk+7ulSFJUrjulaWMnjm21U+ZMtLHr4+2MmOvoB0MqcP7KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794991916;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=JNjLV1RqoW47n1WZbcGqB7KkS7CtRm0tXFkupGF+cOc=;
	b=cDSBW6hKU1kX1GaO7FT2PFRUv7PJmndjZ9lPRltkno5sd+pzbTmyN0YF6drGrpKNOCy1
	 SoG+xJrT8hxd9ZqHFja6wsmRt7ZKTqOt/7tGOxZOYEWzstJMGMkpvO+dtgRRcYpQNSVfO
	 /gCp3WgYrbfM18o8hIsF8OVx0zJb/DWx+i8kAI8amhDa64J787soL0VlSzzDzZCwUhVsa
	 6oAcn/wWCFIStoy0KetCStk8RLq4sDDkTnaEnNDJeNeulU/tmd86/sMbERkfxdVek/Tb0
	 mJ5xbsRXj1TQcxz1yK1AQiZpl8Ic2i7R62XfBfEnFsD2RSssPwO/3doRsO9CcWT0tdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RsvXsDlx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9911606A31C;
	Wed, 18 Nov 2026 08:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RsvXsDlx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B8F1F000C4;
	Wed, 18 Nov 2026 08:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794991916;
	bh=JNjLV1RqoW47n1WZbcGqB7KkS7CtRm0tXFkupGF+cOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RsvXsDlxdennVdRZIxtMAO9aTlSCgDU/aRN5nXveVTZaO8kYi5t/Rvtr1wiGCEzHY
	 wP+UMH5gw4T4/2fTW2DI4qwJLAdO/5trCEHdMii87scJ3uqddgNDM1Mu5RIia93hGF
	 Ln1RRmOUcu0iL91VGTmqYQUocfRz6a0kQj1ekzCQiO1Kij5+KjAGbHWQ5Di/UV62Ha
	 AFc19FgOWt5HM+MKdo0fX+KnLQwogg86N+lTKzPrFvOseBVp7lm3DwPnqk6Mb4sLS/
	 q/l1Oj/bKGcluhytkTpuajG1Lv845vosUAR4klQLitOlxelkTCEePyXqhQGZ6u5wiZ
	 4vkK4MG8ZsTLA==
Date: Wed, 18 Nov 2026 09:51:27 +0100
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>, 
	Cai Xinchen <caixinchen1@huawei.com>
Cc: mic@digikod.net, gnoack@google.com, paul@paul-moore.com, jack@suse.cz, 
	amir73il@gmail.com, andrii@kernel.org, apparmor@lists.ubuntu.com, ast@kernel.org, 
	axboe@kernel.dk, bpf@vger.kernel.org, casey@schaufler-ca.com, cel@kernel.org, 
	cem@kernel.org, chenxiaosong@chenxiaosong.com, code@tyhicks.com, corbet@lwn.net, 
	Dai.Ngo@oracle.com, dakr@kernel.org, daniel@iogearbox.net, dhowells@redhat.com, 
	dlemoal@kernel.org, dmitry.kasatkin@gmail.com, driver-core@lists.linux.dev, 
	dsterba@suse.com, ecryptfs@vger.kernel.org, eddyz87@gmail.com, 
	emil@etsalapatis.com, eric.snowberg@oracle.com, exfat@lists.linux.dev, 
	georgia.garcia@canonical.com, gregkh@linuxfoundation.org, hch@lst.de, 
	hirofumi@mail.parknet.co.jp, hyc.lee@gmail.com, ihor.solodrai@linux.dev, jlayton@kernel.org, 
	jmorris@namei.org, johan@kernel.org, john.fastabend@gmail.com, 
	john.johansen@canonical.com, jolsa@kernel.org, kpsingh@kernel.org, linkinjeon@kernel.org, 
	linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	liubaolin12138@163.com, martin.lau@linux.dev, mason@kernel.org, 
	mathieu.desnoyers@efficios.com, matt@bobrowski.net, memxor@gmail.com, mhiramat@kernel.org, 
	miklos@szeredi.hu, neil@brown.name, netfs@lists.linux.dev, ntfs@lists.linux.dev, 
	okorniev@redhat.com, omosnacek@gmail.com, penguin-kernel@i-love.sakura.ne.jp, 
	rafael@kernel.org, rdunlap@infradead.org, roberto.sassu@huawei.com, 
	rostedt@goodmis.org, selinux@vger.kernel.org, senozhatsky@chromium.org, 
	serge@hallyn.com, sj1557.seo@samsung.com, skhan@linuxfoundation.org, 
	song@kernel.org, stephen.smalley.work@gmail.com, takedakn@nttdata.co.jp, 
	tom@talpey.com, yonghong.song@linux.dev, yuezhang.mo@sony.com, 
	zohar@linux.ibm.com, utilityemal77@gmail.com, lujialin4@huawei.com
Subject: Re: [PATCH -next -v4 02/17] LSM: pass struct path to the
 inode_setsecctx hook
Message-ID: <20261118-woher-duften-bejubeln-7a8a2099f89f@brauner>
References: <20261117150542.1169451-1-caixinchen1@huawei.com>
 <20261117150542.1169451-3-caixinchen1@huawei.com>
 <20261117184342.GR989762@ZenIV>
 <20261118001641.GA1669148@ZenIV>
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
In-Reply-To: <20261118001641.GA1669148@ZenIV>

On Wed, Nov 18, 2026 at 12:16:41AM +0000, Al Viro wrote:
> On Tue, Nov 17, 2026 at 06:43:42PM +0000, Al Viro wrote:
> > > + * Hooks that take a struct path argument: the VFS only sanctions passing
> > > + * the path to VFS helpers that take a struct path (e.g. notify_change());
> > > + * it makes no guarantees with regard to path->mnt, whose layout and
> > > + * implementation details are subject to change.  Implementations must
> > > + * not rely on its properties.

That comment is a garbled version of an earlier review. It meant that
LSMs get no guarantees about struct vfsmount internals and don't get to
poke at them. I'm not sure how this can be read as path->mnt being a
random mount.

> > If that kind of stuff actually does get passed to any existing hooks, we need
> > to fix that ASAP.

Of course there is one...

  dent = lookup_one_unlocked(idmap, &QSTR_LEN(...),
                             priv->dir_fp->filp->f_path.dentry);
  [...].
  rc = ksmbd_vfs_fill_dentry_attrs(priv->work, idmap, dent, &ksmbd_kstat);

It passes only the bare dentry, and ksmbd_vfs_fill_dentry_attrs() then
makes up a path from the share's root mount:

  struct path path = {
          .mnt = share_conf->vfs_path.mnt,   /* mount the share is exported from */
          .dentry = dentry,                  /* entry inside the listed dir */
  };
  rc = vfs_getattr(&path, ...);

since 5614c8c487f6 ("ksmbd: replace generic_fillattr with vfs_getattr").

So a client that lists a directory on a submount below the share then
that dentry belongs to another superblock. So security_inode_getattr()
and ->getattr() get a mixed path.

The third patch in this series fixes this. But we should make this a
Fixes: patch really... Something like [1].

> To elaborate a bit: correctness of quite a few places does depend upon the
> following invaraint:
> 	path->mnt->mnt_sb == path->dentry->d_sb		(1)
> for all struct path pointers they might possibly run into.
>
> _IF_ you can guarantee that (1) is not violated, we have something to
> talk about; otherwise, don't call your object struct path and don't
> pass it to anything that expects to deal with struct path.

Every struct path the series constructs:

  - devtmpfs
  - nfsd
  - cachefiles
  - ecryptfs
  - overlayfs
  - ksmbd

doesn't have this bug.

[1]:

  --- a/fs/smb/server/smb2pdu.c
  +++ b/fs/smb/server/smb2pdu.c
  @@ -6375,13 +6375,14 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
                          continue;
                  }

  +               path.mnt = priv->dir_fp->filp->f_path.mnt;
  +               path.dentry = dent;
  +
                  if (test_share_config_flag(priv->work->tcon->share_conf,
                                             KSMBD_SHARE_FLAG_HIDE_UNREADABLE)) {
                          __le32 daccess = FILE_READ_DATA_LE | FILE_READ_EA_LE |
                                  FILE_READ_ATTRIBUTES_LE;

  -                       path.mnt = priv->dir_fp->filp->f_path.mnt;
  -                       path.dentry = dent;
                          rc = smb_check_perm_dacl(priv->work->conn, &path,
                                                   &daccess, daccess,
                                                   priv->work->sess->user->uid,
  @@ -6397,7 +6398,7 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
  @@ -6397,7 +6398,7 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
                  if (priv->info_level != FILE_NAMES_INFORMATION) {
                          rc = ksmbd_vfs_fill_dentry_attrs(priv->work,
                                                           idmap,
  -                                                        dent,
  +                                                        &path,
                                                           &ksmbd_kstat);
                          if (rc) {
                                  dput(dent);
  --- a/fs/smb/server/smb_common.c
  +++ b/fs/smb/server/smb_common.c
  @@ -472,32 +472,36 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
          for (i = 0; i < 2; i++) {
                  struct kstat kstat;
                  struct ksmbd_kstat ksmbd_kstat;
  -               struct dentry *dentry;
  +               struct path path = { .mnt = dir->filp->f_path.mnt };

                  if (!dir->dot_dotdot[i]) { /* fill dot entry info */
                          if (i == 0) {
                                  d_info->name = ".";
                                  d_info->name_len = 1;
  -                               dentry = dget(dir->filp->f_path.dentry);
  +                               path.dentry = dget(dir->filp->f_path.dentry);
                          } else {
                                  d_info->name = "..";
                                  d_info->name_len = 2;
  -                               dentry = dget_parent(dir->filp->f_path.dentry);
  +                               /*
  +                                * The parent never leaves the superblock, so
  +                                * the directory's mount stays consistent with it.
  +                                */
  +                               path.dentry = dget_parent(dir->filp->f_path.dentry);
                          }

                          if (!match_pattern(d_info->name, d_info->name_len,
                                             search_pattern)) {
                                  dir->dot_dotdot[i] = 1;
  -                               dput(dentry);
  +                               dput(path.dentry);
                                  continue;
                          }

                          ksmbd_kstat.kstat = &kstat;
                          rc = ksmbd_vfs_fill_dentry_attrs(work,
                                                           idmap,
  -                                                        dentry,
  +                                                        &path,
                                                           &ksmbd_kstat);
  -                       dput(dentry);
  +                       dput(path.dentry);
                          if (rc)
                                  break;

  --- a/fs/smb/server/vfs.c
  +++ b/fs/smb/server/vfs.c
  @@ -1897,18 +1897,14 @@

   int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
                                  const struct mnt_idmap *idmap,
  -                               struct dentry *dentry,
  +                               const struct path *path,
                                  struct ksmbd_kstat *ksmbd_kstat)
   {
  -       struct ksmbd_share_config *share_conf = work->tcon->share_conf;
  +       struct dentry *dentry = path->dentry;
          u64 time;
          int rc;
  -       struct path path = {
  -               .mnt = share_conf->vfs_path.mnt,
  -               .dentry = dentry,
  -       };

  -       rc = vfs_getattr(&path, ksmbd_kstat->kstat,
  +       rc = vfs_getattr(path, ksmbd_kstat->kstat,
                           STATX_BASIC_STATS | STATX_BTIME,
                           AT_STATX_SYNC_AS_STAT);
          if (rc)
  --- a/fs/smb/server/vfs.h
  +++ b/fs/smb/server/vfs.h
  @@ -154,7 +154,7 @@ void *ksmbd_vfs_init_kstat(char **p, struct ksmbd_kstat *ksmbd_kstat);
   int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
                                  const struct mnt_idmap *idmap,
                                  const struct path *path,
                                  struct ksmbd_kstat *ksmbd_kstat);

