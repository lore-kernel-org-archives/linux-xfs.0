Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2DE0D7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 15:30:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 042A88F8037
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 13:30:44 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id ioGBHgTUFRN5DZbe
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 13:30:40 -0800 (PST)
Message-ID: <52F944F9.7080500@fb.com>
Date: Mon, 10 Feb 2014 16:30:33 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4] xfstests/btrfs: add a regression test for running
	snapshot and send concurrently
References: <1391781656-9469-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1391781656-9469-1-git-send-email-wangshilong1991@gmail.com>
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
Cc: linux-btrfs@vger.kernel.org



On 02/07/2014 09:00 AM, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> Btrfs would fail to send if snapshot run concurrently, this test is to make
> sure we have fixed the bug.
>
>

Looks reasonable, ran it with and without the patch and it did as expected.

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
