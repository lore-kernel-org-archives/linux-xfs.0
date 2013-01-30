Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 860F47F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 16:51:28 -0600 (CST)
Date: Wed, 30 Jan 2013 16:51:25 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
Message-ID: <20130130225125.GO27055@sgi.com>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
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
To: Tom <storm9c1@skymagik.com>
Cc: xfs@oss.sgi.com

Hi Tom,

On Tue, Jan 29, 2013 at 10:16:20PM -0500, Tom wrote:
> I've update the CentOS bug (http://bugs.centos.org/view.php?id=6217) with
> the following information:
> 
> 
> -- More detail about the hang including traceback --
> 
> Using 5.9 kernel (348) without md raid:
> Please stand by while rebooting the system...
> md: stopping all md devices.
> Synchronizing SCSI cache for disk sda:
> Restarting system.
> ..
> machine restart
> (reboots normally)
> 
> 
> With md raid1:
> Unmounting pipe file systems:
> Unmounting file systems:
> Please stand by while rebooting the system...
> md: stopping all md devices.
> md: md2 switched to read-only mode.
> md: md1 switched to read-only mode.
> (hang)
> 
> Traceback:
> INFO: task reboot:2063 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> reboot        D ffff810037df37e0     0  2063      1                  19
> (NOTLB)
>  ffff81005890ba08 0000000000000082 ffff81005890ba58 ffff81005beb1ea0
>  0000000000000001 0000000000000007 ffff810058d67040 ffff810037df37e0
>  000000596dd8a1e6 0000000000003df4 ffff810058d67228 000000008008d76f
> Call Trace:
>  [<ffffffff8002e4bc>] __wake_up+0x38/0x4f
>  [<ffffffff80223bce>] md_write_start+0xf2/0x108
>  [<ffffffff800a3bc2>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8000ab62>] get_page_from_freelist+0x380/0x442
>  [<ffffffff880b102c>] :raid1:make_request+0x38/0x5d8
>  [<ffffffff8001c839>] generic_make_request+0x211/0x228
>  [<ffffffff8002389f>] mempool_alloc+0x31/0xe7
>  [<ffffffff8001a98f>] vsnprintf+0x5d7/0xb54
>  [<ffffffff80033695>] submit_bio+0xe6/0xed

I think you should consider copying linux-raid@vger.kernel.org.

Did you have a chance to get the sysrq output?  It would be helpful to see the
other tasks on your machine.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
