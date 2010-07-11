Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6BGRI5S233321 for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 11:27:18 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81F4043B7BD
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 09:30:10 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id RLWBBQTMDqQiCPrk for
	<xfs@oss.sgi.com>; Sun, 11 Jul 2010 09:30:10 -0700 (PDT)
Date: Sun, 11 Jul 2010 18:29:41 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100711182941.1a3d4200@galadriel.home>
In-Reply-To: <84CF7106-D080-46F0-945B-5BC0DC7DBBE1@ucsc.edu>
References: <84CF7106-D080-46F0-945B-5BC0DC7DBBE1@ucsc.edu>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

Le Sat, 10 Jul 2010 23:32:57 -0700 vous =E9criviez:

> I got some automated emails this Sunday about I/O errors coming from
> the computer =


That smells like a hardware problem. What type of RAID is this?
RAID-5, RAID-10, RAID-6? are there any alarms from the RAID controller?
Can you test the SMART status of the drives? What are the JBODs, are
these dell MD-1000? =


> One one of the
> physical volumes  (PVs) - on /dev/sdc1, I noticed when I ran
> pvdisplay that of the 12.75 TB comprising the volume, 12.00! TB was
> being shown as 'not usable'.

Smells more like a hardware problem. Check all your systems logs for IO
errors and errors coming from the sas driver. Are you using mptsas or
megaraid driver? Grep the logs with the driver name to check for any
message (time outs, IO errors, etc).


> thinking it might find the missing
> data. Instead the filesystem decreased back to 51 TB. I rebooted and
> tried again a couple of times and the same thing happened. I'd
> really, really like to get that data back somehow and also to get the
> filesystem to where we can start using it again.

Check the dmesg output right after the xfs_repair. My bet : there is an
IO error (bad cable? hosed drive?) (message from the controller), the PV
is failed (message from LVM), then xfs_repair does what it must do : it
truncates the filesystem to the size of the underlying device.

Unfortunately  the data may still be on the drives, but a tool like
photorec is probably your only chance to get it back from the raw
drives. Metadata, filenames, directory hierarchies are almost certainly
gone once and for all.


-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
