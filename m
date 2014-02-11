Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D73D7F3F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 07:25:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB9528F8035
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 05:25:48 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id Wn9fSlQX9DKpDtxJ
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 05:25:47 -0800 (PST)
Message-ID: <52FA24CB.3070103@fb.com>
Date: Tue, 11 Feb 2014 08:25:31 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: btrfs/004: fix to make test really work
References: <1392113204-29237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392113204-29237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org



On 02/11/2014 05:06 AM, Wang Shilong wrote:
> So i was wondering why test 004 could pass my previous wrong
> kernel patch while it defenitely should not.
>
> By some debugging, i found here perl script is wrong, we did not
> filter out anything and this unit test did not work acutally.so
> it came out we will never fail this test.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---

This works for me, you can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
