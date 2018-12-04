Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47624 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbeLDPNd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 10:13:33 -0500
Date: Tue, 4 Dec 2018 07:13:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] vfs: copy_file_range source range over EOF should
 fail
Message-ID: <20181204151332.GA32245@infradead.org>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-2-david@fromorbit.com>
 <CAOQ4uxhOQY8M5rbgHKREN5qpeDGHv0-xK3r37Lj6XfqFoE4qjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhOQY8M5rbgHKREN5qpeDGHv0-xK3r37Lj6XfqFoE4qjg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 03, 2018 at 02:46:20PM +0200, Amir Goldstein wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > The man page says:
> >
> > EINVAL Requested range extends beyond the end of the source file
> >
> > But the current behaviour is that copy_file_range does a short
> > copy up to the source file EOF. Fix the kernel behaviour to match
> > the behaviour described in the man page.

I think the behavior implemented is a lot more useful than the one
documented..

> > +       /* If the source range crosses EOF, fail the copy */
> > +       if (pos_in >= i_size(inode_in) || pos_in + len > i_size(inode_in))
> > +               return -EINVAL;
> > +
> 
> i_size_read()...
> 
> Otherwise
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Looks like this doesn't even compile?
