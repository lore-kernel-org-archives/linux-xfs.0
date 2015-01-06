Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 10E2E7F76
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:25:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FCAAAC005
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 09:25:13 -0800 (PST)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id ikhCcfv178ETdCBK (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 09:25:11 -0800 (PST)
Date: Tue, 6 Jan 2015 12:25:08 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 10/18] nfsd: implement pNFS layout recalls
Message-ID: <20150106172508.GE12067@fieldses.org>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-11-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420561721-9150-11-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 05:28:33PM +0100, Christoph Hellwig wrote:
> Add support to issue layout recalls to clients.  For now we only support
> full-file recalls to get a simple and stable implementation.  This allows
> to embedd a nfsd4_callback structure in the layout_state and thus avoid
> any memory allocations under spinlocks during a recall.  For normal
> use cases that do not intent to share a single file between multiple
> clients this implementation is fully sufficient.
> 
> To ensure layouts are recalled on local filesystem access each layout
> state registers a new FL_LAYOUT lease with the kernel file locking code,
> which filesystems that support pNFS exports that require recalls need
> to break on conflicting access patterns.
> 
> The XDR code is based on the old pNFS server implementation by
> Andy Adamson, Benny Halevy, Boaz Harrosh, Dean Hildebrand, Fred Isaman,
> Marc Eshel, Mike Sager and Ricardo Labiaga.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/nfsd/nfs4callback.c |  99 +++++++++++++++++++++++
>  fs/nfsd/nfs4layouts.c  | 214 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/nfsd/nfs4proc.c     |   4 +
>  fs/nfsd/nfs4state.c    |   1 +
>  fs/nfsd/state.h        |   6 ++
>  fs/nfsd/xdr4cb.h       |   7 ++
>  6 files changed, 330 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
> index 7cbdf1b..5827785 100644
> --- a/fs/nfsd/nfs4callback.c
> +++ b/fs/nfsd/nfs4callback.c
> @@ -546,6 +546,102 @@ out:
>  	return status;
>  }
>  
> +#ifdef CONFIG_NFSD_PNFS
> +/*
> + * CB_LAYOUTRECALL4args
> + *
> + *	struct layoutrecall_file4 {
> + *		nfs_fh4         lor_fh;
> + *		offset4         lor_offset;
> + *		length4         lor_length;
> + *		stateid4        lor_stateid;
> + *	};
> + *
> + *	union layoutrecall4 switch(layoutrecall_type4 lor_recalltype) {
> + *	case LAYOUTRECALL4_FILE:
> + *		layoutrecall_file4 lor_layout;
> + *	case LAYOUTRECALL4_FSID:
> + *		fsid4              lor_fsid;
> + *	case LAYOUTRECALL4_ALL:
> + *		void;
> + *	};
> + *
> + *	struct CB_LAYOUTRECALL4args {
> + *		layouttype4             clora_type;
> + *		layoutiomode4           clora_iomode;
> + *		bool                    clora_changed;
> + *		layoutrecall4           clora_recall;
> + *	};
> + */
> +static void encode_cb_layout4args(struct xdr_stream *xdr,
> +				  const struct nfs4_layout_stateid *ls,
> +				  struct nfs4_cb_compound_hdr *hdr)
> +{
> +	__be32 *p;
> +
> +	BUG_ON(hdr->minorversion == 0);
> +
> +	p = xdr_reserve_space(xdr, 5 * 4);
> +	*p++ = cpu_to_be32(OP_CB_LAYOUTRECALL);
> +	*p++ = cpu_to_be32(ls->ls_layout_type);
> +	*p++ = cpu_to_be32(IOMODE_ANY);
> +	*p++ = cpu_to_be32(1);
> +	*p = cpu_to_be32(RETURN_FILE);
> +
> +	encode_nfs_fh4(xdr, &ls->ls_stid.sc_file->fi_fhandle);
> +
> +	p = xdr_reserve_space(xdr, 2 * 8);
> +	p = xdr_encode_hyper(p, 0);
> +	xdr_encode_hyper(p, NFS4_MAX_UINT64);
> +
> +	encode_stateid4(xdr, &ls->ls_recall_sid);
> +
> +	hdr->nops++;
> +}
> +
> +static void nfs4_xdr_enc_cb_layout(struct rpc_rqst *req,
> +				   struct xdr_stream *xdr,
> +				   const struct nfsd4_callback *cb)
> +{
> +	const struct nfs4_layout_stateid *ls =
> +		container_of(cb, struct nfs4_layout_stateid, ls_recall);
> +	struct nfs4_cb_compound_hdr hdr = {
> +		.ident = 0,
> +		.minorversion = cb->cb_minorversion,
> +	};
> +
> +	encode_cb_compound4args(xdr, &hdr);
> +	encode_cb_sequence4args(xdr, cb, &hdr);
> +	encode_cb_layout4args(xdr, ls, &hdr);
> +	encode_cb_nops(&hdr);
> +}
> +
> +static int nfs4_xdr_dec_cb_layout(struct rpc_rqst *rqstp,
> +				  struct xdr_stream *xdr,
> +				  struct nfsd4_callback *cb)
> +{
> +	struct nfs4_cb_compound_hdr hdr;
> +	enum nfsstat4 nfserr;
> +	int status;
> +
> +	status = decode_cb_compound4res(xdr, &hdr);
> +	if (unlikely(status))
> +		goto out;
> +	if (cb) {
> +		status = decode_cb_sequence4res(xdr, cb);
> +		if (unlikely(status))
> +			goto out;
> +	}
> +	status = decode_cb_op_status(xdr, OP_CB_LAYOUTRECALL, &nfserr);
> +	if (unlikely(status))
> +		goto out;
> +	if (unlikely(nfserr != NFS4_OK))
> +		status = nfs_cb_stat_to_errno(nfserr);
> +out:
> +	return status;
> +}
> +#endif /* CONFIG_NFSD_PNFS */
> +
>  /*
>   * RPC procedure tables
>   */
> @@ -563,6 +659,9 @@ out:
>  static struct rpc_procinfo nfs4_cb_procedures[] = {
>  	PROC(CB_NULL,	NULL,		cb_null,	cb_null),
>  	PROC(CB_RECALL,	COMPOUND,	cb_recall,	cb_recall),
> +#ifdef CONFIG_NFSD_PNFS
> +	PROC(CB_LAYOUT,	COMPOUND,	cb_layout,	cb_layout),
> +#endif
>  };
>  
>  static struct rpc_version nfs_cb_version4 = {
> diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
> index 0753ed8..72a12ca 100644
> --- a/fs/nfsd/nfs4layouts.c
> +++ b/fs/nfsd/nfs4layouts.c
> @@ -1,8 +1,11 @@
>  /*
>   * Copyright (c) 2014 Christoph Hellwig.
>   */
> +#include <linux/kmod.h>
> +#include <linux/file.h>
>  #include <linux/jhash.h>
>  #include <linux/sched.h>
> +#include <linux/sunrpc/addr.h>
>  
>  #include "pnfs.h"
>  #include "netns.h"
> @@ -18,6 +21,9 @@ struct nfs4_layout {
>  static struct kmem_cache *nfs4_layout_cache;
>  static struct kmem_cache *nfs4_layout_stateid_cache;
>  
> +static struct nfsd4_callback_ops nfsd4_cb_layout_ops;
> +static const struct lock_manager_operations nfsd4_layouts_lm_ops;
> +
>  const struct nfsd4_layout_ops *nfsd4_layout_ops[LAYOUT_TYPE_MAX] =  {
>  };
>  
> @@ -126,9 +132,42 @@ nfsd4_free_layout_stateid(struct nfs4_stid *stid)
>  	list_del_init(&ls->ls_perfile);
>  	spin_unlock(&fp->fi_lock);
>  
> +	vfs_setlease(ls->ls_file, F_UNLCK, NULL, (void **)&ls);
> +	fput(ls->ls_file);
> +
> +	if (ls->ls_recalled)
> +		atomic_dec(&ls->ls_stid.sc_file->fi_lo_recalls);
> +
>  	kmem_cache_free(nfs4_layout_stateid_cache, ls);
>  }
>  
> +static int
> +nfsd4_layout_setlease(struct nfs4_layout_stateid *ls)
> +{
> +	struct file_lock *fl;
> +	int status;
> +
> +	fl = locks_alloc_lock();
> +	if (!fl)
> +		return -ENOMEM;
> +	locks_init_lock(fl);
> +	fl->fl_lmops = &nfsd4_layouts_lm_ops;
> +	fl->fl_flags = FL_LAYOUT;
> +	fl->fl_type = F_RDLCK;
> +	fl->fl_end = OFFSET_MAX;
> +	fl->fl_owner = ls;
> +	fl->fl_pid = current->tgid;
> +	fl->fl_file = ls->ls_file;
> +
> +	status = vfs_setlease(fl->fl_file, fl->fl_type, &fl, NULL);
> +	if (status) {
> +		locks_free_lock(fl);
> +		return status;
> +	}
> +	BUG_ON(fl != NULL);
> +	return 0;
> +}
> +
>  static struct nfs4_layout_stateid *
>  nfsd4_alloc_layout_stateid(struct nfsd4_compound_state *cstate,
>  		struct nfs4_stid *parent, u32 layout_type)
> @@ -151,6 +190,20 @@ nfsd4_alloc_layout_stateid(struct nfsd4_compound_state *cstate,
>  	spin_lock_init(&ls->ls_lock);
>  	INIT_LIST_HEAD(&ls->ls_layouts);
>  	ls->ls_layout_type = layout_type;
> +	nfsd4_init_cb(&ls->ls_recall, clp, &nfsd4_cb_layout_ops,
> +			NFSPROC4_CLNT_CB_LAYOUT);
> +
> +	if (parent->sc_type == NFS4_DELEG_STID)
> +		ls->ls_file = get_file(fp->fi_deleg_file);
> +	else
> +		ls->ls_file = find_any_file(fp);
> +	BUG_ON(!ls->ls_file);
> +
> +	if (nfsd4_layout_setlease(ls)) {
> +		put_nfs4_file(fp);
> +		kmem_cache_free(nfs4_layout_stateid_cache, ls);
> +		return NULL;
> +	}
>  
>  	spin_lock(&clp->cl_lock);
>  	stp->sc_type = NFS4_LAYOUT_STID;
> @@ -214,6 +267,27 @@ out:
>  	return status;
>  }
>  
> +static void
> +nfsd4_recall_file_layout(struct nfs4_layout_stateid *ls)
> +{
> +	spin_lock(&ls->ls_lock);
> +	if (ls->ls_recalled)
> +		goto out_unlock;
> +
> +	ls->ls_recalled = true;
> +	atomic_inc(&ls->ls_stid.sc_file->fi_lo_recalls);
> +	if (list_empty(&ls->ls_layouts))
> +		goto out_unlock;
> +
> +	atomic_inc(&ls->ls_stid.sc_count);
> +	update_stateid(&ls->ls_stid.sc_stateid);
> +	memcpy(&ls->ls_recall_sid, &ls->ls_stid.sc_stateid, sizeof(stateid_t));
> +	nfsd4_run_cb(&ls->ls_recall);
> +
> +out_unlock:
> +	spin_unlock(&ls->ls_lock);
> +}
> +
>  static inline u64
>  layout_end(struct nfsd4_layout_seg *seg)
>  {
> @@ -257,18 +331,44 @@ layouts_try_merge(struct nfsd4_layout_seg *lo, struct nfsd4_layout_seg *new)
>  	return true;
>  }
>  
> +static __be32
> +nfsd4_recall_conflict(struct nfs4_layout_stateid *ls)
> +{
> +	struct nfs4_file *fp = ls->ls_stid.sc_file;
> +	struct nfs4_layout_stateid *l, *n;
> +	__be32 nfserr = nfs_ok;
> +
> +	assert_spin_locked(&fp->fi_lock);
> +
> +	list_for_each_entry_safe(l, n, &fp->fi_lo_states, ls_perfile) {
> +		if (l != ls) {
> +			nfsd4_recall_file_layout(l);
> +			nfserr = nfserr_recallconflict;
> +		}
> +	}
> +
> +	return nfserr;
> +}
> +
>  __be32
>  nfsd4_insert_layout(struct nfsd4_layoutget *lgp, struct nfs4_layout_stateid *ls)
>  {
>  	struct nfsd4_layout_seg *seg = &lgp->lg_seg;
> +	struct nfs4_file *fp = ls->ls_stid.sc_file;
>  	struct nfs4_layout *lp, *new = NULL;
> +	__be32 nfserr;
>  
> +	spin_lock(&fp->fi_lock);
> +	nfserr = nfsd4_recall_conflict(ls);
> +	if (nfserr)
> +		goto out;
>  	spin_lock(&ls->ls_lock);
>  	list_for_each_entry(lp, &ls->ls_layouts, lo_perstate) {
>  		if (layouts_try_merge(&lp->lo_seg, seg))
>  			goto done;
>  	}
>  	spin_unlock(&ls->ls_lock);
> +	spin_unlock(&fp->fi_lock);
>  
>  	new = kmem_cache_alloc(nfs4_layout_cache, GFP_KERNEL);
>  	if (!new)
> @@ -276,6 +376,10 @@ nfsd4_insert_layout(struct nfsd4_layoutget *lgp, struct nfs4_layout_stateid *ls)
>  	memcpy(&new->lo_seg, seg, sizeof(lp->lo_seg));
>  	new->lo_state = ls;
>  
> +	spin_lock(&fp->fi_lock);
> +	nfserr = nfsd4_recall_conflict(ls);
> +	if (nfserr)
> +		goto out;
>  	spin_lock(&ls->ls_lock);
>  	list_for_each_entry(lp, &ls->ls_layouts, lo_perstate) {
>  		if (layouts_try_merge(&lp->lo_seg, seg))
> @@ -289,9 +393,11 @@ done:
>  	update_stateid(&ls->ls_stid.sc_stateid);
>  	memcpy(&lgp->lg_sid, &ls->ls_stid.sc_stateid, sizeof(stateid_t));
>  	spin_unlock(&ls->ls_lock);
> +out:
> +	spin_unlock(&fp->fi_lock);
>  	if (new)
>  		kmem_cache_free(nfs4_layout_cache, new);
> -	return nfs_ok;
> +	return nfserr;
>  }
>  
>  static void
> @@ -447,6 +553,112 @@ nfsd4_return_all_file_layouts(struct nfs4_client *clp, struct nfs4_file *fp)
>  	nfsd4_free_layouts(&reaplist);
>  }
>  
> +static void
> +nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
> +{
> +	struct nfs4_client *clp = ls->ls_stid.sc_client;
> +	char addr_str[INET6_ADDRSTRLEN];
> +	static char *envp[] = {
> +		"HOME=/",
> +		"TERM=linux",
> +		"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
> +		NULL
> +	};
> +	char *argv[8];
> +	int error;
> +
> +	rpc_ntop((struct sockaddr *)&clp->cl_addr, addr_str, sizeof(addr_str));

This bothers me a little: cl_addr is just the address that the
exchange_id came from.  In theory there's no one-to-one relationship
between NFSv4 clients and IP addresses.  Is it likely the iscsi traffic
could use a different interface than the MDS traffic?

If this is the best we can do, then maybe this should at least be
documented.

--b.

> +
> +	printk(KERN_WARNING
> +		"nfsd: client %s failed to respond to layout recall. "
> +		"  Fencing..\n", addr_str);
> +
> +	argv[0] = "/sbin/nfsd-recall-failed";
> +	argv[1] = addr_str;
> +	argv[2] = ls->ls_file->f_path.mnt->mnt_sb->s_id;
> +	argv[3] = NULL;
> +
> +	error = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
> +	if (error) {
> +		printk(KERN_ERR "nfsd: fence failed for client %s: %d!\n",
> +			addr_str, error);
> +	}
> +}
> +
> +static int
> +nfsd4_cb_layout_done(struct nfsd4_callback *cb, struct rpc_task *task)
> +{
> +	struct nfs4_layout_stateid *ls =
> +		container_of(cb, struct nfs4_layout_stateid, ls_recall);
> +	LIST_HEAD(reaplist);
> +
> +	switch (task->tk_status) {
> +	case 0:
> +		return 1;
> +	case -NFS4ERR_NOMATCHING_LAYOUT:
> +		task->tk_status = 0;
> +		return 1;
> +	case -NFS4ERR_DELAY:
> +		/* Poll the client until it's done with the layout */
> +		/* FIXME: cap number of retries.
> +		 * The pnfs standard states that we need to only expire
> +		 * the client after at-least "lease time" .eg lease-time * 2
> +		 * when failing to communicate a recall
> +		 */
> +		rpc_delay(task, HZ/100); /* 10 mili-seconds */
> +		return 0;
> +	default:
> +		/*
> +		 * Unknown error or non-responding client, we'll need to fence.
> +		 */
> +		nfsd4_cb_layout_fail(ls);
> +		return -1;
> +	}
> +}
> +
> +static void
> +nfsd4_cb_layout_release(struct nfsd4_callback *cb)
> +{
> +	struct nfs4_layout_stateid *ls =
> +		container_of(cb, struct nfs4_layout_stateid, ls_recall);
> +	LIST_HEAD(reaplist);
> +
> +	nfsd4_return_all_layouts(ls, &reaplist);
> +	nfsd4_free_layouts(&reaplist);
> +	nfs4_put_stid(&ls->ls_stid);
> +}
> +
> +static struct nfsd4_callback_ops nfsd4_cb_layout_ops = {
> +	.done		= nfsd4_cb_layout_done,
> +	.release	= nfsd4_cb_layout_release,
> +};
> +
> +static bool
> +nfsd4_layout_lm_break(struct file_lock *fl)
> +{
> +	/*
> +	 * We don't want the locks code to timeout the lease for us;
> +	 * we'll remove it ourself if a layout isn't returned
> +	 * in time:
> +	 */
> +	fl->fl_break_time = 0;
> +	nfsd4_recall_file_layout(fl->fl_owner);
> +	return false;
> +}
> +
> +static int
> +nfsd4_layout_lm_change(struct file_lock **onlist, int arg,
> +		struct list_head *dispose)
> +{
> +	BUG_ON(!(arg & F_UNLCK));
> +	return lease_modify(onlist, arg, dispose);
> +}
> +
> +static const struct lock_manager_operations nfsd4_layouts_lm_ops = {
> +	.lm_break	= nfsd4_layout_lm_break,
> +	.lm_change	= nfsd4_layout_lm_change,
> +};
> +
>  int
>  nfsd4_init_pnfs(void)
>  {
> diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
> index b813913..c051d5b 100644
> --- a/fs/nfsd/nfs4proc.c
> +++ b/fs/nfsd/nfs4proc.c
> @@ -1301,6 +1301,10 @@ nfsd4_layoutget(struct svc_rqst *rqstp,
>  	if (nfserr)
>  		goto out;
>  
> +	nfserr = nfserr_recallconflict;
> +	if (atomic_read(&ls->ls_stid.sc_file->fi_lo_recalls))
> +		goto out_put_stid;
> +
>  	nfserr = ops->proc_layoutget(current_fh->fh_dentry->d_inode,
>  				     current_fh, lgp);
>  	if (nfserr)
> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> index eb972e6..1450b57 100644
> --- a/fs/nfsd/nfs4state.c
> +++ b/fs/nfsd/nfs4state.c
> @@ -3070,6 +3070,7 @@ static void nfsd4_init_file(struct knfsd_fh *fh, unsigned int hashval,
>  	memset(fp->fi_access, 0, sizeof(fp->fi_access));
>  #ifdef CONFIG_NFSD_PNFS
>  	INIT_LIST_HEAD(&fp->fi_lo_states);
> +	atomic_set(&fp->fi_lo_recalls, 0);
>  #endif
>  	hlist_add_head_rcu(&fp->fi_hash, &file_hashtbl[hashval]);
>  }
> diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
> index 5f66b7f..4f3bfeb 100644
> --- a/fs/nfsd/state.h
> +++ b/fs/nfsd/state.h
> @@ -502,6 +502,7 @@ struct nfs4_file {
>  	bool			fi_had_conflict;
>  #ifdef CONFIG_NFSD_PNFS
>  	struct list_head	fi_lo_states;
> +	atomic_t		fi_lo_recalls;
>  #endif
>  };
>  
> @@ -542,6 +543,10 @@ struct nfs4_layout_stateid {
>  	spinlock_t			ls_lock;
>  	struct list_head		ls_layouts;
>  	u32				ls_layout_type;
> +	struct file			*ls_file;
> +	struct nfsd4_callback		ls_recall;
> +	stateid_t			ls_recall_sid;
> +	bool				ls_recalled;
>  };
>  
>  static inline struct nfs4_layout_stateid *layoutstateid(struct nfs4_stid *s)
> @@ -556,6 +561,7 @@ static inline struct nfs4_layout_stateid *layoutstateid(struct nfs4_stid *s)
>  enum nfsd4_cb_op {
>  	NFSPROC4_CLNT_CB_NULL = 0,
>  	NFSPROC4_CLNT_CB_RECALL,
> +	NFSPROC4_CLNT_CB_LAYOUT,
>  	NFSPROC4_CLNT_CB_SEQUENCE,
>  };
>  
> diff --git a/fs/nfsd/xdr4cb.h b/fs/nfsd/xdr4cb.h
> index c5c55df..c47f6fd 100644
> --- a/fs/nfsd/xdr4cb.h
> +++ b/fs/nfsd/xdr4cb.h
> @@ -21,3 +21,10 @@
>  #define NFS4_dec_cb_recall_sz		(cb_compound_dec_hdr_sz  +      \
>  					cb_sequence_dec_sz +            \
>  					op_dec_sz)
> +#define NFS4_enc_cb_layout_sz		(cb_compound_enc_hdr_sz +       \
> +					cb_sequence_enc_sz +            \
> +					1 + 3 +                         \
> +					enc_nfs4_fh_sz + 4)
> +#define NFS4_dec_cb_layout_sz		(cb_compound_dec_hdr_sz  +      \
> +					cb_sequence_dec_sz +            \
> +					op_dec_sz)
> -- 
> 1.9.1
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
