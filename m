Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28AMYHN016464 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 04:22:35 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	MTA3rjPvDYHQ3OoE for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 02:22:33 -0800 (PST)
Date: Thu, 8 Mar 2012 21:22:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: df bigger than ls?
Message-ID: <20120308102230.GS3592@dastard>
References: <20120307155439.GA23360@nsrc.org> <20120307171619.GA23557@nsrc.org>
	<4F57A32A.5010704@sandeen.net> <20120308085035.GA23992@nsrc.org>
	<20120308095932.GA24187@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120308095932.GA24187@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Mar 08, 2012 at 09:59:32AM +0000, Brian Candler wrote:
> On Thu, Mar 08, 2012 at 08:50:35AM +0000, Brian Candler wrote:
> > Aha.  This may well be what is screwing up gluster's disk usage on a striped
> > volume - I believe XFS is preallocating space which is actually going to end
> > up being a hole!

How is the filesystem supposed to know that? All it sees is
extending writes, which is what triggers speculative preallocation.

> Here is a standalone testcase.
> 
> $ for i in {0..19}; do dd if=/dev/zero of=testfile bs=128k count=1 seek=$[$i * 12]; done

Yup, that's behaving exactly as expected there. When you seek past
the existing EOF, and there is a speculative preallocation between
the old EOF and the new EOF, it writes zeros to that range because
the assumption is that you are going to fill it with data.

There are applications that do this to trigger that exact
preallocation - Samba is a classic case because windows clients will
write one byte 128k beyond the current EOF to get NTFS to trigger
large preallocation, then send back and write the real data to the
server. In cases like these, you want the hole allocated and filled
with zeros before the real writes come in just in case the server
crashes between the single byte write and the real data being
written....

FWIW, XFS on Irix had special code to detect out of order NFS
writes and do a similar hole filling trick to avoid fragmentation.

There's no one correct behaviour when dealing with writes of this
sort. In some cases the current behaviour is perfect (and samba on
XFS is widely used), in other cases it won't be exactly what you
want.

Indeed, you can avoid this problem by using ftruncate() to extend
the file before writing, write the regions in reverse order, using
fallocate to allocate the exact blocks you want before writing, or
use the allocsize mount option to turn of the dynamic behaviour.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
