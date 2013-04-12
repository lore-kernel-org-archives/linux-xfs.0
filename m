Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 272A17CBF
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 13:42:21 -0500 (CDT)
Message-ID: <51685552.6030808@sgi.com>
Date: Fri, 12 Apr 2013 13:41:22 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: make install support common/ and tests/ dirs
References: <51678D0D.1070002@gmail.com> <20130412074034.GC30622@dastard>
	<5168396C.6020801@gmail.com>
In-Reply-To: <5168396C.6020801@gmail.com>
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
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>

On 04/12/2013 11:42 AM, Wang Sheng-Hui wrote:
>
> Hi Dave,
>
> I introduces Makefile under tests/, which would return to TESTS_SUBDIRS
> with the
> $(dir function. By running find in $(shell, TEST_SUBDIRS will only get
> the dir names,
> and no Makefile.
>
> Regards,
> Sheng-Hui

Thanks addressing comments and for v2 of this patch.

I still had issues with Makefile which I corrected at commit time.

Thanks again for the patch, it has been committed,
--Rich

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


commit 2519a97d1083efca79006ba5bd4ddb9f4af65a5e
Author: Wang Sheng-Hui <shhuiw@gmail.com>
Date:   Fri Apr 12 04:26:53 2013 +0000

     xfstests: make install support common/ and tests/ dirs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
