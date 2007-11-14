Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Nov 2007 09:39:30 -0800 (PST)
Received: from fieldses.org (mail.fieldses.org [66.93.2.214])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAEHdMH1025016
	for <linux-xfs@oss.sgi.com>; Wed, 14 Nov 2007 09:39:26 -0800
Date: Wed, 14 Nov 2007 12:39:22 -0500
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071114173922.GC14254@fieldses.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071114152952.GA4210@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114152952.GA4210@infradead.org>
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wedgwood <cw@f00f.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Wed, Nov 14, 2007 at 03:29:52PM +0000, Christoph Hellwig wrote:
> On Tue, Nov 13, 2007 at 11:04:00PM -0800, Chris Wedgwood wrote:
> > With 2.6.24-rc2 (amd64) I sometimes (usually but perhaps not always)
> > see a hang when accessing some NFS exported XFS filesystems.  Local
> > access to these filesystems ahead of time works without problems.
> > 
> > This does not occur with 2.6.23.1.  The filesystem does not appear to
> > be corrupt.
> > 
> 
> >     [ 1462.911360]  ffffffff80744020 ffffffff80746dc0 ffff81010129c140 ffff8101000ad100
> >     [ 1462.911391] Call Trace:
> >     [ 1462.911417]  [<ffffffff8052e638>] __down+0xe9/0x101
> >     [ 1462.911437]  [<ffffffff8022cc80>] default_wake_function+0x0/0xe
> >     [ 1462.911458]  [<ffffffff8052e275>] __down_failed+0x35/0x3a
> >     [ 1462.911480]  [<ffffffff8035ac25>] _xfs_buf_find+0x84/0x24d
> >     [ 1462.911501]  [<ffffffff8035ad34>] _xfs_buf_find+0x193/0x24d
> >     [ 1462.911522]  [<ffffffff803599b1>] xfs_buf_lock+0x43/0x45
> 
> this is bp->b_sema which lookup wants.
> 
> >     [ 1462.915534]  [<ffffffff8032b6da>] xfs_readdir+0x91/0xb6
> >     [ 1462.915557]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
> >     [ 1462.915579]  [<ffffffff8035be9d>] xfs_file_readdir+0x31/0x40
> >     [ 1462.915599]  [<ffffffff8028c9f8>] vfs_readdir+0x61/0x93
> >     [ 1462.915619]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
> >     [ 1462.915642]  [<ffffffff802fc78e>] nfsd_readdir+0x6d/0xc5
> 
> and this is the nasty nfsd case where a filldir callback calls back
> into lookup.  I suspect we're somehow holding b_sema already.  Previously
> this was okay because we weren't inside the actualy readdir code when
> calling filldir but operate on a copy of the data.
> 
> This gem has bitten other filesystem before, I'll see if I can find a
> way around it.

This must have come up before; feel free to remind me: is there any way
to make the interface easier to use?  (E.g. would it help if the filldir
callback could be passed a dentry?)

--b.
