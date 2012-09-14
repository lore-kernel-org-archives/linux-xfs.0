Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8EB4ZdY079472 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 06:04:35 -0500
Received: from oproxy8-pub.bluehost.com (oproxy8-pub.bluehost.com
	[69.89.22.20]) by cuda.sgi.com with SMTP id fcibcVWHhh3FbFZF
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 04:05:42 -0700 (PDT)
Message-ID: <50530F83.3070204@tao.ma>
Date: Fri, 14 Sep 2012 19:05:39 +0800
From: Tao Ma <tm@tao.ma>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: make 275 xfs specific.
References: <1336230429-2939-1-git-send-email-tm@tao.ma>
	<20120505233744.GE25351@dastard> <4FA692B7.9040006@tao.ma>
	<504A511A.8090209@sandeen.net> <504EA0C2.2060601@sandeen.net>
In-Reply-To: <504EA0C2.2060601@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 09/11/2012 10:24 AM, Eric Sandeen wrote:
> On 9/7/12 2:55 PM, Eric Sandeen wrote:
>> On 5/6/12 10:03 AM, Tao Ma wrote:
>>> On 05/06/2012 07:37 AM, Dave Chinner wrote:
>>>> On Sat, May 05, 2012 at 11:07:09PM +0800, Tao Ma wrote:
>>>>> From: Tao Ma <boyu.mt@taobao.com>
>>>>>
>>>>> In my test with ext4, 275 can't pass because ext4
>>>>> can create a 8k file in the end not like what xfs
>>>>> does. So make this test case xfs only for now.
>>>>
>>>> It's not an XFS specific test - it's a test that is supposed to test
>>>> POSIX write behaviour. i.e. if the filesystem is full, and then you
>>>> free 4k of space, then an 8k write should only be able to write 4k,
>>>> yes?
>>> Yes, but it doesn't work as expected for ext4.
>>
>> Came across this thread again.  I had patches on the list a while ago
>> to fix it up.
>>
>> [PATCH V2] xfstests: make 275 pass
>>
>> But it never got fully reviewed or merged.   :(
> 
> It's reviewed & merged now.  Does it fix things for you?  (I hope?)
No, but much better.
It removes "lost+found" after mkfs, so the fsck will complain about it.

So I have created the corresponding patch for it, and now the test case
pass. Please see my patch "xfstests: 275, Don't remove all the files in
SCRATCH_MNT".


Thanks
Tao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
