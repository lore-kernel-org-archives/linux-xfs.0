Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKLPIxU214138 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 15:25:18 -0600
Message-ID: <50ABF54E.6070508@redhat.com>
Date: Tue, 20 Nov 2012 16:25:34 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
References: <1352766973-14197-1-git-send-email-jack@suse.cz>
	<20121119213913.GB29498@quack.suse.cz>
	<20121120161511.GE27055@sgi.com>
	<20121120170354.GF1408@quack.suse.cz>
	<20121120202038.GF2591@dastard>
In-Reply-To: <20121120202038.GF2591@dastard>
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

On 11/20/2012 03:20 PM, Dave Chinner wrote:
> On Tue, Nov 20, 2012 at 06:03:54PM +0100, Jan Kara wrote:
>> On Tue 20-11-12 10:15:11, Ben Myers wrote:
>>> Hi Jan,
>>>
>>> On Mon, Nov 19, 2012 at 10:39:13PM +0100, Jan Kara wrote:
>>>> On Tue 13-11-12 01:36:13, Jan Kara wrote:
...
>>>
>>> I think that there may be good reason to flush inodes even in the project quota
>>> case.  Speculative allocation beyond EOF might need to be cleaned up.
> 
> The flushing at ENOSPC doesn't clear up speculative preallocation.
> It writes back data which releases metadata reservations that
> delalloc extents hold in addition to the data. The reservations are
> held so that tree splits during allocation have block reserved and
> we don't ENOSPC on delalloc all the time.
> 

So does this apply to EDQUOT just the same as ENOSPC? In other words,
must we always do the flush, or can we replace the flush in EDQUOT
situations with a targeted eofblocks scan and retry?

Are these metadata reservations accounted against the particular quota?

>>>
>>> I'm all
>>> for passing back some data about why we hit ENOSPC.  Then we can combine this
>>> with Brian Foster's work and flush only inodes that touch a given project,
>>> user, or group quota.
> 
> Brian had more patches that throttled specualtive prealloc when
> quota got low, as well as triggered a specific specualtive
> allocation trimming passes when EDQUOT is hit. This will remove the
> global inode flush from the project uota cae when it is done.
> 

Yes, I need to resurrect those throttling patches as my next order of
business. They never had the eofblocks bits originally but it seems like
a logical add on at this point.

A point of confusion for me... above you reference removing the global
inode flush from the project quota case, which I'm taking as we can do
some kind of eofblocks scan here...

>>   Yes, I agree flushing might be useful even for project quota but then why
>> don't we flush inodes also for user quota?
> 
> It's by design. Directory tree quota is used as a method of
> exporting multiple sub-dirs from a single filesystem but having them
> appear to NFS clients just like a standalone filesystem. Hence when
> you run out of projet quota, it is treated like an ENOSPC condition
> for the directory sub-tree - it flushes as much of the metadata
> reservations out as possible to maximise the data space for the
> directory tree.
> 
> For user/group quotas, this requirement of behaving like a
> standalone filesystem does not exist, and so when you EDQUOT a
> user/group there is no need to reclaim metadata reservations to make
> more data space available....
> 

... but the metadata reservation issue discussed here sounds like it
could still be a problem. Is the implication that we could still do a
project quota filtered eofblocks scan, but it must also (or instead, if
a flush implies trimming post-eof space) include an inode flush in the
project quota case?

Otherwise, unless I'm mistaken it sounds like we can use the existing
eofblocks scan on user/group EDQUOT situations.

>> Also the performance impact
>> is really huge - and here I agree that unless you are writing over NFS you
>> won't notice because only NFS tries to push X MB to the filesystem page by
>> page only to get ENOSPC each time...
> 
> The problem is the speculative allocation can trigger this behaviour
> prematurely and repeatedly. That's where Brians prealloc throttle
> patches come in - it reduces the occurrence of ENOSPC as the quota
> limit is approached, and hence reduces the number of inode flushes.
> 

I'll include this use case in my testing when I get back to those patches.

Brian

>> And NFS is arguably doing a stupid
>> thing but it is a common setup and you don't always have the freedom to fix
>> clients to be more clever. So I'd be happy if XFS accomodated such use.
> 
> Sure, but there's more to it than just avoiding the inode flush,
> unfortunately...
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
