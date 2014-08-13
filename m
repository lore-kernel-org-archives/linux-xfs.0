Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D66D87F4E
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 16:04:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C705AC006
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 14:04:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	W5tPLqMq5kbCYokO for <xfs@oss.sgi.com>;
	Wed, 13 Aug 2014 14:04:45 -0700 (PDT)
Date: Thu, 14 Aug 2014 07:04:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
Message-ID: <20140813210409.GF20518@dastard>
References: <53E8D9F6.7080704@sgi.com>
	<alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
	<53E93530.4070902@sgi.com>
	<alpine.LSU.2.11.1408112347480.17839@minas-tirith.valinor>
	<53E93C29.1020103@sgi.com>
	<alpine.LSU.2.11.1408120013500.17839@minas-tirith.valinor>
	<alpine.LSU.2.11.1408120139060.21410@minas-tirith.valinor>
	<20140812165143.GB46654@bfoster.bfoster>
	<alpine.LSU.2.11.1408122212410.14631@Telcontar.valinor>
	<20140813120450.GA3569@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140813120450.GA3569@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "Carlos E. R." <carlos.e.r@opensuse.org>, XFS mailing list <xfs@oss.sgi.com>

On Wed, Aug 13, 2014 at 08:04:51AM -0400, Brian Foster wrote:
> On Tue, Aug 12, 2014 at 11:17:36PM +0200, Carlos E. R. wrote:
> > This the point I'm at now. Are you saying that the filesystem can explode at
> > any time now? I have not written any files, beyond what the desktop does
> > automatically.
> > 
> 
> No, the filesystem has been fixed by repair. I'm just saying that
> somehow the fs creates a duplicate free space record in one of the free
> space trees.

Simple answer: the block is being freed twice. i.e. from a workqueue
during the hibernate process after the relevant memory has been
snapshotted (i.e. because the workqueue was not frozen), and again
after thaw when the memory image is restored to RAM and the
workqueue is started up again and the workqueue runs the same work a
second time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
