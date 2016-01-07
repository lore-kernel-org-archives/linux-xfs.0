Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07D247F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 21:11:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ECE5A8F8040
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 19:11:37 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2Jl3z8YVIpl9IzDC for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 19:11:33 -0800 (PST)
Date: Thu, 7 Jan 2016 14:11:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/35] xfs: set bi_op to REQ_OP
Message-ID: <20160107031131.GB32200@dastard>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-14-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452027218-32303-14-git-send-email-mchristi@redhat.com>
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
To: mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On Tue, Jan 05, 2016 at 02:53:16PM -0600, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> This patch has xfs set the bio bi_op to a REQ_OP, and
> rq_flag_bits to bi_rw.
> 
> Note:
> I have run xfs tests on these btrfs patches. There were some failures
> with and without the patches. I have not had time to track down why
> xfstest fails without the patches.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  fs/xfs/xfs_aops.c |  3 ++-
>  fs/xfs/xfs_buf.c  | 27 +++++++++++++++------------
>  2 files changed, 17 insertions(+), 13 deletions(-)

Not sure which patches your note is refering to here.

The XFS change here looks fine.

Acked-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
