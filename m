Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE66C7CA6
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 04:32:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A485B304039
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 02:32:54 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id r8fFHD7ImgV093A1 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 02:32:51 -0700 (PDT)
Date: Tue, 9 Aug 2016 11:32:46 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] xfs: Propagate dentry down to inode_change_ok()
Message-ID: <20160809093246.GB5107@quack2.suse.cz>
References: <1470223689-17783-1-git-send-email-jack@suse.cz>
	<1470223689-17783-2-git-send-email-jack@suse.cz>
	<20160809082756.GA11657@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809082756.GA11657@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, xfs@oss.sgi.com, "Yan, Zheng" <zyan@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org

On Tue 09-08-16 01:27:56, Christoph Hellwig wrote:
> > +static int
> > +xfs_vn_change_ok(
> > +	struct dentry	*dentry,
> > +	struct iattr	*iattr)
> 
> Please don't use the _vn prefix for something that's not an
> actual inode operation (and we should do a mess rename to 
> _iop one day as well.)
> 
> > +int
> > +xfs_vn_setattr_nonsize(
> > +	struct dentry		*dentry,
> > +	struct iattr		*iattr)
> 
> Same here.

So do you suggest xfs_iop_change_ok and xfs_iop_setattr_nonsize? I don't
really care, I just remember Dave had some ideas how names should be
consistent and this naming was his idea...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
