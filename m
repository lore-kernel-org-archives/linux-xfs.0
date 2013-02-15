Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4D2E8049
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 07:24:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8E7DD8F8033
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 05:24:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fGEhahMgHZWquEpw for
	<xfs@oss.sgi.com>; Fri, 15 Feb 2013 05:23:59 -0800 (PST)
Message-ID: <511E3495.8020508@redhat.com>
Date: Fri, 15 Feb 2013 08:13:57 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: XFS slow when project quota exceeded (again)
References: <20130214131452.GB605@quack.suse.cz>
	<20130215071607.GT26694@dastard>
	<20130215103831.GA7458@quack.suse.cz>
In-Reply-To: <20130215103831.GA7458@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com, dchinner@redhat.com

On 02/15/2013 05:38 AM, Jan Kara wrote:
> On Fri 15-02-13 18:16:07, Dave Chinner wrote:
>> On Thu, Feb 14, 2013 at 02:14:52PM +0100, Jan Kara wrote:
...
>> The fix to that problem is mentioned here:
>>
>> http://www.spinics.net/lists/xfs/msg15186.html
>>
>> Which is to:
>>
>> 	a) throttle speculative allocation as EDQUOT approaches; and
>> 	b) efficiently track speculative preallocation
>> 	   for all the inodes in the given project, and write back
>> 	   and trim those inodes on ENOSPC.
>>
>> both of those are still a work in progress. I was hoping that we'd
>> have a) in 3.9, but that doesn't seem likely now the merge window is
>> just about upon us....
>   Yeah, I know someone is working on a better solution. I was mostly
> wondering why writeback_inodes_sb() isn't enough - i.e. why do you really
> need to wait for IO completion. And you explained that below. Thanks!
> 

Sorry, I think the work for a) is pretty close [1]. We've had a bug fix
or two in this area and the speculative prealloc algorithm update to
handle sparse files since v2, so I have to rebase against those changes
and continue some sanity testing. I'll try to have something available
over the next week or so.

The last bits required for b) (i.e., the pquota ENOSPC trigger) is a bit
further out, but FWIW I have an RFC posted [2] to get some early design
feedback on a solution.

Brian

[1] - v2 - http://oss.sgi.com/archives/xfs/2013-01/msg00006.html
[2] - http://oss.sgi.com/archives/xfs/2012-12/msg00112.html

>> It's trying to prevent the filesystem for falling into worst case IO
>> patterns at ENOSPC when there are hundreds of threads banging on the
>> filesystem and essentially locking up the system. i.e. we have to
>> throttle the IO submission rate from ENOSPC flushing artificially -
>> we really only need one thread doing the submission work, so we need
>> to throttle all concurrent callers while we are doing that work.
>> sync_inodes_sb() does that. And then we need to prevent individual
>> callers from trying to allocate space too frequently, which we do by
>> waiting for IO that was submitted in the flush. sync_inodes_sb()
>> does that, too.
>   I see so the waiting for IO isn't really a correctness thing but just a
> way to slow down processes bringing fs out of space so that they don't lock
> up the system. Thanks for explanation!
> 
> 								Honza
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
