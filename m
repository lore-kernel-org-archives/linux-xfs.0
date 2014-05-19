Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF8317F51
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 16:57:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A330E304075
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 14:57:17 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7t2vcUBOfYuYJ6Ou for <xfs@oss.sgi.com>;
	Mon, 19 May 2014 14:57:11 -0700 (PDT)
Date: Tue, 20 May 2014 07:56:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 2/2] xfs: sysfs attributes for the current log state
Message-ID: <20140519215658.GD8554@dastard>
References: <1400263966-35541-1-git-send-email-bfoster@redhat.com>
	<1400263966-35541-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400263966-35541-3-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

On Fri, May 16, 2014 at 02:12:46PM -0400, Brian Foster wrote:
> Create sysfs attributes to export the current runtime state of the log
> to userspace. Note that the filesystem should be frozen for best
> accuracy/consistency when reading these values, but is not required.
> This is for testing and debug purposes only.
> 
> Create the following per-mount attributes: log_head_lsn, log_tail_lsn,
> reserve_head_lsn and write_head_lsn. These represent the physical log

Reserve and write heads are not log sequence numbers (LSNs). A LSN
is a cycle:block count tuple, while a grant head is a cycle:byte
count tuple....

Calling the reserve_grant_head/write_grant_head would make more
sense, I think, as would splitting them into cycle/byte output
pairs. Splitting them make sense because if we increase the log size
beyond 2GB we're going to need a different in-memory representation
for the grant heads (i.e. need more than 32 bits for byte count), so
we should probably handle that up front in the sysfs API...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
