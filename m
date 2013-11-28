Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CD317F51
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 04:39:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1926AC002
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 02:39:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id AjrE0GyIrqQeM8jB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 02:39:33 -0800 (PST)
Date: Thu, 28 Nov 2013 02:39:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/4] xfs: allow linkat() on O_TMPFILE files
Message-ID: <20131128103930.GB26927@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-5-git-send-email-zwu.kernel@gmail.com>
	<20131125135149.GD30189@infradead.org>
	<CAEH94LiiRgQGzf+YGy23SJDhHJ_1grC3kniLqXDdUQFJ09McTA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEH94LiiRgQGzf+YGy23SJDhHJ_1grC3kniLqXDdUQFJ09McTA@mail.gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

On Thu, Nov 28, 2013 at 10:37:29AM +0800, Zhi Yong Wu wrote:
> On Mon, Nov 25, 2013 at 9:51 PM, Christoph Hellwig <hch@infradead.org> wrote:
> >> -     ASSERT(ip->i_d.di_nlink > 0);
> >> +     if ((VFS_I(ip)->i_nlink == 0) &&
> >> +         !(VFS_I(ip)->i_state & I_LINKABLE))
> >> +             ASSERT(ip->i_d.di_nlink > 0);
> >
> >         ASSERT(ip->i_d.di_nlink > 0 || (VFS_I(ip)->i_state & I_LINKABLE));
> This is wrong, and it should be
>           ASSERT(ip->i_d.di_nlink > 0 || !(VFS_I(ip)->i_state & I_LINKABLE));

Why we want to assrrt that either the link count is bigger than 0,
or that the I_LINKABLE flag is set (for files created using O_TMPFILE)

> >> +
> >> +     if ((VFS_I(sip)->i_nlink == 0) &&
> >> +         (VFS_I(sip)->i_state & I_LINKABLE))
> >> +             tres = &M_RES(mp)->tr_link_tmpfile;
> >> +     else
> >> +             tres = &M_RES(mp)->tr_link;
> >
> > Just check i_nlink, and for consistency it might make sense to just use
> > the xfs_inode one.  The VFS already made sure we don't inodes with
> but struct xfs_inode has no stuff similar to i_nlink....

ip->i_d.di_nlink is the equivalent.

> > I_LINKABLE and a zero link count.
> No, pls see the chunk of code:
> int vfs_link(struct dentry *old_dentry, struct inode *dir, struct
> dentry *new_dentry)
> {
> ...
>     /* Make sure we don't allow creating hardlink to an unlinked file */
>     if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
>         error =  -ENOENT;

This makes sure we never created a link if the count is zero unless
the I_LINKABLE is set, so we'll never see a zero link count without
I_LINKABLE.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
