Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 91FCE7CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 01:50:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6036E8F8037
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 23:50:23 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id IAE3R4DQ9q0IIb4u (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 23:50:20 -0700 (PDT)
Subject: Re: [PATCH 37/45] drivers: use req op accessor
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-38-git-send-email-mchristi@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <57551D2B.1090707@suse.de>
Date: Mon, 6 Jun 2016 08:50:19 +0200
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-38-git-send-email-mchristi@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On 06/05/2016 09:32 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> =

> The req operation REQ_OP is separated from the rq_flag_bits
> definition. This converts the block layer drivers to
> use req_op to get the op from the request struct.
> =

> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/block/loop.c              |  6 +++---
>  drivers/block/mtip32xx/mtip32xx.c |  2 +-
>  drivers/block/nbd.c               |  2 +-
>  drivers/block/rbd.c               |  4 ++--
>  drivers/block/xen-blkfront.c      |  8 +++++---
>  drivers/ide/ide-floppy.c          |  2 +-
>  drivers/md/dm.c                   |  2 +-
>  drivers/mmc/card/block.c          |  7 +++----
>  drivers/mmc/card/queue.c          |  6 ++----
>  drivers/mmc/card/queue.h          |  5 ++++-
>  drivers/mtd/mtd_blkdevs.c         |  2 +-
>  drivers/nvme/host/core.c          |  2 +-
>  drivers/nvme/host/nvme.h          |  4 ++--
>  drivers/scsi/sd.c                 | 25 ++++++++++++++++---------
>  14 files changed, 43 insertions(+), 34 deletions(-)
> =

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
