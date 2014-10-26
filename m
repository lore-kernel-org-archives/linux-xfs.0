Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D58A97F4E
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 12:26:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 64C9AAC002
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 10:26:32 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id lGfgdCyGhGM8AIS5
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 10:26:28 -0700 (PDT)
Message-ID: <544D2EE1.3080304@hardwarefreak.com>
Date: Sun, 26 Oct 2014 12:26:57 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: file streams allocator behavior
References: <544BF26F.6000708@clear.net.nz>
	<544C159E.8010408@hardwarefreak.com>
	<20141026142559.GA61711@bfoster.bfoster>
In-Reply-To: <20141026142559.GA61711@bfoster.bfoster>
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
Cc: Richard Scobie <r.scobie@clear.net.nz>, xfs@oss.sgi.com



On 10/26/2014 09:26 AM, Brian Foster wrote:
> On Sat, Oct 25, 2014 at 04:26:54PM -0500, Stan Hoeppner wrote:
>> On 10/25/2014 01:56 PM, Richard Scobie wrote:
>>> Stan Hoeppner said:
>>>
>>>> How can I disable or change the filestreams behavior so all files go
>>>> into the one AG for the single directory test?
>>>
>>> Hi Stan,
>>>
>>> Instead of mounting with -o filestreams, would using the chattr flag
>>> instead help?
>>>
>>> See
>>> http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch06s16.html
>>
>> That won't help.  That turns it on (if it's not enabled by default these
>> days).  I need to turn off the behavior I'm seeing, whether it's due to
>> the filestreams allocator or default inode64.  Then again it may not be
>> possible to turn it off...
>>
>> Anyone have other ideas on how to accomplish my goal?  Parallel writes
>> to a single AG on the outer platter edge vs the same to all AGs across
>> the entire platter?  I'm simply trying to demonstrate the differences in
>> aggregate bandwidth due to the extra seek latency of all AGs case.
>>
> 
> What about just preallocating the files? Obviously this removes block
> allocation contention from your experiment, but it's not clear if that's
> relevant to your test. If I create a smaller, but analogous fs to yours,
> I seem to get this behavior from just doing an fallocate of each file in
> advance.
> 
> E.g., Create directory 0, fallocate 44 files all of which end up in AG
> 0. Create directory 1, fallocate 44 files which end up in AG 1, etc.
> From there you can do direct I/O overwrites to 44 files across each AG
> or 44 files in any single AG.

I figured preallocating would get me what I want but I've never used
fallocate, nor dd into fallocated files.  Is there anything special
required here with dd, or can I simply specify the filename to dd, and
make sure bs + count doesn't go beyond EOF?

Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
