Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RNVnGg049937 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 17:31:50 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86AF9297A93
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 15:34:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QeLYVxTcsKeE4u3E for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 15:34:13 -0800 (PST)
Date: Fri, 28 Jan 2011 10:34:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110127233409.GL21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com> <4D40CDCF.4010301@teksavvy.com>
	<20110127034314.GI21311@dastard> <4D40EC2D.5020507@teksavvy.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D40EC2D.5020507@teksavvy.com>
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
To: Mark Lord <kernel@teksavvy.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Alex Elder <aelder@sgi.com>

On Wed, Jan 26, 2011 at 10:53:17PM -0500, Mark Lord wrote:
> On 11-01-26 10:43 PM, Dave Chinner wrote:
> > On Wed, Jan 26, 2011 at 08:43:43PM -0500, Mark Lord wrote:
> >> On 11-01-26 08:22 PM, Mark Lord wrote:
> ..
> >> Thinking about it some more:  the first problem very much appears as if
> >> it is due to a filesystem check happening on the already-mounted filesystem,
> >> if that makes any kind of sense (?).
> > 
> > Not to me.  You can check this simply by looking at the output of
> > top while the problem is occurring...
> 
> Top doesn't show anything interesting, since disk I/O uses practically zero CPU.

My point is that  xfs_check doesn't use zero cpu or memory - it uses
quite a lot of both, so if it is not present in top output while the
disk is being thrashed, it ain't running...

> 
> >> running xfs_check on the umounted drive takes about the same 30-60 seconds,
> >> with the disk activity light fully "on".
> > 
> > Well, yeah - XFS check reads all the metadata in the filesystem, so
> > of course it's going to thrash your disk when it is run. The fact it
> > takes the same length of time as whatever problem you are having is
> > likely to be coincidental.
> 
> I find it interesting that the mount takes zero-time,
> as if it never actually reads much from the filesystem.
> Something has to eventually read the metadata etc.

Sure, for a clean log it has basically nothing to do - a few disk
reads to read the superblock, find the head/tail of the log, and
little else needs doing. Only when log recovery needs to be done
does mount do any significant IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
