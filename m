Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9HFrE16075869 for <xfs@oss.sgi.com>; Wed, 17 Oct 2012 10:53:14 -0500
Message-ID: <507ED4C0.1050400@redhat.com>
Date: Wed, 17 Oct 2012 10:54:40 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_quota: XFS_XFLAG_PROJINHERIT is only for dirs
References: <5078432B.6050501@redhat.com>
	<20121013155205.GA11037@infradead.org>
	<20121013233431.GQ2739@dastard> <507A01DF.1070105@redhat.com>
	<20121014001412.GS2739@dastard> <20121016201752.GD1377@sgi.com>
In-Reply-To: <20121016201752.GD1377@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, nscott@redhat.com, Dave Chinner <dchinner@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/16/12 3:17 PM, Ben Myers wrote:
> Hey Eric,
> 
> On Sun, Oct 14, 2012 at 11:14:12AM +1100, Dave Chinner wrote:
>> On Sat, Oct 13, 2012 at 07:05:51PM -0500, Eric Sandeen wrote:
>>> On 10/13/12 6:34 PM, Dave Chinner wrote:
>>>> On Sat, Oct 13, 2012 at 11:52:05AM -0400, Christoph Hellwig wrote:
>>>>> On Fri, Oct 12, 2012 at 11:19:55AM -0500, Eric Sandeen wrote:
>>>>>> xfs_quota has long set XFS_XFLAG_PROJINHERIT on all files,
>>>>>> and tested for presence on all files.  However, Dave's semi-recent
>>>>>> xfs_repair update is now flagging this as an error:
>>>>>
>>>>> I think we should rever that part of the repair patch.  While there
>>>>> really is not point to have XFS_XFLAG_PROJINHERIT set on non-directory
>>>>> files we have been setting it for year, so repair should cope with that.
>>>>
>>>> Repair does cope with it - it issues a warning and clears the flag.
>>>> It doesn't stop, it simply fixes an inconsistency in the inode flags.
>>>>
>>>> The main problem, by the sounds of it, is that repair issues a
>>>> warning that it is clearing the flags that should not be set. This
>>>> is what makes check_scratch_fs fail because of the extra output.
>>>> That's easy to fix - filter the line from the repair output and be
>>>> done with it. In future (with Eric's patch) this situation won't
>>>> occur.
>>>>
>>>> So, really, I think the only thing that needs modifying to handle
>>>> this situation is a filter update to xfstests...
>>>
>>> I must be missing something; quota will continue to set it and repair
>>> will continue to clear it.  One should probably match the other right?
>>> So one or the other should change.
>>
>> Sorry, I wasn't particularly clear - if your patch to quota goes in,
>> the problem goes away in future and we should simply filter the
>> warning in xfstests to handle the present issue....
> 
> I think Dave has an interesting idea here. 
> 
> You already have:
> 
> 1) only set XFS_XFLAG_PROJINHERIT on directories in setup_project,
> 
> 2) update check_project to print the right warning based upon the above,
> 
> Now all you need is:
> 
> 3) update _check_scratch_fs to filter
> 	"directory flags set on non-directory inode %llu"

Well, there is no project ID test which runs _check_scratch_fs anyway.

So at least for today, it's not an issue.

-Eric

> I guess the downside of that is the test might subsequently miss other
> related failure modes of xfs_repair.  Maybe it would be better to make
> xfs_repair have a separate error message for this specific case, and
> then filter that out of the test output.  How would you know when it's
> ok to remove the filter?
> 
> Regards,
> Ben
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
