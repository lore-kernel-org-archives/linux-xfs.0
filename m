Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 021F57F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 13:18:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E195AC00B
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 11:18:24 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id Xx7sm0CagRW3sCAi
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 11:18:20 -0800 (PST)
Message-ID: <52F925EA.20600@fb.com>
Date: Mon, 10 Feb 2014 14:18:02 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/004: fix to make test really work
References: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Wang Shilong <wangshilong1991@gmail.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, Wang Shilong <wangsl.fnst@cn.fujitsu.com>



On 02/10/2014 07:10 AM, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> So i was wandering why test 004 could pass my previous wrong
> kernel patch while it defenitely should not.
>
> By some debugging, i found here perl script is wrong, we did not
> filter out anything and this unit test did not work acutally.so
> it came out we will never fail this test.
>

So now with this patch I'm failing it, is there some btrfs patch I need 
to make it not fail or is it still not supposed to fail normally and is 
this patch broken?  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
