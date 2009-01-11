Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0BAl92J013976 for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 04:47:09 -0600
Date: Sun, 11 Jan 2009 21:46:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
Message-ID: <20090111104659.GB8071@disturbed>
References: <20090109044121.GA31280@orion> <20090109053858.GP9448@disturbed>
	<a4423d670901091353s7ff12207gcb38eb093d77d401@mail.gmail.com>
	<a4423d670901091418j5c7fdfb2oeba2f4640f8e29d0@mail.gmail.com>
	<a4423d670901091511y68a53808rfaab8148526224c6@mail.gmail.com>
	<a4423d670901100419s2ae106bexac1a538caf654153@mail.gmail.com>
	<20090110143924.GA25900@infradead.org>
	<a4423d670901100709v1e7ce0bfs167547c5001787ac@mail.gmail.com>
	<20090110152803.GA7469@infradead.org> <20090110221459.GA8873@orion>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090110221459.GA8873@orion>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, kernel-testers@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jan 11, 2009 at 01:14:59AM +0300, Alexander Beregalov wrote:
> On Sat, Jan 10, 2009 at 10:28:03AM -0500, Christoph Hellwig wrote:
> > On Sat, Jan 10, 2009 at 06:09:05PM +0300, Alexander Beregalov wrote:
> > > > That would be odd as 7f7c39ccb6045cf1fd5e7684a484c445291b44d4 only
> > > > changes the tracing code which currently isn't enabled.  Or we
> > > > get some sort of miscompilation due slightly different noop
> > > > macros.
> > > I meant the first bad commit is between these two commits. All of them
> > > fail to compile as is,
> > > I added xfs_btree_trace.h manually to compile it, I got different bugs
> > > on these commits,
> > > but I am not sure if they are really different. Like this:
> > 
> > Ah crap.  When lachlan checked in the btree tracing he forgot to
> > add that header and it only got in after that.  Can you bisect
> > further between those commit by just using xfs_btree_trce.h from
> > a newer version?  It hasn't had a single change yet since it was
> > commited.
> > 
> > This is quite important as all changes between these two revisions
> > are quite large and deal with consolidating the btree code.
> > 
> 
> I can not reproduce it now, I get the following message instead:
> I will try to repair the filesystem.
> 
> Filesystem "sdb1": XFS internal error xfs_btree_check_lblock at line 86 of file fs/xfs/xfs_btree.c.  Caller 0xc024af42
> 
> Pid: 251, comm: pdflush Not tainted 2.6.28-09244-g3d14bda #4
> Call Trace:
>  [<c0261462>] ? xfs_cmn_err+0x32/0x60
>  [<c02614de>] xfs_error_report+0x4e/0x50
>  [<c024af42>] ? xfs_btree_check_block+0x32/0x40
>  [<c024adcd>] xfs_btree_check_lblock+0x4d/0x190
>  [<c024af42>] ? xfs_btree_check_block+0x32/0x40
>  [<c0286bf0>] ? xfs_trans_read_buf+0x470/0x530
>  [<c024af42>] xfs_btree_check_block+0x32/0x40
>  [<c024b124>] xfs_btree_read_buf_block+0xe4/0x100
>  [<c024ce2d>] xfs_btree_lshift+0xbd/0x580
>  [<c026157b>] ? xfs_error_test+0x1b/0xc0
>  [<c024f29b>] xfs_btree_make_block_unfull+0x5b/0x140
>  [<c0248972>] ? xfs_bmbt_recs_inorder+0x32/0x70
>  [<c024f9be>] xfs_btree_insrec+0x63e/0x6c0
>  [<c024faa9>] xfs_btree_insert+0x69/0x190

Hmmmm - this might be getting closer to the source of the bug.
It's being detecting when reading in the buffer to do a left shift
now, not during the delete of a record.

I'd suggest that you treat this as the same failure and continue
the bisect to try to find when no problems show up at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
