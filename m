Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALFPiaP065060 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 09:25:44 -0600
Message-ID: <50ACF289.2080901@redhat.com>
Date: Wed, 21 Nov 2012 10:26:01 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
References: <1352766973-14197-1-git-send-email-jack@suse.cz>
	<20121119213913.GB29498@quack.suse.cz>
	<20121120161511.GE27055@sgi.com>
	<20121120170354.GF1408@quack.suse.cz>
	<20121120202038.GF2591@dastard> <50ABF54E.6070508@redhat.com>
	<20121120222215.GH2591@dastard>
In-Reply-To: <20121120222215.GH2591@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On 11/20/2012 05:22 PM, Dave Chinner wrote:
> On Tue, Nov 20, 2012 at 04:25:34PM -0500, Brian Foster wrote:
>> On 11/20/2012 03:20 PM, Dave Chinner wrote:
...
>>> It's by design. Directory tree quota is used as a method of
>>> exporting multiple sub-dirs from a single filesystem but having them
>>> appear to NFS clients just like a standalone filesystem. Hence when
>>> you run out of projet quota, it is treated like an ENOSPC condition
>>> for the directory sub-tree - it flushes as much of the metadata
>>> reservations out as possible to maximise the data space for the
>>> directory tree.
> 
> And FWIW, returning ENOSPC to the NFS client inthese situations is
> the correct error to be returning as they know nothing about the
> fact that project quotas are used on the server to limit the size of
> the export the client has mounted.
> 

Ok, I initially missed that we returned ENOSPC in the project quota
situation, so I might have mixed up what I was referring to as EDQUOT
vs. ENOSPC. I see the XFS_QMOPT_ENOSPC logic that appears to cause that
behavior.

>>> For user/group quotas, this requirement of behaving like a
>>> standalone filesystem does not exist, and so when you EDQUOT a
>>> user/group there is no need to reclaim metadata reservations to make
>>> more data space available....
>>
>> ... but the metadata reservation issue discussed here sounds like it
>> could still be a problem. Is the implication that we could still do a
>> project quota filtered eofblocks scan, but it must also (or instead, if
>> a flush implies trimming post-eof space) include an inode flush in the
>> project quota case?
> 
> It's never been reported as a problem. In the absence of problems
> being reported over the past 10+ years, I don't think we should be
> changing the behaviour of inode flushing at EDQUOT. Trimming
> speculative prealloc, yes, but I don't think flushing inodes is
> necessary.
> 

I was unclear. By problem, I just meant that replacing the inode flush
after a project quota ENOSPC with an eofblocks scan would be a problem
(e.g., a flush + eofblocks trim is the right approach, as you outline
below).

>> Otherwise, unless I'm mistaken it sounds like we can use the existing
>> eofblocks scan on user/group EDQUOT situations.
> 
> That we can. And for the project case, it's a simply and extra flag
> and a call to filemap_flush() to do an async writeback before
> trimming the specualtive preallocation.
> 

This makes sense generally. I'll need to dig further into this code to
wrap my head around it. If my current understanding is correct, it
sounds like we could do the same thing in general, non-quota ENOSPC
handling, right? E.g., an unfiltered eofblocks scan (plus the flush bit)
followed by a retry, rather than a complete flush of all dirty inodes.

Brian

...
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
