Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A9CB7F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 13:06:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D39B304066
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 11:06:05 -0800 (PST)
Received: from linux-iscsi.org (mail.linux-iscsi.org [67.23.28.174]) by
	cuda.sgi.com with ESMTP id TKG9iIz13BG4DWHD (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2016 11:06:02 -0800 (PST)
Message-ID: <1452107160.26125.39.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 25/35] target: set bi_op to REQ_OP
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Wed, 06 Jan 2016 11:06:00 -0800
In-Reply-To: <1452027218-32303-26-git-send-email-mchristi@redhat.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-26-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
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

Hi Mike,

On Tue, 2016-01-05 at 14:53 -0600, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> This patch has the target modules set the bio bi_op to a REQ_OP, and
> rq_flag_bits to bi_rw.
> 
> This patch is compile tested only.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_iblock.c | 38 ++++++++++++++++++++++---------------
>  drivers/target/target_core_pscsi.c  |  2 +-
>  2 files changed, 24 insertions(+), 16 deletions(-)
> 

Nice work to clean this long standing abuse.  ;)

For the target/iblock bit:

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
