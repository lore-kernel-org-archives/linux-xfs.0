Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 19:36:41 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBC3aYA3004415
	for <linux-xfs@oss.sgi.com>; Tue, 11 Dec 2007 19:36:38 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA0E9B39CC9
	for <linux-xfs@oss.sgi.com>; Tue, 11 Dec 2007 19:36:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 3Gaevk9r1X3CyR8A for <linux-xfs@oss.sgi.com>; Tue, 11 Dec 2007 19:36:41 -0800 (PST)
Message-ID: <475F5746.8080405@sandeen.net>
Date: Tue, 11 Dec 2007 21:36:38 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: write barrier over device mapper supported or not?
References: <200712112342.24094.Martin@lichtvoll.de>
In-Reply-To: <200712112342.24094.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Martin Steigerwald wrote:
> Hello!
> 
> Are write barriers over device mapper supported or not?

Nope.

see dm_request():

        /*
         * There is no use in forwarding any barrier request since we can't
         * guarantee it is (or can be) handled by the targets correctly.
         */
        if (unlikely(bio_barrier(bio))) {
                bio_endio(bio, -EOPNOTSUPP);
                return 0;
        }


> On LVM2 xfs tells me:
> 
> Dec 11 23:00:09 shambala kernel: Filesystem "dm-0": Disabling barriers, 
> not supported by the underlying device
> Dec 11 23:00:09 shambala kernel: XFS mounting filesystem dm-0
> Dec 11 23:00:09 shambala kernel: Ending clean XFS mount for filesystem: 
> dm-0
> 
> But when I mount ext3 on LVM2 I get:
> 
> Dec 11 23:05:34 shambala kernel: kjournald starting.  Commit interval 5 
> seconds
> Dec 11 23:05:34 shambala kernel: EXT3 FS on dm-1, internal journal
> Dec 11 23:05:34 shambala kernel: EXT3-fs: mounted filesystem with ordered 
> data mode.
> 
> even when I explicetely specify "-o barrier=1" which should enable 
> barriers on ext3.
> 
> As far as I understood from the changelogs as I wrote my Linux-Magazin I 
> thought there should be device mapper support in the kernel, but I can 
> not reproduce that finding anymore at the moment.
> 
> But back then I also looked at the ext3 / jbd sources and found that jbd 
> issues a warning when barrier support is not available. However I do not 
> find that one either.

in journal_write_commit_record() there is such a warning, but not in the
mount path:

                printk(KERN_WARNING
                        "JBD: barrier-based sync failed on %s - "
                        "disabling barriers\n",
                        bdevname(journal->j_dev, b));

and if I set barrier=1 on an lvm-root test box, I do get:

JBD: barrier-based sync failed on dm-0 - disabling barriers

-Eric
