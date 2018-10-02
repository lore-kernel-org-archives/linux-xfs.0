Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44700 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbeJBHET (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 03:04:19 -0400
Date: Mon, 1 Oct 2018 17:23:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: check ->get_link return value
Message-ID: <20181002002332.GA6706@magnolia>
References: <20181001224500.GE5872@magnolia>
 <20181001235251.GA10425@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001235251.GA10425@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: viro@ZenIV.linux.org.uk, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Mon, Oct 01, 2018 at 04:52:51PM -0700, Matthew Wilcox wrote:
> On Mon, Oct 01, 2018 at 03:45:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Teach callers of inode->i_op->get_link in the vfs code to check for a
> > NULL return value and return an error status instead of blindly
> > dereferencing the returned NULL pointer.
> 
> Is that better than having the get_link method return ERR_PTR(-EUCLEAN) itself?

get_link doesn't need the EFSCORRUPTED return; all two of its callers
handle null pointer returns correctly and they don't return the ->get_link
return value directly to userspace.

It's just these two functions below whose callers assume they have to
deal an error pointer or that it's totally safe to dereference it.

--D

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/namei.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 0cab6494978c..0744ab981fa0 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -4737,6 +4737,8 @@ int vfs_readlink(struct dentry *dentry, char __user *buffer, int buflen)
> >  		if (IS_ERR(link))
> >  			return PTR_ERR(link);
> >  	}
> > +	if (!link)
> > +		return -EUCLEAN;
> >  	res = readlink_copy(buffer, buflen, link);
> >  	do_delayed_call(&done);
> >  	return res;
> > @@ -4763,6 +4765,8 @@ const char *vfs_get_link(struct dentry *dentry, struct delayed_call *done)
> >  		res = ERR_PTR(security_inode_readlink(dentry));
> >  		if (!res)
> >  			res = inode->i_op->get_link(dentry, inode, done);
> > +		if (!res)
> > +			return ERR_PTR(-EUCLEAN);
> >  	}
> >  	return res;
> >  }
