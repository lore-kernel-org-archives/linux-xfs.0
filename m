Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 13:40:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5HKeSVr027334
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 13:40:28 -0700
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS mkfs/mount options
Date: Tue, 17 Jun 2008 22:41:21 +0200
References: <338502.8443.qm@web34508.mail.mud.yahoo.com> (sfid-20080617_222310_564625_90C3CEF2)
In-Reply-To: <338502.8443.qm@web34508.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806172241.22211.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, MusicMan529@yahoo.com


Hi Mark,

Am Dienstag 17 Juni 2008 schrieb Mark:
> --- On Tue, 6/17/08, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > From: Justin Piszcz <jpiszcz@lucidpixels.com>
> > Subject: Re: XFS mkfs/mount options
> > To: "Mark" <musicman529@yahoo.com>
> > Cc: xfs@oss.sgi.com
> > Date: Tuesday, June 17, 2008, 5:27 AM
> >
> > How did you tune your IRQ delivery?
>
> Generically:
>
> echo X > /proc/irq/[IRQ#]/smp_affinity
>
> Where X is a 32-bit hexadecimal bitmask.
>
> My real procedure:

[... longer procedure ...]

We always use 

martin@shambala> apt-cache show irqbalance
Package: irqbalance
Priority: extra
Section: utils
Installed-Size: 64
Maintainer: Kyle McMartin <kyle@ubuntu.com>
Architecture: i386
Version: 0.55-2.1
Depends: debconf (>= 0.5) | debconf-2.0, libc6 (>= 2.7-1), libglib2.0-0 
(>= 2.12.0)
Filename: pool/main/i/irqbalance/irqbalance_0.55-2.1_i386.deb
Size: 17496
MD5sum: e4393d6ac2659e08f1bdecab2d94c1bf
SHA1: 4b49deb3b522dec88c820bde78cfb6abb20365dd
SHA256: 069104aff5561f09c8affcfe2aa9e144bed359a7c935c71c9968c78d1e8bf1b3
Description: Daemon to balance interrupts for SMP systems
 Daemon to balance interrupts across multiple CPUs, which can lead to
 better performance and IO balance on SMP systems. This package is
 especially useful on systems with multi-core processors, as interrupts
 will typically only be serviced by the first core.
Tag: admin::hardware, admin::kernel, interface::commandline, 
interface::daemon, network::server, role::program

for this kind of task or well the version in Debian Etch of it, the former 
is Lenny/Sid:

Version: 0.12-7
Depends: libc6 (>= 2.3.6-6), debconf (>= 0.5) | debconf-2.0

Is there any need to fine-tune interrupts manually?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
