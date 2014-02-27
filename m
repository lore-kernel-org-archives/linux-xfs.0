Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC7E529DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 23:38:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57F3DAC003
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 21:38:08 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id LTTl46Ip2VtqTw2U
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 26 Feb 2014 21:38:00 -0800 (PST)
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:60389
	helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82) (envelope-from <lists@colorremedies.com>)
	id 1WItfU-003zNR-G4
	for xfs@oss.sgi.com; Wed, 26 Feb 2014 22:38:00 -0700
From: Chris Murphy <lists@colorremedies.com>
Subject: XFS on Fedora i686, armv7hl
Message-Id: <8A28EF88-012E-4036-BDB6-E76B1CC569A7@colorremedies.com>
Date: Wed, 26 Feb 2014 22:37:59 -0700
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

Fedora is considering XFS as their default file system. They support three primary architectures: x86_64, i686, and armv7hl.  Do XFS devs have any reservations about XFS as a default file system on either i686, or arm?

So far the only thing I've run into with kernel 3.13.4-200.fc20.i686+PAE will not mount an XFS volume larger than 16TB. But I haven't tried filling a < 16TB volume with a significant amount of data while running 32bit, and anyway it's just easier to ask if there are other gotchas, or reservations about this combination.

XFS (sdc): file system too large to be mounted on this system.
[snip]
XFS (sdc): Internal error xfs_sb_read_verify at line 630 of file fs/xfs/xfs_sb.c.  Caller 0xf8b19e1c
[1]


Thanks,


Chris Murphy


[1] The too large warning happens with ext4 at mount time also. A Btrfs volume mounts OK, although I don't know if it actually withstands significant use.
http://paste.fedoraproject.org/80784/93470280/
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
