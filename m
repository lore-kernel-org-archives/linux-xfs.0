Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0TF91xF125373
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 09:09:02 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 391A319AFE6
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 07:10:06 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id OLuF2W9PZom04ng4 for <linux-xfs@oss.sgi.com>;
	Fri, 29 Jan 2010 07:10:06 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1NasU0-00070T-63
	for linux-xfs@oss.sgi.com; Fri, 29 Jan 2010 16:10:04 +0100
Received: from c-24-60-200-235.hsd1.ma.comcast.net ([24.60.200.235])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 16:10:04 +0100
Received: from Nico by c-24-60-200-235.hsd1.ma.comcast.net with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 16:10:04 +0100
From: Nicolas STRANSKY <Nico@stransky.cx>
Subject: Filesystem corrupted: "Sorry,
	could not find valid secondary superblock"
Date: Fri, 29 Jan 2010 09:42:49 -0500
Message-ID: <hjus58$6oi$1@ger.gmane.org>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Hi,

I'm using Debian Lenny with xfsprogs 2.9.8-1lenny1 and a kernel
2.6.26-2-amd64. Recently I had some disk failures on a 1.5TB RAID 5
array, which is now running in a degraded mode but the xfs filesystem on
this array is inconsistent. I can mount it with -o ro,norecovery and
read some files, but I can't read most of them.
Using xfs_repair, I tried to repair the filesystem. It went for 12
hours, displaying these messages:
"found candidate secondary superblock...
unable to verify superblock, continuing..."
and finally:
"Sorry, could not find valid secondary superblock
Exiting now."

Is there anything else I could do to repair the filesystem? Upgrade to a
newer version of xfsprogs? Is it possible that there is no valid
secondary superblock on the whole disk or are they just not found?

Thanks a lot for any help,
NS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
