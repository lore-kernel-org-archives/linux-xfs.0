Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBLNpNs8118493 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 17:51:23 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 07BB721533D
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 15:53:19 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	NyxwrBI9wsuRD0Yy for <xfs@oss.sgi.com>;
	Tue, 21 Dec 2010 15:53:19 -0800 (PST)
Date: Wed, 22 Dec 2010 10:53:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS status update for November 2010
Message-ID: <20101221235301.GD4907@dastard>
References: <20101220180013.GA16283@infradead.org>
	<4D109047.8050300@panasas.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D109047.8050300@panasas.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Dec 21, 2010 at 01:32:23PM +0200, Boaz Harrosh wrote:
> On 12/20/2010 08:00 PM, Christoph Hellwig wrote:
> >>From looking at the kernel git commits November looked like a pretty
> > slow month with just two hand full fixes going into the release candidates
> > for Linux 2.6.37, and none at all going into the development tree.
> > But in this case git statistics didn't tell the whole story - there
> > was a lot of activity on patches for the next merge window on the list.
> > The focus in November was still at metadata scalability, with various
> > patchsets that improves parallel creates and unlinks again, and also
> > improves 8-way dbench throughput by 30%.  In addition to that there
> > were patches to improve preallocation for NFS servers, to simplify
> > the writeback code, and to remove the XFS-internal percpu counters
> > for free space for the generic kernel percpu counters, which just needed
> > a small improvement.
> > 
> > On the user space side we saw the release of xfsprogs 3.1.4, which
> > contains various accumulated bug fixes and Debian packaging updates.
> > The xfsdump tree saw a large update to speed up restore by using
> > mmap for an internal database and remove the limitation of ~ 214
> > million directory entries per dump file.  The xfstests test suite
> > saw three new testcases and various fixes, including support for the
> > hfsplus filesystem.
> 
> Hi Christoph, happy holidays
> 
> I love these reports you do, thank you
> 
> I have one small request, could you please post them to
> linux-fsdevel as well. linux-kernel@vger.kernel.org is so crowded
> I keep missing them.

Boaz, you can set up a modification watch on this page:

http://xfs.org/index.php/XFS_Status_Updates

as Christoph posts the updates there as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
