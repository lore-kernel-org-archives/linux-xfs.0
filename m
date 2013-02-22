Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 180C37F37
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 13:14:30 -0600 (CST)
Date: Fri, 22 Feb 2013 13:14:26 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Message-ID: <20130222191426.GW22182@sgi.com>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
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
To: Tony Lu <zlu@tilera.com>
Cc: Alex Elder <elder@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

Hi Tony,

On Fri, Feb 22, 2013 at 08:12:52AM +0000, Tony Lu wrote:
> I encountered the following panic when using xfs partitions as rootfs, which
> is due to the truncated log data read by xlog_bread_noalign(). We should
> extend the buffer by one extra log sector to ensure there's enough space to
> accommodate requested log data, which we indeed did in xlog_get_bp(), but we
> forgot to do in xlog_bread_noalign().
> 
> XFS mounting filesystem sda2
> Starting XFS recovery on filesystem: sda2 (logdev: internal)
> XFS: xlog_recover_process_data: bad clientid
> XFS: log mount/recovery failed: error 5
> XFS: log mount failedVFS: Cannot open root device "sda2" or unknown-block(8,)
> Please append a correct "root=" boot option; here are the available partitio:
> 0800       156290904 sda  driver: sd
>   0801        31463271 sda1 00000000-0000-0000-0000-000000000000
>   0802        31463302 sda2 00000000-0000-0000-0000-000000000000
>   0803        31463302 sda3 00000000-0000-0000-0000-000000000000
>   0804               1 sda4 00000000-0000-0000-0000-000000000000
>   0805        10490413 sda5 00000000-0000-0000-0000-000000000000
>   0806        51407968 sda6 00000000-0000-0000-0000-000000000000
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,)
> 
> Starting stack dump of tid 1, pid 1 (swapper) on cpu 35 at cycle 42273138234
>   frame 0: 0xfffffff70016e5a0 dump_stack+0x0/0x20 (sp 0xfffffe03fbedfe88)
>   frame 1: 0xfffffff7004af470 panic+0x150/0x3a0 (sp 0xfffffe03fbedfe88)
>   frame 2: 0xfffffff700881e88 mount_block_root+0x2c0/0x4c8 (sp 0xfffffe03fbe)
>   frame 3: 0xfffffff700882390 prepare_namespace+0x250/0x358 (sp 0xfffffe03fb)
>   frame 4: 0xfffffff700880778 kernel_init+0x4c8/0x520 (sp 0xfffffe03fbedffb0)
>   frame 5: 0xfffffff70011ecb8 start_kernel_thread+0x18/0x20 (sp 0xfffffe03fb)
> Stack dump complete
> 
> Signed-off-by: Zhigang Lu <zlu@tilera.com>
> Reviewed-by: Chris Metcalf <cmetcalf@tilera.com>

Looks fine to me.  I'll pull it in after some testing.

Do you happen to have a metadump of this filesystem?

Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks!
-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
