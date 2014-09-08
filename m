Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 42F507F52
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 17:07:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4E35AC001
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 15:07:45 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NGZC0cxpgMMkTiWQ for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 15:07:40 -0700 (PDT)
Date: Tue, 9 Sep 2014 08:07:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: converting from external log to internal log ... is this possible?
Message-ID: <20140908220738.GP30012@dastard>
References: <540DF0FD.205@gmail.com>
 <540DF86D.8080705@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540DF86D.8080705@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, Joe Landman <joe.landman@gmail.com>

On Mon, Sep 08, 2014 at 01:41:49PM -0500, Eric Sandeen wrote:
> On 9/8/14 1:10 PM, Joe Landman wrote:
> >Figured I'd ask, looked on the FAQ and didn't see anything there
> >relevant to this.  There is a hint of this in xfs_growfs,
> >specifically the -i option, though it is noted that "[NOTE: This
> >option is not implemented]".
> 
> Yep, it's never been implemented.  You could do it manually with
> some very careful xfs_db surgery, if you had enough contiguous
> freespace available, but it's not at all supported.
> 
> Basically, no, you can't do it without getting very far under
> the hood and directly editing the disk.

There's nothing amazingly difficult about implementing
external-to-internal journal. First allocate the contiguous extent
for the new log, then zero it, then freeze the filesystem to bring
the external log down to a clean state, atomically modify the
superblock on disk to point at the new log, then re-initialise all
the log state to point at the new log, update the head and tail to
new cycles at the start of the new log, and unfreeze....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
