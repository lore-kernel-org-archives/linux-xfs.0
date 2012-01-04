Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04EubtG147907 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 08:56:37 -0600
Message-ID: <4F0468A0.3090908@sgi.com>
Date: Wed, 04 Jan 2012 08:56:32 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore: incorrect restore if file becomes a dir
References: <20111226201856.GA3909@davidb.org> <4F036FF6.2080501@sgi.com>
	<20120103213147.GS23662@dastard> <4F0384A4.6000505@sgi.com>
	<20120103231604.GT23662@dastard>
In-Reply-To: <20120103231604.GT23662@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: David Brown <davidb@davidb.org>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Tue, Jan 03, 2012 at 04:43:48PM -0600, Bill Kendall wrote:
>> On 01/03/2012 03:31 PM, Dave Chinner wrote:
>>> On Tue, Jan 03, 2012 at 03:15:34PM -0600, Bill Kendall wrote:
>>>> On 12/26/2011 02:18 PM, David Brown wrote:
>>>>> http://oss.sgi.com/bugzilla/show_bug.cgi?id=915
>>>>>
>>>>> I've had this happen again. It appears to be the case if between
>>>>> incremental dumps, a file is deleted and a directory is created that
>>>>> gets the same inode number. The restore leaves a file in place of the
>>>>> directory. If the new directory has any contents, xfsrestore prints a
>>>>> warning, and doesn't restore the subdirectory contents.
>>>>>
>>>>> Given the sparseness of inodes, this doesn't seem to occur all that
>>>>> frequently, but I do have a couple of backups that exhibit the
>>>>> behavior. If no one has any ideas, I'll start digging through
>>>>> xfsrestore to see if I can figure out what is happening.
>>>> I haven't looked at the relevant code, but it sounds like the inode
>>>> generation number would also have to be the same in order for this
>>>> to happen. Two inodes from separate backups are only considered to
>>>> be the same file or directory if the inode number and the lower 12
>>>> bits of the inode generation number are the same.
>>> Why does dump only use the lower twelve bits? The on-disk generation
>>> number is 32 bits and we use all of it (by way of random numbers) to
>>> distinguish between different inode generations. That sounds like
>>> something that needs to be fixed....
>> I don't know the history there, but it dates back to when the generation
>> number was not randomly initialized. So an inode had to be reused 4,096
>> times for a collision to occur.
> 
> That's kind of what I thought. But even so, with the way XFS reuses
> inodes (especially for short term temporary files), those 12 bits
> can eaily be burnt through in under a second....
> 
>> With the current scheme (initially
>> random, then incremented) there would be cases where a collision
>> happens more frequently. I agree, it should be changed.
> 
> Is that difficult to do?

It requires a change to the dump format, so most of the work is
probably in maintaining backwards compatibility.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
