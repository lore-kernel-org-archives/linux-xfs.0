Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A6DD7F37
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 06:29:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E93BDAC004
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 04:29:18 -0700 (PDT)
Received: from deltamedia.de (deltamedia.de [178.77.98.209]) by cuda.sgi.com
	with ESMTP id gNzasQonqrO3uPMG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 04:29:14 -0700 (PDT)
Received: from citd.de (p579BD0C4.dip0.t-ipconnect.de [87.155.208.196])
	by deltamedia.de (Postfix) with ESMTPSA id 8F3CDA978007
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 13:29:12 +0200 (CEST)
Date: Thu, 3 Jul 2014 13:29:11 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Changing label of a mounted XFS filesystem
Message-ID: <20140703112911.GA9806@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi


Is there a particular reason that the label of a mounted XFS fileystem
can't be changed?

The man-page of xfs_admin gives a blanket "Devices that are mounted
cannot be modified" but no explanation for why that is.

In my case it's the label of the root-filesystem i want to change. So to
change it i would have to boot the computer with some kind of live or
rescure-system. Or i would need to temporarily connect the device to
another computer, both aren't really nice hoops to jump through just to
change a few characters.

The only thing i can compare this to is ext2 and with ext2 (/boot
partition, so it really is ext2) i can change the label to my hearts
content, even the device is mounted.

For my case i could live with it if i could remount the filesystem RO,
change the label and then having to reboot the machine, still nicer than
the other 2 options.



-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
