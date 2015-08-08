Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD6987F51
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 20:33:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE0FD304043
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 18:33:20 -0700 (PDT)
Received: from h2.hallyn.com (h2.hallyn.com [78.46.35.8]) by cuda.sgi.com with
	ESMTP id 72PHTe05U7v0XHkk (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 18:33:18 -0700 (PDT)
Date: Fri, 7 Aug 2015 20:33:16 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] fs: create and use seq_show_option for escaping
Message-ID: <20150808013316.GA22864@mail.hallyn.com>
References: <20150807234150.GA11735@www.outflux.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150807234150.GA11735@www.outflux.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Kees Cook <keescook@chromium.org>
Cc: Firo Yang <firogm@gmail.com>, David Howells <dhowells@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jiri Slaby <jslaby@suse.cz>, Christoph Hellwig <hch@lst.de>, "Yan, Zheng" <zyan@redhat.com>, Paul Moore <paul@paul-moore.com>, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard@nod.at>, Ilya Dryomov <idryomov@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>, "Serge E. Hallyn" <serge@hallyn.com>, Mark Fasheh <mfasheh@suse.com>, Jeff Dike <jdike@addtoit.com>, Jan Kara <jack@suse.com>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, Bob Peterson <rpeterso@redhat.com>, Joel Becker <jlbec@evilplan.org>, James Morris <james.l.morris@oracle.com>, Eric Paris <eparis@parisplace.org>, Steven Whitehouse <swhiteho@redhat.com>, Fabian Frederick <fabf@skynet.be>, Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Al Viro <viro@zeniv.linux.org.uk>

