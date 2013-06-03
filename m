Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E9A27CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 07:41:05 -0500 (CDT)
Message-ID: <51AC8F20.8030501@sgi.com>
Date: Mon, 3 Jun 2013 07:42:08 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix seek_sanity_test for fs w/o fallocate
References: <51A8C59B.3030308@redhat.com>
In-Reply-To: <51A8C59B.3030308@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 05/31/2013 10:45 AM, Eric Sandeen wrote:
> currently the seek_sanity_test (generic/285) fails on ext3
> or ext2 due to fallocate() failures.  Just ignore that test
> if the fs doesn't support fallocate.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks Eric and Zheng, this has been committed.

commit 3e889c6735117e0906c339ffae0dbc17a4df27fb
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Jun 3 07:28:17 2013 -0500

     xfstests: fix seek_sanity_test for fs w/o fallocate

(Rich adds another step to his commit procedure to prevent this from 
happening again)

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
