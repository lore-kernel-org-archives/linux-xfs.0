Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0QFvbCv244925 for <xfs@oss.sgi.com>; Thu, 26 Jan 2012 09:57:37 -0600
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id 8SMrEXSkCked1kxI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Jan 2012 07:57:35 -0800 (PST)
Received: by lahd3 with SMTP id d3so446996lah.26
	for <xfs@oss.sgi.com>; Thu, 26 Jan 2012 07:57:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120124213936.GA1505@infradead.org>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
	<20120124213936.GA1505@infradead.org>
Date: Thu, 26 Jan 2012 13:57:34 -0200
Message-ID: <CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
Subject: Re: XFS problem
From: Kelbel Junior <jymmyjr@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Well, in 24/01 i upgrade to the kernel 3.2.1 in one server and forgot
read my emails...until now it's running without problems.
Then, yesterday i put kernel 3.2.1 on another server and this morning
a several same messages "server013 kernel: XFS: possible memory
allocation deadlock in kmem_alloc (mode:0x250)" and delays.

(without call trace because i forgot to apply that patch with dump_stack)

Now i applied the dump_stack and the latest patches that you sent.
I'm trying to discover what triggers this bug, to help in a
solution... I tell you any news


*** Some useful information:

# mount
/dev/sdb1 on MOUNTPOINT type xfs (rw,noatime)

But in some cases i use RAID and mount the partition with the
following settings (and happen the same problem):
/dev/mapper/server012_vg-server012_vol on MOUNTPOINT type xfs
(rw,noatime,nodiratime,inode64,nobarrier)

HD model:
Seagate ST31000528AS -- Barracuda 7200.12 SATA 3Gb/s 1TB Hard Drive

I work in a cache solution company, so I/O performance is very
important in our context.


Thanks.
Kelbel Junior

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
