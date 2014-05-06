Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 238E57FE0
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:29:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 04AD88F8033
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:29:12 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	giNyEkyArfsAma4Q for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:28:59 -0700 (PDT)
Date: Tue, 6 May 2014 18:28:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: remove shared supberlock feature checking
Message-ID: <20140506082857.GE5421@dastard>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
	<1399348559-19889-6-git-send-email-david@fromorbit.com>
	<20140506081820.GD24143@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506081820.GD24143@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, May 06, 2014 at 01:18:20AM -0700, Christoph Hellwig wrote:
> On Tue, May 06, 2014 at 01:55:59PM +1000, Dave Chinner wrote:
> > 
> > We reject any filesystem that is mounted with this feature bit set,
> > so we don't need to check for it anywhere else. Remove the function
> > for checking if the feature bit is set and any code that uses it.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> If someone at SGI has some spare time for a BugWorks search I'd really
> love to figure out of the story behind the shared superblock feature..

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=9ea7d56d2db84bd45183c4ab11903b97c5b9a8e9

tells us that the PV to start looking at is 522678. It's something
to do with shared read-only filesystems - I suspect the sb_shared_vn
field counts the number of read-only mounts - and my guess is it was
for Cellular Irix. i.e. SGI's aborted attempt to make a distributed
operating system that left useless crap all through the Irix 6.5
codebase...

Cheers,

Dve.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
