Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BNaiYD163400 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 17:36:45 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F96310EA4A
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:36:08 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id DtzvwOoLHBmzzsSY for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:36:08 -0800 (PST)
Date: Wed, 11 Feb 2009 18:36:08 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: BUG: soft lockup detected on CPU#1!
In-Reply-To: <586998.47540.qm@web30208.mail.mud.yahoo.com>
Message-ID: <alpine.DEB.1.10.0902111835420.27406@p34.internal.lan>
References: <586998.47540.qm@web30208.mail.mud.yahoo.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: raksac@yahoo.com
Cc: xfs@oss.sgi.com


On Wed, 11 Feb 2009, raksac@yahoo.com wrote:

>
> Hi Justin,
>
> Thank you for the pointer. Well as suggested I did and
> now the xfsqa goes upto test 011
>
> #! /bin/sh
> # FS QA Test No. 011
> #
> # dirstress
>
> but dies with a oops. Any suggestions?
>
> Here is the oops trace -
>
> BUG: unable to handle kernel NULL pointer dereference
> at virtual address 00000000
> printing eip:
> f8bd02c2
> *pde = e7167067
> Oops: 0000 [#1]
> PREEMPT SMP
> last sysfs file:
> /devices/pci0000:00/0000:00:1f.3/i2c-0/0-002e/temp1_input
> Modules linked in: xfs sg sunrpc m24c02 pca9554
> pca9555 mcp23016 lm85 hwmon_vid i2c_i801 i2c_core
> midplane uhci_hcd sk98lin tg3 e1000 mv_sata sd_mod
> ahci libata
> CPU:    1
> EIP:    0060:[<f8bd02c2>]    Not tainted VLI
> EFLAGS: 00010286   (2.6.18.rhel5 #2)
> EIP is at xfs_iget_core+0x4d6/0x5e9 [xfs]

Can you show uname -a output?

EFLAGS: 00010286   (2.6.18.rhel5 #2)
                     ^^^^^^^^^^^^

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
