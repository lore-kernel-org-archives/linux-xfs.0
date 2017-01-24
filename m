Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.vlasiu.net ([91.223.50.125]:40158 "EHLO mail.vlasiu.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750795AbdAXIXf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 03:23:35 -0500
Date: Tue, 24 Jan 2017 10:14:01 +0200 (EET)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: XFS issues with NVMe SSD
In-Reply-To: <8af51363-bcb3-5830-7531-4417ffb099fd@jlbond.com>
Message-ID: <alpine.LRH.2.20.14.1701241000001.20409@mail.vlasiu.net>
References: <8a562e13-6d86-d9ef-de22-f71d5aa79b60@jlbond.com> <dbcc14e5-73e7-4ba0-22d2-646d3e466927@sandeen.net> <20170123135048.GB33287@bfoster.bfoster> <20170123135348.GA25320@infradead.org> <CAJCQCtQnH1PgUf=9gJT=5UpZ8SCGqvN-1rAvO3HLq9nQJkF+eA@mail.gmail.com>
 <325e2a40-0ba6-a973-8ca4-933e44b075a9@sandeen.net> <CAJCQCtQ-Ud7cqtX6ub_h+bPmp6qKpOYZMaZCvgbT60G=0QBZGg@mail.gmail.com> <8af51363-bcb3-5830-7531-4417ffb099fd@jlbond.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bond Masuda <bond.masuda@jlbond.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On Mon, 23 Jan 2017, Bond Masuda wrote:

> There are only 2 people I know of that have run into this issue, including
> myself.
Well, no. I have the same problem about a week ago.

Intel 6000p (INTEL SSDPEKKF256G7).
RHEL 7 (actually CentOS 7), kernel 3.10.0-514.

I had the root partition on raid 5 for many, many years. I decided to 
switch to nvme ssd for root fs. I copied the content of / partition on 
ssd, made the required changes to fstab and grub, put selinux in 
permissive mode. Reboot. Everything was fine. Touch /.autorelabel, reboot 
again. Everything worked up to relabel point during the boot. Errors. 
Instructed-me to run fsck. Reboot with the old root fs. xfs.fsck was not 
been able to do anything on the ssd partition. In the end, I formatted the 
nvme partition with ext4 and seems to works.

Maybe a selinux problem with xfs again? I don't know.


Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 44952F15
// OpenGPG-Fingerprint: 4AC5 7C26 2FE9 02DA 4906  24B2 D32B 7ED7 4495 2F15
// OpenGPG-URL        : http://www.vlasiu.net/public.key

-----BEGIN PGP SIGNATURE-----

iQIbBAEBCgAGBQJYhwzJAAoJENMrftdElS8VEkQP90a6bW8keyLc31ctNFJ/wgcC
DsXuw9SbG9zI62I5TvJVBDU5wVstZX/C70edbrNPDOqRJSNRCbDorJ3AuPhZ6wBm
PfjNXu/Dz4j1CRQBt0cbQ4bGP0U1FgTlMbt5QqNcAwSlXOZ44QIe7uGMbKoiW84S
pfqr1x+FolMPRUMWrNAI0+Yml0gOMmKg7fNpdEkRnB4NfAveD8zaKh2wrDCkglDn
EaoixjQpkj6mVLmCzkMRs6afb90ycEcZCN0+BB/rC2TOQ+YKAWgqppDhf9enB4CF
7rFaUNrjZ4M22S8sA60D/SvnF76XS9hvABlmn81p378qQiiVsG+uW+a7vkYQjz4I
WL0HLWhJdy5HPCgQ4eo36TpTzlMOsMkHaV6aJLH+biRFQo/mxIBgqvr4Fd3oEQMT
+28DqTbAWCZDIG7o8d+tKuU72Cse3rUa2QbhSN5YwzVi4RZOSP56NJvVmXBPq5+6
vplvOPSF7zDIon7ik7J4IHjfg/5dy6JKevx3QekO7vW/0Aeh7GLI3qfzzxuAW8Ww
MjELXSrcFnhFRG/2YxZavlZCtXjYxr6AuaxQT22OWfz9fvulPZWrLPA2G/pDpNzW
njYg5MR2dGaHtq5kg23t2KjpCI/2FxCD/nd3/loeZLXzVrZKeWSRPO8ckxD083+K
cmSHlv8gdk/e6fCr+54=
=dzNp
-----END PGP SIGNATURE-----
