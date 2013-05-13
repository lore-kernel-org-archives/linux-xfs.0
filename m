Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 99C277CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 08:51:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0FDBCAC001
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 06:51:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0SdxM8PcYWNQdoO0 for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 06:51:22 -0700 (PDT)
References: <1368358464-11173-1-git-send-email-wenqing.lz@taobao.com>
	<20130513004439.GJ32675@dastard> <20130513093245.GA8570@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130513093245.GA8570@gmail.com>
Message-Id: <E2B63DD4-E0E4-4F26-87A1-E3248567FCB4@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v4] xfstests: add a new test case for ext4 indirect-based
	file
Date: Mon, 13 May 2013 08:51:20 -0500
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Rich Johnston <rjohnston@sgi.com>, Zheng Liu <wenqing.lz@taobao.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On May 13, 2013, at 4:32 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:

> On Mon, May 13, 2013 at 10:44:39AM +1000, Dave Chinner wrote:
>> On Sun, May 12, 2013 at 07:34:24PM +0800, Zheng Liu wrote:
>>> From: Zheng Liu <wenqing.lz@taobao.com>
>>> 
>>> After applied this commit (864688d3), xfstests #255 will not test a
>>> file system that cannot support fallocate(2), such as a indirect-based
>>> file in ext4.  So we need to add a new generic test case to test it.
>>> 
>>> The difference between #255 and this test case is only to use pwrite to
>>> allocate blocks.  Other filesystems should survive in this test case.
>>> In the mean time, a new argument '-u' is added into _test_generic_punch
>>> not to run unwritten tests.
>>> 
>>> Meanwhile this commit fixes a minor problem in #255 that testfile should
>>> use $seq.$$ as testfile.
>>> 
>>> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>>> Cc: Eric Sandeen <sandeen@sandeen.net>
>>> Cc: Dave Chinner <david@fromorbit.com>
>>> Cc: Rich Johnston <rjohnston@sgi.com>
>> 
>> This will need to be rebased on top of Eric's patch that removes the
>> need to pass -F to xfs_io for non-xfs filesystems....
> 
> Hi Dave,
> 
> Thanks for review.  I guess that you metioned this patch, right?
>  [PATCH] xfstests: automatically add -F to xfs_io on non-xfs
> 
> But I couldn't find it in xfstests tree.  Has it been applied into the
> tree?  Or maybe I use a wrong tree to generate my patch.  I clone the
> tree from here:
>  git://oss.sgi.com/xfs/cmds/xfstests
> 
> Is that right?  Or maybe I need to apply Eric's patch manually and
> rebase my patch?
> 
That's the right patch, it's just not yet merged.  You can just drop any "-F" from your xfs_io commands.

Thanks,
Eric

>> 
>>> --- a/tests/generic/group
>>> +++ b/tests/generic/group
>>> @@ -114,3 +114,4 @@
>>> 309 auto quick
>>> 310 auto
>>> 311 auto metadata log
>>> +314 auto quick prealloc
>> 
>> Why would you add it to the prealloc group? The whole point of the
>> test is that it doesn't use prealloc, right?
> 
> Good catch!  Fix it soon.
> 
> Thanks,
>                                                - Zheng
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
