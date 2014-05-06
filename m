Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 969097FC9
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:00:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6AF768F8033
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:00:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PXq4pDYHbonUFpgl for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:00:52 -0700 (PDT)
Date: Tue, 6 May 2014 18:00:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfsprogs: xfs_copy: use exit() to replace killall()
Message-ID: <20140506080023.GB5421@dastard>
References: <1399359284-20536-1-git-send-email-junxiao.bi@oracle.com>
	<20140506075742.GB13191@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506075742.GB13191@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, joe.jin@oracle.com, Junxiao Bi <junxiao.bi@oracle.com>

On Tue, May 06, 2014 at 12:57:42AM -0700, Christoph Hellwig wrote:
> On Tue, May 06, 2014 at 02:54:44PM +0800, Junxiao Bi wrote:
> > Sending a SIGKILL signal to child thread will terminate the whole process,
> > xfs_copy will return an error value 137. This cause confuse for script to
> > know whether the copy successes.
> > 
> > Calling exit() in main thread can terminate the whole process and return the
> > right value. Replace killall()+abort() with exit(1) to match the old way
> > exit in error case. Also remove killall()+pthread_exit(NULL) since return 0
> > will be followed by an exit(0) to terminate the process.
> > 
> > Bug story from Chrisoph Hellwig:
> > Btw, I think the reason for this cruft is that xfs_copy was originally
> > written using the IRIX sproc interface, and the port to pthreads didn't
> > remove this gem:
> > 
> > http://marc.info/?l=linux-xfs&m=99535721110020&w=2
> > 
> > Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> > Cc: Joe jin <joe.jin@oracle.com>
> > Cc: Chrisoph Hellwig <hch@infradead.org>
> 
> Looks good (except that you misspelled by name :))
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I can fix that ;)

I'll queue this up for after the 3.2.0 release.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
