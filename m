Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9LeSnj174571 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 15:40:28 -0600
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 825C94EE8FF
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 13:41:56 -0800 (PST)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id FJYA2oW01lSbtm1z for <xfs@oss.sgi.com>;
	Tue, 09 Nov 2010 13:41:56 -0800 (PST)
Date: Tue, 9 Nov 2010 16:41:47 -0500
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101109214147.GK3099@thunk.org>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<20101109011222.GD2715@dastard> <20101109033038.GF3099@thunk.org>
	<20101109044242.GH2715@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109044242.GH2715@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Josef Bacik <josef@redhat.com>, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Nov 09, 2010 at 03:42:42PM +1100, Dave Chinner wrote:
> Implementation is up to the filesystem. However, XFS does (b)
> because:
> 
> 	1) it was extremely simple to implement (one of the
> 	   advantages of having an exceedingly complex allocation
> 	   interface to begin with :P)
> 	2) conversion is atomic, fast and reliable
> 	3) it is independent of the underlying storage; and
> 	4) reads of unwritten extents operate at memory speed,
> 	   not disk speed.

Yeah, I was thinking that using a device-style TRIM might be better
since future attempts to write to it won't require a separate seek to
modify the extent tree.  But yeah, there are a bunch of advantages of
simply mutating the extent tree.

While we're on the subject of changes to fallocate, what do people
think of FALLOC_FL_EXPOSE_OLD_DATA, which requires either root
privileges or (if capabilities are in use) CAP_DAC_OVERRIDE &&
CAP_MAC_OVERRIDE && CAP_SYS_ADMIN.  This would allow a trusted process
to fallocate blocks with the extent already marked initialized.  I've
had two requests for such functionality for ext4 already.  

(Take for example a trusted cluster filesystem backend that checks the
object checksum before returning any data to the user; and if the
check fails the cluster file system will try to use some other replica
stored on some other server.)

    		     	  		    	 - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
