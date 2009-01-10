Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0AFT5NX031881 for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 09:29:06 -0600
Date: Sat, 10 Jan 2009 10:28:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
Message-ID: <20090110152803.GA7469@infradead.org>
References: <20090109044121.GA31280@orion> <20090109053858.GP9448@disturbed>
	<a4423d670901091353s7ff12207gcb38eb093d77d401@mail.gmail.com>
	<a4423d670901091418j5c7fdfb2oeba2f4640f8e29d0@mail.gmail.com>
	<a4423d670901091511y68a53808rfaab8148526224c6@mail.gmail.com>
	<a4423d670901100419s2ae106bexac1a538caf654153@mail.gmail.com>
	<20090110143924.GA25900@infradead.org>
	<a4423d670901100709v1e7ce0bfs167547c5001787ac@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a4423d670901100709v1e7ce0bfs167547c5001787ac@mail.gmail.com>
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

On Sat, Jan 10, 2009 at 06:09:05PM +0300, Alexander Beregalov wrote:
> > That would be odd as 7f7c39ccb6045cf1fd5e7684a484c445291b44d4 only
> > changes the tracing code which currently isn't enabled.  Or we
> > get some sort of miscompilation due slightly different noop
> > macros.
> I meant the first bad commit is between these two commits. All of them
> fail to compile as is,
> I added xfs_btree_trace.h manually to compile it, I got different bugs
> on these commits,
> but I am not sure if they are really different. Like this:

Ah crap.  When lachlan checked in the btree tracing he forgot to
add that header and it only got in after that.  Can you bisect
further between those commit by just using xfs_btree_trce.h from
a newer version?  It hasn't had a single change yet since it was
commited.

This is quite important as all changes between these two revisions
are quite large and deal with consolidating the btree code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
