Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 875A67CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 01:53:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4970C8F8037
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 23:53:07 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id W4n0Kr2VM9HeGdrM (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 23:53:05 -0700 (PDT)
Subject: Re: [PATCH 42/45] block, fs, drivers: remove REQ_OP compat defs and
	related code
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-43-git-send-email-mchristi@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <57551DD0.9090703@suse.de>
Date: Mon, 6 Jun 2016 08:53:04 +0200
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-43-git-send-email-mchristi@redhat.com>
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

> This patch drops the compat definition of req_op where it matches
> the rq_flag_bits definitions, and drops the related old and compat
> code that allowed users to set either the op or flags for the operation.
> =

> We also then store the operation in the bi_rw/cmd_flags field similar
> to how we used to store the bio ioprio where it sat in the upper bits
> of the field.
> =

> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/scsi/sd.c           |  2 +-
>  include/linux/bio.h         |  3 ---
>  include/linux/blk_types.h   | 52 +++++++++++++++++----------------------=
------
>  include/linux/blkdev.h      | 14 ++++++++----
>  include/linux/fs.h          | 37 +++++++++++++-------------------
>  include/trace/events/f2fs.h |  1 -
>  6 files changed, 46 insertions(+), 63 deletions(-)
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
