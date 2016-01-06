Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 545EE7F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 09:59:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01467AC002
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 07:59:38 -0800 (PST)
Received: from na01-bl2-obe.outbound.protection.outlook.com
	(mail-bl2on0071.outbound.protection.outlook.com [65.55.169.71])
	by cuda.sgi.com with ESMTP id Xu5gfYr9O8Mjn4iN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2016 07:59:37 -0800 (PST)
Subject: Re: [dm-devel] [PATCH 01/35] block/fs/drivers: remove rw argument
	from submit_bio
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-2-git-send-email-mchristi@redhat.com>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Message-ID: <568D39DE.2060709@sandisk.com>
Date: Wed, 6 Jan 2016 16:59:26 +0100
MIME-Version: 1.0
In-Reply-To: <1452027218-32303-2-git-send-email-mchristi@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>

On 01/05/2016 09:53 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
>
> This has callers of submit_bio/submit_bio_wait set the bio->bi_rw
> instead of passing it in. This makes that use the same as
> generic_make_request and how we set the other bio fields.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
