Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0C6D7CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 01:45:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3AC24AC004
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 23:45:42 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id KAA5aBtYm42FoVBe (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 23:45:40 -0700 (PDT)
Subject: Re: [PATCH 25/45] bcache: use bio op accessors
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-26-git-send-email-mchristi@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <57551BF2.6060000@suse.de>
Date: Mon, 6 Jun 2016 08:45:06 +0200
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-26-git-send-email-mchristi@redhat.com>
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

> Separate the op from the rq_flag_bits and have bcache
> set/get the bio using bio_set_op_attrs/bio_op.
> =

> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/md/bcache/btree.c     |  4 ++--
>  drivers/md/bcache/debug.c     |  4 ++--
>  drivers/md/bcache/journal.c   |  7 ++++---
>  drivers/md/bcache/movinggc.c  |  2 +-
>  drivers/md/bcache/request.c   | 14 +++++++-------
>  drivers/md/bcache/super.c     | 24 +++++++++++++-----------
>  drivers/md/bcache/writeback.c |  4 ++--
>  7 files changed, 31 insertions(+), 28 deletions(-)
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
