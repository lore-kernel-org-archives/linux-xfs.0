Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 716317CA7
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 05:32:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD2BBAC002
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 03:32:50 -0700 (PDT)
Received: from co01.mbox.net (co01.mbox.net [165.212.64.31]) by cuda.sgi.com
	with ESMTP id yk7AATGMmxwVDJQp (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 03:32:48 -0700 (PDT)
Received: from co01.mbox.net (localhost [127.0.0.1])
	by co01.mbox.net (Postfix) with ESMTP id 3r3JcK3NZ3zs4gb
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 10:32:49 +0000 (UTC)
Date: Mon, 09 May 2016 12:32:42 +0200
From: issa-gorissen@usa.net
Subject: Re: Unable to mount a XFS filesystem
Mime-Version: 1.0
Message-ID: <690ueikfQ0112S06.1462789962@web06.cms.usa.net>
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
To: XFS mail list <xfs@oss.sgi.com>

Received: 09:18 PM CEST, 05/08/2016
From: "Carlos E. R." <robin.listas@telefonica.net>

> 
> How did you do that upgrade? Zypper dup, or boot dvd, choose upgrade?
> 
In fact it was not a "real" upgrade. I added a new boot disk on which I
installed Tumbleweed as a new OS. The MD RAID disks were kept in the computer.
It seems the install did something to it I don't know about.


> Me, I would try to find out if the array is readable:
> 
> dd if=/dev/md0 of=/dev/null
> 

array is fine but somehow the md partitions have been shrunk with the
superblock moved. Don't know know. Version of the superblock is 1.0; which is
stored at the end of the partition. So XFS filesystem starts at the start of
the partition. If after the new OS install I cannot mount XFS anymore, and as
Dave said XFS mount will try to read end of filesystem; then the end of the
partition have changed.

Thx

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
