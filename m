Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8741A7F5A
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 09:57:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED886AC006
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 07:57:46 -0700 (PDT)
Received: from emea01-db3-obe.outbound.protection.outlook.com
	(mail-db3on0132.outbound.protection.outlook.com
	[157.55.234.132]) by cuda.sgi.com with ESMTP id
	QexZByZeMmJ2ANZU (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 07:57:44 -0700 (PDT)
Received: from otto.localdomain (otto.nzcorp.net [10.194.93.44])	by
	sloth.nzcorp.net (Postfix) with ESMTP id C714C7280059	for
	<xfs@oss.sgi.com>; Mon,  1 Jun 2015 16:57:41 +0200 (CEST)
Date: Mon, 1 Jun 2015 16:57:41 +0200
From: Anders Ossowicki <aowi@novozymes.com>
Subject: "XFS: possible memory allocation deadlock in kmem_alloc" on high
	memory machine
Message-ID: <20150601145741.GA16608@otto>
MIME-Version: 1.0
Content-Disposition: inline
Reply-To: aowi@novozymes.com
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

Hi,

We've started seeing a slew of these messages in dmesg:

XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)

First question: Is this cause for alarm at all? Should we expect the
disk to blow up in our faces? Should we expect loss of performance?

This is from a machine under heavy load (database server, large dataset,
lots of I/O). It seems to happen only when we hit 15k-20k+ iops on the
disk.

We're running on 3.18.13, built from kernel.org git.

The machine has 3TB of memory and after googling the message for a
while, I guess memory fragmentation could be a likely cause. Looking at
/proc/buddyinfo when these messages show up, we see that there are
almost no fragments of order 1 and none of higher orders.

My completely uneducated guess would be that the kernel can't reap pages
fast enough, so XFS gets impatient waiting for them. That seems like an
issue for mm though but I'd like to confirm if my understanding of what
XFS does is correct.

Most of the memory is used by disk cache:
$ free -g
       total   used   free   shared   buffers   cached
Mem:    3023   3001     22        0         0     2840

Let me know if there is any more info I should provide.

-- 
Anders Ossowicki

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
