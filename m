Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q87Js69o191036 for <xfs@oss.sgi.com>; Fri, 7 Sep 2012 14:54:06 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id dsiMMHtypg4e22KB for <xfs@oss.sgi.com>;
	Fri, 07 Sep 2012 12:55:06 -0700 (PDT)
Message-ID: <504A511A.8090209@sandeen.net>
Date: Fri, 07 Sep 2012 14:55:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: make 275 xfs specific.
References: <1336230429-2939-1-git-send-email-tm@tao.ma>
	<20120505233744.GE25351@dastard> <4FA692B7.9040006@tao.ma>
In-Reply-To: <4FA692B7.9040006@tao.ma>
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
To: Tao Ma <tm@tao.ma>
Cc: xfs@oss.sgi.com

On 5/6/12 10:03 AM, Tao Ma wrote:
> On 05/06/2012 07:37 AM, Dave Chinner wrote:
>> On Sat, May 05, 2012 at 11:07:09PM +0800, Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>>
>>> In my test with ext4, 275 can't pass because ext4
>>> can create a 8k file in the end not like what xfs
>>> does. So make this test case xfs only for now.
>>
>> It's not an XFS specific test - it's a test that is supposed to test
>> POSIX write behaviour. i.e. if the filesystem is full, and then you
>> free 4k of space, then an 8k write should only be able to write 4k,
>> yes?
> Yes, but it doesn't work as expected for ext4.

Came across this thread again.  I had patches on the list a while ago
to fix it up.

[PATCH V2] xfstests: make 275 pass

But it never got fully reviewed or merged.   :(

-Eric

>> So doesn't a failure on ext4 indicate that there's something wrong
>> with ext4 (either it's ENOSPC detection or the short write
>> handling), not the test?
> Actually in my test, ext4 can create the file with 8K file size, not a
> short write. I haven't looked into it yet. But AFAICS, if we have an
> ext4 volume with 8k cluster size, a 4k file can occupy a 8k cluster and
> the final write of 8k will succeed instead of the short write.
> 
> Thanks
> Tao
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
