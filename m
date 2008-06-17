Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 10:28:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5HHSe7A009997
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 10:28:40 -0700
Received: from web34508.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 6C3B923E7A8
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 10:29:37 -0700 (PDT)
Received: from web34508.mail.mud.yahoo.com (web34508.mail.mud.yahoo.com [66.163.178.174]) by cuda.sgi.com with SMTP id F1zgtmdrCaSDsZyu for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 10:29:37 -0700 (PDT)
Date: Tue, 17 Jun 2008 10:29:37 -0700 (PDT)
From: Mark <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Re: XFS mkfs/mount options
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <338502.8443.qm@web34508.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--- On Tue, 6/17/08, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> Subject: Re: XFS mkfs/mount options
> To: "Mark" <musicman529@yahoo.com>
> Cc: xfs@oss.sgi.com
> Date: Tuesday, June 17, 2008, 5:27 AM
> 
> How did you tune your IRQ delivery?

Generically:

echo X > /proc/irq/[IRQ#]/smp_affinity

Where X is a 32-bit hexadecimal bitmask.

My real procedure:

First, I confirmed that both drives (sda and sdb) were triggering different interrupts on the same CPU. "cat /dev/sda > /dev/null &" for activity, followed by "cat /proc/interrupts" a few times. (NOT AS ROOT!) Interrupt 20 was triggering only on the second CPU. Killed the background task.

Repeat, using "cat /dev/sdb > /dev/null &". Interrupt 21, also routing to the second CPU. Bottleneck likely confirmed.

A short hunt in /usr/src/linux/Documentation turned up the smp_affinity files. Looking at /proc/irq/2[01]/smp_affinity shows that both contain "ffffffff", that is, use all available CPU's.

To force the matter, I typed:

echo 00000001 > /proc/irq/21/smp_affinity
echo 00000002 > /proc/irq/20/smp_affinity

I dropped privileges, then repeated the "cat /dev..." above for both drives, confirming that interrupts were indeed going to CPU0 for int21 and CPU1 for int20.

Running a homebrewed multi-threading benchmark showed a possible speed-up for writes on XFS. I have not yet run "official" tests (Bonnie++ or my own) but will do so tonight. I expect the loss from cache-bouncing to be canceled out by the win from concurrent I/O.

-- 
Mark

"What better place to find oneself than
 on the streets of one's home village?"
      --Capt. Jean-Luc Picard, "Family"
