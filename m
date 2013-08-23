Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72E2429DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 08:18:46 -0500 (CDT)
Message-ID: <52176134.6090905@sgi.com>
Date: Fri, 23 Aug 2013 08:18:44 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS: Assertion failed: first <= last && last <
	BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
References: <52165830.8050006@redhat.com>
In-Reply-To: <52165830.8050006@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 08/22/13 13:28, Brian Foster wrote:
> Hi all,
>
> I hit an assert on a debug kernel while beating on some finobt work and
> eventually reproduced it on unmodified/TOT xfs/xfsprogs as of today. I
> hit it through a couple different paths, first while running fsstress on
> a CRC enabled filesystem (with otherwise default mkfs options):
>
> (These tests are running on a 4p, 4GB VM against a 100GB virtio disk,
> hosted on a single spindle desktop box).

Eeek.

So both crashes are directory related. What is the top XFS kernel commit 
for these tests?

Have you seen this on earlier versions of the kernel?

Thanks,

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
