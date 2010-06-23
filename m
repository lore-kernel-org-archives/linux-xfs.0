Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5N7ZBo4013797 for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 02:35:11 -0500
Received: from mailgate.ics.forth.gr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 955B53FA98D
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 00:37:51 -0700 (PDT)
Received: from mailgate.ics.forth.gr (mailgate.ics.forth.gr [139.91.1.2]) by
	cuda.sgi.com with ESMTP id jgzRxlOkUUXXl43z for
	<xfs@oss.sgi.com>; Wed, 23 Jun 2010 00:37:51 -0700 (PDT)
Received: from av1.ics.forth.gr (av1-in.ics.forth.gr [139.91.1.71])
	by mailgate.ics.forth.gr (8.14.3/ICS-FORTH/V10-1.8-GATE) with ESMTP id
	o5N7bl7L027250
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 10:37:50 +0300 (EEST)
Received: from [139.91.92.13] ([139.91.92.13]) (authenticated bits=0)
	by enigma.ics.forth.gr (8.14.3//ICS-FORTH/V10.3.0C-EXTNULL-SSL-SASL)
	with ESMTP id o5N7blIa023547
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 10:37:47 +0300
Message-ID: <4C21B9AF.9010307@ics.forth.gr>
Date: Wed, 23 Jun 2010 10:37:19 +0300
From: Yannis Klonatos <klonatos@ics.forth.gr>
MIME-Version: 1.0
Subject: XFS peculiar behavior
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

Hi all!

         I have come across the following peculiar behavior in XFS and i 
would appreciate any information anyone
could provide.
         In our lab we have a system that has twelve 500GByte hard disks 
(total capacity 6TByte), connected to an
Areca (ARC-1680D-IX-12) SAS storage controller. The disks are configured 
as a RAID-0 device. Then I create
a clean XFS filesystem on top of the raid volume, using the whole 
capacity. We use this test-setup to measure
performance improvement for a TPC-H experiment. We copy the database 
over the clean XFS filesystem using the
cp utility. The database used in our experiments is 56GBytes in size 
(data + indices).
         The problem is that i have noticed that XFS may - not all times 
- split a table over a large disk distance. For
example in one run i have noticed that a file of 13GByte is split over a 
4,7TByte distance (I calculate this distance
by subtracting the final block used for the file with the first one. The 
two disk blocks values are acquired using the
FIBMAP ioctl).
         Is there some reasoning behind this (peculiar) behavior? I 
would expect that since the underlying storage is so
large, and the dataset is so small, XFS would try to minimize disk seeks 
and thus place the file sequentially in disk.
Furthermore, I understand that there may be some blocks left unused by 
XFS between subsequent file blocks used
in order to handle any write appends that may come afterward. But i 
wouldn't expect such a large splitting of a single
file.
         Any help?

Thanks in advance,
Yannis Klonatos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