On Fri, Aug 07, 2015 at 04:41:50PM -0700, Kees Cook wrote:
> Many file systems that implement the show_options hook fail to correctly
> escape their output which could lead to unescaped characters (e.g. new
> lines) leaking into /proc/mounts and /proc/[pid]/mountinfo files. This
> could lead to confusion, spoofed entries (resulting in things like
> systemd issuing false d-bus "mount" notifications), and who knows
> what else. This looks like it would only be the root user stepping on
> themselves, but it's possible weird things could happen in containers
> or in other situations with delegated mount privileges.
> 
> Here's an example using overlay with setuid fusermount trusting the
> contents of /proc/mounts (via the /etc/mtab symlink). Imagine the use of
> "sudo" is something more sneaky:
> 
> $ BASE="ovl"
> $ MNT="$BASE/mnt"
> $ LOW="$BASE/lower"
> $ UP="$BASE/upper"
> $ WORK="$BASE/work/ 0 0
> none /proc fuse.pwn user_id=1000"
> $ mkdir -p "$LOW" "$UP" "$WORK"
> $ sudo mount -t overlay -o "lowerdir=$LOW,upperdir=$UP,workdir=$WORK" none /mnt
> $ cat /proc/mounts
> none /root/ovl/mnt overlay rw,relatime,lowerdir=ovl/lower,upperdir=ovl/upper,workdir=ovl/work/ 0 0
> none /proc fuse.pwn user_id=1000 0 0
> $ fusermount -u /proc
> $ cat /proc/mounts
> cat: /proc/mounts: No such file or directory
> 
> This fixes the problem by adding new seq_show_option and seq_show_option_n
> helpers, and updating the vulnerable show_option handlers to use them as
> needed. Some, like SELinux, need to be open coded due to unusual existing
> escape mechanisms.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  fs/ceph/super.c          |  2 +-
>  fs/cifs/cifsfs.c         |  6 +++---
>  fs/ext3/super.c          |  4 ++--
>  fs/ext4/super.c          |  4 ++--
>  fs/gfs2/super.c          |  6 +++---
>  fs/hfs/super.c           |  4 ++--
>  fs/hfsplus/options.c     |  4 ++--
>  fs/hostfs/hostfs_kern.c  |  2 +-
>  fs/ocfs2/super.c         |  4 ++--
>  fs/overlayfs/super.c     |  6 +++---
>  fs/reiserfs/super.c      |  8 +++++---
>  fs/xfs/xfs_super.c       |  4 ++--
>  include/linux/seq_file.h | 34 ++++++++++++++++++++++++++++++++++
>  kernel/cgroup.c          |  7 ++++---
>  net/ceph/ceph_common.c   |  7 +++++--
>  security/selinux/hooks.c |  2 +-
>  16 files changed, 72 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index d1c833c321b9..7b6bfcbf801c 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -479,7 +479,7 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>  	if (fsopt->max_readdir_bytes != CEPH_MAX_READDIR_BYTES_DEFAULT)
>  		seq_printf(m, ",readdir_max_bytes=%d", fsopt->max_readdir_bytes);
>  	if (strcmp(fsopt->snapdir_name, CEPH_SNAPDIRNAME_DEFAULT))
> -		seq_printf(m, ",snapdirname=%s", fsopt->snapdir_name);
> +		seq_show_option(m, "snapdirname", fsopt->snapdir_name);
>  
>  	return 0;
>  }
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 0a9fb6b53126..6a1119e87fbb 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -394,17 +394,17 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>  	struct sockaddr *srcaddr;
>  	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
>  
> -	seq_printf(s, ",vers=%s", tcon->ses->server->vals->version_string);
> +	seq_show_option(s, "vers", tcon->ses->server->vals->version_string);
>  	cifs_show_security(s, tcon->ses);
>  	cifs_show_cache_flavor(s, cifs_sb);
>  
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
>  		seq_puts(s, ",multiuser");
>  	else if (tcon->ses->user_name)
> -		seq_printf(s, ",username=%s", tcon->ses->user_name);
> +		seq_show_option(s, "username", tcon->ses->user_name);
>  
>  	if (tcon->ses->domainName)
> -		seq_printf(s, ",domain=%s", tcon->ses->domainName);
> +		seq_show_option(s, "domain", tcon->ses->domainName);
>  
>  	if (srcaddr->sa_family != AF_UNSPEC) {
>  		struct sockaddr_in *saddr4;
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 5ed0044fbb37..e9312494f3ee 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -578,10 +578,10 @@ static inline void ext3_show_quota_options(struct seq_file *seq, struct super_bl
>  	}
>  
>  	if (sbi->s_qf_names[USRQUOTA])
> -		seq_printf(seq, ",usrjquota=%s", sbi->s_qf_names[USRQUOTA]);
> +		seq_show_option(seq, "usrjquota", sbi->s_qf_names[USRQUOTA]);
>  
>  	if (sbi->s_qf_names[GRPQUOTA])
> -		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
> +		seq_show_option(seq, "grpjquota", sbi->s_qf_names[GRPQUOTA]);
>  
>  	if (test_opt(sb, USRQUOTA))
>  		seq_puts(seq, ",usrquota");
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 58987b5c514b..9981064c4a54 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1763,10 +1763,10 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
>  	}
>  
>  	if (sbi->s_qf_names[USRQUOTA])
> -		seq_printf(seq, ",usrjquota=%s", sbi->s_qf_names[USRQUOTA]);
> +		seq_show_option(seq, "usrjquota", sbi->s_qf_names[USRQUOTA]);
>  
>  	if (sbi->s_qf_names[GRPQUOTA])
> -		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
> +		seq_show_option(seq, "grpjquota", sbi->s_qf_names[GRPQUOTA]);
>  #endif
>  }
>  
> diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> index 2982445947e1..894fb01a91da 100644
> --- a/fs/gfs2/super.c
> +++ b/fs/gfs2/super.c
> @@ -1334,11 +1334,11 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
>  	if (is_ancestor(root, sdp->sd_master_dir))
>  		seq_puts(s, ",meta");
>  	if (args->ar_lockproto[0])
> -		seq_printf(s, ",lockproto=%s", args->ar_lockproto);
> +		seq_show_option(s, "lockproto", args->ar_lockproto);
>  	if (args->ar_locktable[0])
> -		seq_printf(s, ",locktable=%s", args->ar_locktable);
> +		seq_show_option(s, "locktable", args->ar_locktable);
>  	if (args->ar_hostdata[0])
> -		seq_printf(s, ",hostdata=%s", args->ar_hostdata);
> +		seq_show_option(s, "hostdata", args->ar_hostdata);
>  	if (args->ar_spectator)
>  		seq_puts(s, ",spectator");
>  	if (args->ar_localflocks)
> diff --git a/fs/hfs/super.c b/fs/hfs/super.c
> index 55c03b9e9070..4574fdd3d421 100644
> --- a/fs/hfs/super.c
> +++ b/fs/hfs/super.c
> @@ -136,9 +136,9 @@ static int hfs_show_options(struct seq_file *seq, struct dentry *root)
>  	struct hfs_sb_info *sbi = HFS_SB(root->d_sb);
>  
>  	if (sbi->s_creator != cpu_to_be32(0x3f3f3f3f))
> -		seq_printf(seq, ",creator=%.4s", (char *)&sbi->s_creator);
> +		seq_show_option_n(seq, "creator", (char *)&sbi->s_creator, 4);
>  	if (sbi->s_type != cpu_to_be32(0x3f3f3f3f))
> -		seq_printf(seq, ",type=%.4s", (char *)&sbi->s_type);
> +		seq_show_option_n(seq, "type", (char *)&sbi->s_type, 4);
>  	seq_printf(seq, ",uid=%u,gid=%u",
>  			from_kuid_munged(&init_user_ns, sbi->s_uid),
>  			from_kgid_munged(&init_user_ns, sbi->s_gid));
> diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
> index c90b72ee676d..bb806e58c977 100644
> --- a/fs/hfsplus/options.c
> +++ b/fs/hfsplus/options.c
> @@ -218,9 +218,9 @@ int hfsplus_show_options(struct seq_file *seq, struct dentry *root)
>  	struct hfsplus_sb_info *sbi = HFSPLUS_SB(root->d_sb);
>  
>  	if (sbi->creator != HFSPLUS_DEF_CR_TYPE)
> -		seq_printf(seq, ",creator=%.4s", (char *)&sbi->creator);
> +		seq_show_option_n(seq, "creator", (char *)&sbi->creator, 4);
>  	if (sbi->type != HFSPLUS_DEF_CR_TYPE)
> -		seq_printf(seq, ",type=%.4s", (char *)&sbi->type);
> +		seq_show_option_n(seq, "type", (char *)&sbi->type, 4);
>  	seq_printf(seq, ",umask=%o,uid=%u,gid=%u", sbi->umask,
>  			from_kuid_munged(&init_user_ns, sbi->uid),
>  			from_kgid_munged(&init_user_ns, sbi->gid));
> diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
> index 059597b23f67..2ac99db3750e 100644
> --- a/fs/hostfs/hostfs_kern.c
> +++ b/fs/hostfs/hostfs_kern.c
> @@ -260,7 +260,7 @@ static int hostfs_show_options(struct seq_file *seq, struct dentry *root)
>  	size_t offset = strlen(root_ino) + 1;
>  
>  	if (strlen(root_path) > offset)
> -		seq_printf(seq, ",%s", root_path + offset);
> +		seq_show_option(seq, root_path + offset, NULL);
>  
>  	if (append)
>  		seq_puts(seq, ",append");
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 403c5660b306..a482e312c7b2 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1550,8 +1550,8 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
>  		seq_printf(s, ",localflocks,");
>  
>  	if (osb->osb_cluster_stack[0])
> -		seq_printf(s, ",cluster_stack=%.*s", OCFS2_STACK_LABEL_LEN,
> -			   osb->osb_cluster_stack);
> +		seq_show_option_n(s, "cluster_stack", osb->osb_cluster_stack,
> +				  OCFS2_STACK_LABEL_LEN);
>  	if (opts & OCFS2_MOUNT_USRQUOTA)
>  		seq_printf(s, ",usrquota");
>  	if (opts & OCFS2_MOUNT_GRPQUOTA)
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 7466ff339c66..79073d68b475 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -588,10 +588,10 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>  	struct super_block *sb = dentry->d_sb;
>  	struct ovl_fs *ufs = sb->s_fs_info;
>  
> -	seq_printf(m, ",lowerdir=%s", ufs->config.lowerdir);
> +	seq_show_option(m, "lowerdir", ufs->config.lowerdir);
>  	if (ufs->config.upperdir) {
> -		seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
> -		seq_printf(m, ",workdir=%s", ufs->config.workdir);
> +		seq_show_option(m, "upperdir", ufs->config.upperdir);
> +		seq_show_option(m, "workdir", ufs->config.workdir);
>  	}
>  	return 0;
>  }
> diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
> index 0e4cf728126f..4a62fe8cc3bf 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -714,18 +714,20 @@ static int reiserfs_show_options(struct seq_file *seq, struct dentry *root)
>  		seq_puts(seq, ",acl");
>  
>  	if (REISERFS_SB(s)->s_jdev)
> -		seq_printf(seq, ",jdev=%s", REISERFS_SB(s)->s_jdev);
> +		seq_show_option(seq, "jdev", REISERFS_SB(s)->s_jdev);
>  
>  	if (journal->j_max_commit_age != journal->j_default_max_commit_age)
>  		seq_printf(seq, ",commit=%d", journal->j_max_commit_age);
>  
>  #ifdef CONFIG_QUOTA
>  	if (REISERFS_SB(s)->s_qf_names[USRQUOTA])
> -		seq_printf(seq, ",usrjquota=%s", REISERFS_SB(s)->s_qf_names[USRQUOTA]);
> +		seq_show_option(seq, "usrjquota",
> +				REISERFS_SB(s)->s_qf_names[USRQUOTA]);
>  	else if (opts & (1 << REISERFS_USRQUOTA))
>  		seq_puts(seq, ",usrquota");
>  	if (REISERFS_SB(s)->s_qf_names[GRPQUOTA])
> -		seq_printf(seq, ",grpjquota=%s", REISERFS_SB(s)->s_qf_names[GRPQUOTA]);
> +		seq_show_option(seq, "grpjquota",
> +				REISERFS_SB(s)->s_qf_names[GRPQUOTA]);
>  	else if (opts & (1 << REISERFS_GRPQUOTA))
>  		seq_puts(seq, ",grpquota");
>  	if (REISERFS_SB(s)->s_jquota_fmt) {
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1fb16562c159..bbd9b1f10ffb 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -511,9 +511,9 @@ xfs_showargs(
>  		seq_printf(m, "," MNTOPT_LOGBSIZE "=%dk", mp->m_logbsize >> 10);
>  
>  	if (mp->m_logname)
> -		seq_printf(m, "," MNTOPT_LOGDEV "=%s", mp->m_logname);
> +		seq_show_option(m, MNTOPT_LOGDEV, mp->m_logname);
>  	if (mp->m_rtname)
> -		seq_printf(m, "," MNTOPT_RTDEV "=%s", mp->m_rtname);
> +		seq_show_option(m, MNTOPT_RTDEV, mp->m_rtname);
>  
>  	if (mp->m_dalign > 0)
>  		seq_printf(m, "," MNTOPT_SUNIT "=%d",
> diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
> index 912a7c482649..ff4c631348dd 100644
> --- a/include/linux/seq_file.h
> +++ b/include/linux/seq_file.h
> @@ -149,6 +149,40 @@ static inline struct user_namespace *seq_user_ns(struct seq_file *seq)
>  #endif
>  }
>  
> +/**
> + * seq_show_options - display mount options with appropriate escapes.
> + * @m: the seq_file handle
> + * @name: the mount option name
> + * @value: the mount option name's value, can be NULL
> + */
> +static inline void seq_show_option(struct seq_file *m, char *name, char *value)
> +{
> +	seq_putc(m, ',');
> +	seq_escape(m, name, ",= \t\n\\");
> +	if (value) {
> +		seq_putc(m, '=');
> +		seq_escape(m, value, ", \t\n\\");
> +	}
> +}
> +
> +/**
> + * seq_show_option_n - display mount options with appropriate escapes
> + *		       where @value must be a specific length.
> + * @m: the seq_file handle
> + * @name: the mount option name
> + * @value: the mount option name's value, cannot be NULL
> + * @length: the length of @value to display
> + *
> + * This is a macro since this uses "length" to define the size of the
> + * stack buffer.
> + */
> +#define seq_show_option_n(m, name, value, length) {	\
> +	char val_buf[length + 1];			\
> +	strncpy(val_buf, value, length);		\
> +	val_buf[length] = '\0';				\
> +	seq_show_option(m, name, val_buf);		\
> +}
> +
>  #define SEQ_START_TOKEN ((void *)1)
>  /*
>   * Helpers for iteration over list_head-s in seq_files
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f89d9292eee6..c6c4240e7d28 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1334,7 +1334,7 @@ static int cgroup_show_options(struct seq_file *seq,
>  
>  	for_each_subsys(ss, ssid)
>  		if (root->subsys_mask & (1 << ssid))
> -			seq_printf(seq, ",%s", ss->name);
> +			seq_show_option(seq, ss->name, NULL);
>  	if (root->flags & CGRP_ROOT_NOPREFIX)
>  		seq_puts(seq, ",noprefix");
>  	if (root->flags & CGRP_ROOT_XATTR)
> @@ -1342,13 +1342,14 @@ static int cgroup_show_options(struct seq_file *seq,
>  
>  	spin_lock(&release_agent_path_lock);
>  	if (strlen(root->release_agent_path))
> -		seq_printf(seq, ",release_agent=%s", root->release_agent_path);
> +		seq_show_option(seq, "release_agent",
> +				root->release_agent_path);
>  	spin_unlock(&release_agent_path_lock);
>  
>  	if (test_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags))
>  		seq_puts(seq, ",clone_children");
>  	if (strlen(root->name))
> -		seq_printf(seq, ",name=%s", root->name);
> +		seq_show_option(seq, "name", root->name);
>  	return 0;
>  }
>  
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index f30329f72641..b2197e17a742 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -517,8 +517,11 @@ int ceph_print_client_options(struct seq_file *m, struct ceph_client *client)
>  	struct ceph_options *opt = client->options;
>  	size_t pos = m->count;
>  
> -	if (opt->name)
> -		seq_printf(m, "name=%s,", opt->name);
> +	if (opt->name) {
> +		seq_puts(m, "name=");
> +		seq_escape(m, opt->name, ", \t\n\\");
> +		seq_putc(',');
> +	}
>  	if (opt->key)
>  		seq_puts(m, "secret=<hidden>,");
>  
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 564079c5c49d..cdf4c589a391 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1100,7 +1100,7 @@ static void selinux_write_opts(struct seq_file *m,
>  		seq_puts(m, prefix);
>  		if (has_comma)
>  			seq_putc(m, '\"');
> -		seq_puts(m, opts->mnt_opts[i]);
> +		seq_escape(m, opts->mnt_opts[i], "\"\n\\");
>  		if (has_comma)
>  			seq_putc(m, '\"');
>  	}
> -- 
> 1.9.1
> 
> 
> -- 
> Kees Cook
> Chrome OS Security

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
