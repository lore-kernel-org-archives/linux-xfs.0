Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:36398 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932968AbdELQVQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 12:21:16 -0400
Date: Fri, 12 May 2017 12:21:15 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170512162115.GH7704@fieldses.org>
References: <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com>
 <20170330161231.GA9824@fieldses.org>
 <1490898932.2667.1.camel@redhat.com>
 <20170404183138.GC14303@fieldses.org>
 <878tnfiq7v.fsf@notabene.neil.brown.name>
 <20170405080551.GC8899@quack2.suse.cz>
 <20170405181409.GC28681@fieldses.org>
 <20170511185942.GD25434@fieldses.org>
 <87r2zvkp9c.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r2zvkp9c.fsf@notabene.neil.brown.name>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: NeilBrown <neil@brown.name>
Cc: Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, May 12, 2017 at 08:22:23AM +1000, NeilBrown wrote:
> On Thu, May 11 2017, J. Bruce Fields wrote:
> > +static inline u64 nfsd4_change_attribute(struct inode *inode)
> > +{
> > +	u64 chattr;
> > +
> > +	chattr = inode->i_ctime.tv_sec << 30;
> > +	chattr += inode->i_ctime.tv_nsec;
> > +	chattr += inode->i_version;
> > +	return chattr;
> 
> So if I chmod a file, all clients will need to flush the content from their cache?
> Maybe they already do?  Maybe it is a boring corner case?

Yeah, that's the assumption, maybe it's wrong.  I can't recall
complaints about anyone bitten by that case.

> >  /*
> >   * Fill in the pre_op attr for the wcc data
> >   */
> > @@ -253,7 +263,7 @@ fill_pre_wcc(struct svc_fh *fhp)
> >  		fhp->fh_pre_mtime = inode->i_mtime;
> >  		fhp->fh_pre_ctime = inode->i_ctime;
> >  		fhp->fh_pre_size  = inode->i_size;
> > -		fhp->fh_pre_change = inode->i_version;
> > +		fhp->fh_pre_change = nfsd4_change_attribute(inode);
> >  		fhp->fh_pre_saved = true;
> >  	}
> >  }
> > --- a/fs/nfsd/nfs3xdr.c
> > +++ b/fs/nfsd/nfs3xdr.c
> > @@ -260,7 +260,7 @@ void fill_post_wcc(struct svc_fh *fhp)
> >  		printk("nfsd: inode locked twice during operation.\n");
> >  
> >  	err = fh_getattr(fhp, &fhp->fh_post_attr);
> > -	fhp->fh_post_change = d_inode(fhp->fh_dentry)->i_version;
> > +	fhp->fh_post_change = nfsd4_change_attribute(d_inode(fhp->fh_dentry));
> >  	if (err) {
> >  		fhp->fh_post_saved = false;
> >  		/* Grab the ctime anyway - set_change_info might use it */
> > diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> > index 26780d53a6f9..a09532d4a383 100644
> > --- a/fs/nfsd/nfs4xdr.c
> > +++ b/fs/nfsd/nfs4xdr.c
> > @@ -1973,7 +1973,7 @@ static __be32 *encode_change(__be32 *p, struct kstat *stat, struct inode *inode,
> >  		*p++ = cpu_to_be32(convert_to_wallclock(exp->cd->flush_time));
> >  		*p++ = 0;
> >  	} else if (IS_I_VERSION(inode)) {
> > -		p = xdr_encode_hyper(p, inode->i_version);
> > +		p = xdr_encode_hyper(p, nfsd4_change_attribute(inode));
> >  	} else {
> >  		*p++ = cpu_to_be32(stat->ctime.tv_sec);
> >  		*p++ = cpu_to_be32(stat->ctime.tv_nsec);
> 
> It is *really* confusing to find that fh_post_change is only set in nfs3
> code, and only used in nfs4 code.

Yup.

> It is probably time to get a 'version' field in 'struct kstat'.

The pre/post_wcc code doesn't seem to be doing an explicit stat, I
wonder if that matters?

--b.

> That would allow this code to get a little cleaner.
> 
> (to me, this exercise is just a reminder that the NFSv4 change attribute
> is poorly designed ... so it just makes me grumpy).
> 
> NeilBrown
> 
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


