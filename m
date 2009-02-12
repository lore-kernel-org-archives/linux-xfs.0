Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CGTX2x056611 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 10:29:33 -0600
Received: from web30205.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 184F519222CF
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 08:28:57 -0800 (PST)
Received: from web30205.mail.mud.yahoo.com (web30205.mail.mud.yahoo.com
	[209.191.69.52]) by cuda.sgi.com with SMTP id 7AMGc1lidsgEoH2A
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 08:28:57 -0800 (PST)
Message-ID: <235313.30733.qm@web30205.mail.mud.yahoo.com>
Date: Thu, 12 Feb 2009 01:22:16 -0800 (PST)
From: <raksac@yahoo.com>
Subject: Re: BUG: soft lockup detected on CPU#1!
In-Reply-To: <alpine.DEB.1.10.0902111835420.27406@p34.internal.lan>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com


Hi Justin,

Yes it is a 2.6.18 rhel5 based custom kernel but the
XFS driver is a back port from the 2.6.28.4

Thanks,
Rakesh

--- Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> 
> On Wed, 11 Feb 2009, raksac@yahoo.com wrote:
> 
> >
> > Hi Justin,
> >
> > Thank you for the pointer. Well as suggested I did
> and
> > now the xfsqa goes upto test 011
> >
> > #! /bin/sh
> > # FS QA Test No. 011
> > #
> > # dirstress
> >
> > but dies with a oops. Any suggestions?
> >
> > Here is the oops trace -
> >
> > BUG: unable to handle kernel NULL pointer
> dereference
> > at virtual address 00000000
> > printing eip:
> > f8bd02c2
> > *pde = e7167067
> > Oops: 0000 [#1]
> > PREEMPT SMP
> > last sysfs file:
> >
>
/devices/pci0000:00/0000:00:1f.3/i2c-0/0-002e/temp1_input
> > Modules linked in: xfs sg sunrpc m24c02 pca9554
> > pca9555 mcp23016 lm85 hwmon_vid i2c_i801 i2c_core
> > midplane uhci_hcd sk98lin tg3 e1000 mv_sata sd_mod
> > ahci libata
> > CPU:    1
> > EIP:    0060:[<f8bd02c2>]    Not tainted VLI
> > EFLAGS: 00010286   (2.6.18.rhel5 #2)
> > EIP is at xfs_iget_core+0x4d6/0x5e9 [xfs]
> 
> Can you show uname -a output?
> 
> EFLAGS: 00010286   (2.6.18.rhel5 #2)
>                      ^^^^^^^^^^^^
> 



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
