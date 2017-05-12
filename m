Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:35173 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756849AbdELLB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 May 2017 07:01:28 -0400
Received: by mail-qt0-f177.google.com with SMTP id v27so25750711qtg.2
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2017 04:01:28 -0700 (PDT)
Message-ID: <1494586885.2787.3.camel@redhat.com>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and
 optimization
From: Jeff Layton <jlayton@redhat.com>
Date: Fri, 12 May 2017 07:01:25 -0400
In-Reply-To: <20170511185942.GD25434@fieldses.org>
References: <20170329111507.GA18467@quack2.suse.cz>
         <1490810071.2678.6.camel@redhat.com>
         <20170330064724.GA21542@quack2.suse.cz>
         <1490872308.2694.1.camel@redhat.com> <20170330161231.GA9824@fieldses.org>
         <1490898932.2667.1.camel@redhat.com> <20170404183138.GC14303@fieldses.org>
         <878tnfiq7v.fsf@notabene.neil.brown.name>
         <20170405080551.GC8899@quack2.suse.cz>
         <20170405181409.GC28681@fieldses.org> <20170511185942.GD25434@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>
Cc: NeilBrown <neil@brown.name>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, 2017-05-11 at 14:59 -0400, J. Bruce Fields wrote:
> On Wed, Apr 05, 2017 at 02:14:09PM -0400, J. Bruce Fields wrote:
> > On Wed, Apr 05, 2017 at 10:05:51AM +0200, Jan Kara wrote:
> > > 1) Keep i_version as is, make clients also check for i_ctime.
> > 
> > That would be a protocol revision, which we'd definitely rather avoid.
> > 
> > But can't we accomplish the same by using something like
> > 
> > 	ctime * (some constant) + i_version
> > 
> > ?
> > 
> > >    Pro: No on-disk format changes.
> > >    Cons: After a crash, i_version can go backwards (but when file changes
> > >    i_version, i_ctime pair should be still different) or not, data can be
> > >    old or not.
> > 
> > This is probably good enough for NFS purposes: typically on an NFS
> > filesystem, results of a read in the face of a concurrent write open are
> > undefined.  And writers sync before close.
> > 
> > So after a crash with a dirty inode, we're in a situation where an NFS
> > client still needs to resend some writes, sync, and close.  I'm OK with
> > things being inconsistent during this window.
> > 
> > I do expect things to return to normal once that client's has resent its
> > writes--hence the worry about actually resuing old values after boot
> > (such as if i_version regresses on boot and then increments back to the
> > same value after further writes).  Factoring in ctime fixes that.
> 
> So for now I'm thinking of just doing something like the following.
> 
> Only nfsd needs it for now, but it could be moved to a vfs helper for
> statx, or for individual filesystems that want to do something
> different.  (The NFSv4 client will want to use the server's change
> attribute instead, I think.  And other filesystems might want to try
> something more ambitious like Neil's proposal.)
> 
> --b.
> 
> diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
> index 12feac6ee2fd..9636c9a60aba 100644
> diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
> index f84fe6bf9aee..14f09f1ef605 100644
> --- a/fs/nfsd/nfsfh.h
> +++ b/fs/nfsd/nfsfh.h
> @@ -240,6 +240,16 @@ fh_clear_wcc(struct svc_fh *fhp)
>  	fhp->fh_pre_saved = false;
>  }
>  
> +static inline u64 nfsd4_change_attribute(struct inode *inode)
> +{
> +	u64 chattr;
> +
> +	chattr = inode->i_ctime.tv_sec << 30;
> +	chattr += inode->i_ctime.tv_nsec;
> +	chattr += inode->i_version;
> +	return chattr;
> +}
> +
>  /*
>   * Fill in the pre_op attr for the wcc data
>   */
> @@ -253,7 +263,7 @@ fill_pre_wcc(struct svc_fh *fhp)
>  		fhp->fh_pre_mtime = inode->i_mtime;
>  		fhp->fh_pre_ctime = inode->i_ctime;
>  		fhp->fh_pre_size  = inode->i_size;
> -		fhp->fh_pre_change = inode->i_version;
> +		fhp->fh_pre_change = nfsd4_change_attribute(inode);
>  		fhp->fh_pre_saved = true;
>  	}
>  }
> --- a/fs/nfsd/nfs3xdr.c
> +++ b/fs/nfsd/nfs3xdr.c
> @@ -260,7 +260,7 @@ void fill_post_wcc(struct svc_fh *fhp)
>  		printk("nfsd: inode locked twice during operation.\n");
>  
>  	err = fh_getattr(fhp, &fhp->fh_post_attr);
> -	fhp->fh_post_change = d_inode(fhp->fh_dentry)->i_version;
> +	fhp->fh_post_change = nfsd4_change_attribute(d_inode(fhp->fh_dentry));
>  	if (err) {
>  		fhp->fh_post_saved = false;
>  		/* Grab the ctime anyway - set_change_info might use it */
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index 26780d53a6f9..a09532d4a383 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -1973,7 +1973,7 @@ static __be32 *encode_change(__be32 *p, struct kstat *stat, struct inode *inode,
>  		*p++ = cpu_to_be32(convert_to_wallclock(exp->cd->flush_time));
>  		*p++ = 0;
>  	} else if (IS_I_VERSION(inode)) {
> -		p = xdr_encode_hyper(p, inode->i_version);
> +		p = xdr_encode_hyper(p, nfsd4_change_attribute(inode));
>  	} else {
>  		*p++ = cpu_to_be32(stat->ctime.tv_sec);
>  		*p++ = cpu_to_be32(stat->ctime.tv_nsec);


Sorry I've been MIA on this discussion. I've had a very busy spring...

This looks reasonable to me (modulo Jan's comment about casting tv_sec
to u64).

To be clear, I think this is mostly orthogonal to the changes that I was
originally proposing, right? I think we can still benefit from only
bumping and storing i_version values after they've been queried.

-- 
Jeff Layton <jlayton@redhat.com>
