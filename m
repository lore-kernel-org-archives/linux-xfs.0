Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:44044 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbdJ3NVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Oct 2017 09:21:19 -0400
Received: by mail-qt0-f194.google.com with SMTP id 8so16302847qtv.1
        for <linux-xfs@vger.kernel.org>; Mon, 30 Oct 2017 06:21:19 -0700 (PDT)
Message-ID: <1509369676.5412.20.camel@redhat.com>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and
 optimization
From: Jeff Layton <jlayton@redhat.com>
Date: Mon, 30 Oct 2017 09:21:16 -0400
In-Reply-To: <20170512162115.GH7704@fieldses.org>
References: <20170330064724.GA21542@quack2.suse.cz>
         <1490872308.2694.1.camel@redhat.com> <20170330161231.GA9824@fieldses.org>
         <1490898932.2667.1.camel@redhat.com> <20170404183138.GC14303@fieldses.org>
         <878tnfiq7v.fsf@notabene.neil.brown.name>
         <20170405080551.GC8899@quack2.suse.cz>
         <20170405181409.GC28681@fieldses.org> <20170511185942.GD25434@fieldses.org>
         <87r2zvkp9c.fsf@notabene.neil.brown.name>
         <20170512162115.GH7704@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>, NeilBrown <neil@brown.name>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, 2017-05-12 at 12:21 -0400, J. Bruce Fields wrote:
> On Fri, May 12, 2017 at 08:22:23AM +1000, NeilBrown wrote:
> > On Thu, May 11 2017, J. Bruce Fields wrote:
> > > +static inline u64 nfsd4_change_attribute(struct inode *inode)
> > > +{
> > > +	u64 chattr;
> > > +
> > > +	chattr = inode->i_ctime.tv_sec << 30;
> > > +	chattr += inode->i_ctime.tv_nsec;
> > > +	chattr += inode->i_version;
> > > +	return chattr;
> > 
> > So if I chmod a file, all clients will need to flush the content from their cache?
> > Maybe they already do?  Maybe it is a boring corner case?
> 
> Yeah, that's the assumption, maybe it's wrong.  I can't recall
> complaints about anyone bitten by that case.
> 

I'm pretty sure that's required by the RFC. The change attribute changes
with both data and metadata changes, and there is no way to tell what
sort of change it was. You have to dump everything out of the cache when
it changes.

> > >  /*
> > >   * Fill in the pre_op attr for the wcc data
> > >   */
> > > @@ -253,7 +263,7 @@ fill_pre_wcc(struct svc_fh *fhp)
> > >  		fhp->fh_pre_mtime = inode->i_mtime;
> > >  		fhp->fh_pre_ctime = inode->i_ctime;
> > >  		fhp->fh_pre_size  = inode->i_size;
> > > -		fhp->fh_pre_change = inode->i_version;
> > > +		fhp->fh_pre_change = nfsd4_change_attribute(inode);
> > >  		fhp->fh_pre_saved = true;
> > >  	}
> > >  }
> > > --- a/fs/nfsd/nfs3xdr.c
> > > +++ b/fs/nfsd/nfs3xdr.c
> > > @@ -260,7 +260,7 @@ void fill_post_wcc(struct svc_fh *fhp)
> > >  		printk("nfsd: inode locked twice during operation.\n");
> > >  
> > >  	err = fh_getattr(fhp, &fhp->fh_post_attr);
> > > -	fhp->fh_post_change = d_inode(fhp->fh_dentry)->i_version;
> > > +	fhp->fh_post_change = nfsd4_change_attribute(d_inode(fhp->fh_dentry));
> > >  	if (err) {
> > >  		fhp->fh_post_saved = false;
> > >  		/* Grab the ctime anyway - set_change_info might use it */
> > > diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> > > index 26780d53a6f9..a09532d4a383 100644
> > > --- a/fs/nfsd/nfs4xdr.c
> > > +++ b/fs/nfsd/nfs4xdr.c
> > > @@ -1973,7 +1973,7 @@ static __be32 *encode_change(__be32 *p, struct kstat *stat, struct inode *inode,
> > >  		*p++ = cpu_to_be32(convert_to_wallclock(exp->cd->flush_time));
> > >  		*p++ = 0;
> > >  	} else if (IS_I_VERSION(inode)) {
> > > -		p = xdr_encode_hyper(p, inode->i_version);
> > > +		p = xdr_encode_hyper(p, nfsd4_change_attribute(inode));
> > >  	} else {
> > >  		*p++ = cpu_to_be32(stat->ctime.tv_sec);
> > >  		*p++ = cpu_to_be32(stat->ctime.tv_nsec);
> > 
> > It is *really* confusing to find that fh_post_change is only set in nfs3
> > code, and only used in nfs4 code.
> 
> Yup.
> 
> > It is probably time to get a 'version' field in 'struct kstat'.
> 
> The pre/post_wcc code doesn't seem to be doing an explicit stat, I
> wonder if that matters?
> 

Probably not for now. We only use this for namespace altering operations
anyway (create, link, unlink, and rename).

The post code does do a fh_getattr. It's only the pre-op i_version that
comes out of the cache. Only btrfs, xfs, and ext4 have a real i_version
counter today, and they just scrape that info out of the in-core inode.
So while not completely atomic, you should see a difference in the
change_info4 during any of those operations.

FWIW, userland cephfs now supports a cluster-coherent change attribute,
though the kernel client still needs some work before we can implement
it there. Eventually we'll add that, and at that point we might need to
have nfsd do a getattr in the pre part as well.

-- 
Jeff Layton <jlayton@redhat.com>
