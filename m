Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBTKvpvn026458 for <xfs@oss.sgi.com>; Thu, 29 Dec 2011 14:57:51 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XxvUDpjnHe5FyDeq for <xfs@oss.sgi.com>;
	Thu, 29 Dec 2011 12:57:48 -0800 (PST)
Date: Fri, 30 Dec 2011 07:57:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Preallocation with direct IO?
Message-ID: <20111229205745.GH12731@dastard>
References: <4efc665b.d139e30a.2f32.fffff97a@mx.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4efc665b.d139e30a.2f32.fffff97a@mx.google.com>
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
To: "amit.sahrawat83@gmail.com" <amit.sahrawat83@gmail.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Dec 29, 2011 at 01:10:49PM +0000, amit.sahrawat83@gmail.com wrote:
> Hi, I am using a test setup which is doing write using multiple
> threads using direct IO. The buffer size which is used to write is
> 512KB.  After continously running this for long duration - i
> observe that number of extents in each file is getting
> huge(2K..4K..). I observed that each extent is of 512KB(aligned to
> write buffer size). I wish to have low number of extents(i.e,
> reduce fragmentation)... In case of buffered IO- preallocation
> works good alongwith the mount option 'allocsize'. Is there
> anything which can be done for Direct IO?  Please advice for
> reducing fragmentation with direct IO.

Direct IO does not do any implicit preallocation. The filesystem
simply gets out of the way of direct IO as it is assumed you know
what you are doing.

i.e. you know how to use the fallocate() or ioctl(XFS_IOC_RESVSP64)
calls to preallocate space or to set up extent size hints to use
larger allocations than the IO being done during syscalls...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
