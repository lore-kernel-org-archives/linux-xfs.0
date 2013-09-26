Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD00D7F3F
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 18:46:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C4DB58F8049
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 16:46:12 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id gPufQ2kbmDGNGHq9
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 16:46:11 -0700 (PDT)
Message-ID: <5244C742.3080003@hardwarefreak.com>
Date: Thu, 26 Sep 2013 18:46:10 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Issues and new to the group
References: <0e4201cebaae$24873680$6d95a380$@host2max.com>	<5244234D.1010603@hardwarefreak.com>
	<100f01cebaba$0ae84280$20b8c780$@host2max.com>
	<101601cebabc$8acb99a0$a062cce0$@host2max.com>
	<52444355.50904@sandeen.net>
In-Reply-To: <52444355.50904@sandeen.net>
Reply-To: stan@hardwarefreak.com
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
Cc: xfs@oss.sgi.com, Ronnie Tartar <rtartar@host2max.com>

On 9/26/2013 9:23 AM, Eric Sandeen wrote:
> On 9/26/13 8:30 AM, Ronnie Tartar wrote:
>> Stan, looks like I have directory fragmentation problem.
>>
>> xfs_db> frag -d
>> actual 65057, ideal 4680, fragmentation factor 92.81%
>>
>> What is the best way to fix this?
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F
> 
> We should just get rid of that command, TBH.
> 
> So your dirs are in an average of 65057/4680 or about 14 fragments each.
> Really not that bad, in the scope of things.
> 
> I'd imagine that this could be more of your problem:
> 
>> The
>> folders are image folders that have anywhere between 5 to 10 million images
>> in each folder.
> 
> at 10 million entries in a dir, you're going to start slowing down on inserts
> due to btree management.  But that probably doesn't account for multiple seconds for
> a single file.
> 
> So really,it's not clear *what* is slow.
> 
>> It takes about 2.5 to 3.5 seconds to write a single file.
> 
> strace with timing would be a very basic way to get a sense of what is slow;
> is it the file open/create?  How big is the file, are you doing buffered or
> direct IO?
> 
> On a more modern OS you could do some of the tracing suggested in
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> but some sort of profiling (oprofile, perhaps) might tell you where time is being spent in the kernel.
> 
> When you say suddenly started, was it after a kernel upgrade or other change?

Eric is an expert on this, much more knowledgeable than me.  And somehow
I missed the 5-10 million files per dir.  Maybe you have multiple issues
here adding up to large delays.  In addition to the steps Eric
recommends, it can't hurt to go ahead and take a look at the free space
map.  Depending on how the filesystem has aged this could be a factor,
such as being 90%+ full at one time, and then lots of files being deleted.

# xfs_db -r -c freesp /dev/[device]

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
