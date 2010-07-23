Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6N3YSR5177020 for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 22:34:29 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FAC446AD17
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 20:37:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FcnC4QNi26zpNHyj for
	<xfs@oss.sgi.com>; Thu, 22 Jul 2010 20:37:30 -0700 (PDT)
Message-ID: <4C490E70.3030902@redhat.com>
Date: Thu, 22 Jul 2010 22:37:20 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 240: test non-aligned AIO hole-filling
References: <4C489676.2000605@redhat.com> <20100723024938.GD32635@dastard>
	<4C490D4D.603@redhat.com>
In-Reply-To: <4C490D4D.603@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Dave Chinner wrote:

...

   
>> looks good - it needs to remove the $TEST_DIR/aiodio_sparse file
>> before the test starts, though, so that repeated tests fail
>> correctly. Otherwise:
>>
>>   
> hm, but:
> 
> +rm -f "$TEST_DIR/aiodio_sparse*"
> +
> +# 2 threads, 4k writes, 16k filesize, stride throug file by 4k, start at 512 offset
> +$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w 4k -s 16k -n 4k -o 512 "$TEST_DIR/aiodio_sparse"
> 
> It does remove it ... no?

hm, no, what are those quotes doing there...

Ok, will fix up thanks.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
