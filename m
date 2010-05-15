Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4FLSxbn123893 for <xfs@oss.sgi.com>; Sat, 15 May 2010 16:29:00 -0500
Received: from april.london.02.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E2F313DE59B
	for <xfs@oss.sgi.com>; Sat, 15 May 2010 14:31:14 -0700 (PDT)
Received: from april.london.02.net (april.london.02.net [87.194.255.143]) by
	cuda.sgi.com with ESMTP id Ipauik3vv4JC7fvC for
	<xfs@oss.sgi.com>; Sat, 15 May 2010 14:31:14 -0700 (PDT)
Received: from [192.168.1.130] (94.192.40.220) by april.london.02.net
	(8.5.016.1)
	id 4B79C26301F1D967 for xfs@oss.sgi.com; Sat, 15 May 2010 22:31:14 +0100
Message-ID: <4BEF12A5.2030505@btinternet.com>
Date: Sat, 15 May 2010 22:31:17 +0100
From: Marcel z maleho mesta <newsx@btinternet.com>
MIME-Version: 1.0
Subject: Structure needs cleaning - Seagate Expansion External HDD 2TB USB
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
To: xfs@oss.sgi.com

Hi all,

I'm new to Linux (still got Win XP running on my laptops :(, but 
installed on my old machine Fedora 12, which looks really good :)

I have got a problem with my external Seagate Expansion External HDD 2TB 
USB drive which has been connected to my NAS Bufallo LinkStation Mini.

I did have to disconnect the USB drive from NAS one day and since then 
it would not be recognised by NAS. So have tried some Win tools, but the 
USB drive has got XFS file system.

When I plug it to pc running Fedora 12, Palimpsest Disk Utility see the 
Hard Drive, but when I attempt to Mount the drive Error mounting device 
- Unknown error msg. comes up.
Details:
Error mounting: mount: Structure needs cleaning.

Have googled it: 
http://xfs.org/index.php/XFS_FAQ#Q:_I_see_applications_returning_error_990_or_.22Structure_needs_cleaning.22.2C_what_is_wrong.3F
and tried xfs_repair /dev/sdb1 and xfs_check /dev/sdb1 and can Mount the 
disk and all the folders in root apart from few files are ok "copied 
into Lost+Found Folder", but the most important one "DVBgrab" with about 
400Gb of data :( (each file is between 1 and 2 Gb)

Are those files gone, or is there a chance that they can be somehow 
recovered with combination of xfs_repair commands?


Thanx in advance.

Marcel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
