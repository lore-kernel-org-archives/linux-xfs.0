Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 846887F4C
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 00:38:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63AE8304039
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 22:38:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id oOb3hwbXCq13qAcM for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 22:37:44 -0700 (PDT)
Message-ID: <51494B26.6020204@sandeen.net>
Date: Wed, 20 Mar 2013 00:37:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: add a new test case for ext4 indirect-based
	file
References: <1363683183-7392-1-git-send-email-wenqing.lz@taobao.com>
	<51489267.7080202@sandeen.net> <20130320054555.GB4017@gmail.com>
In-Reply-To: <20130320054555.GB4017@gmail.com>
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
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>

On 3/20/13 12:45 AM, Zheng Liu wrote:
>>> +f6aeca13ec49e5b266cd1c913cd726e3
>>> > > +	12. unwritten -> data -> unwritten
>> > 
>> > It's a little odd that the output contains "unwritten" when this test
>> > is explicitly for testing *without* unwritten extents.  Should this be
>> > cleaned up a little in common.punch, maybe?
> I will try to define a new function called _test_indirect_punch() to
> test punching hole without unwritten extent.

It's just the helper which prints "unwritten" regardless of what
is passed as "$alloc_cmd" to _test_generic_punch, right... so there's
nothing wrong with the test, really - it's just odd output.

I'm not sure it's worth a big copy & paste just to change
the output text, but if you can think of something simple to clean
it up, it might be worth it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
