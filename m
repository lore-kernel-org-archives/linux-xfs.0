Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o815xA8Q110398 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 00:59:11 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06F4BD77966
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 23:10:22 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id AK56GxIHqGrlFGbz for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 23:10:22 -0700 (PDT)
Date: Wed, 1 Sep 2010 15:59:42 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <1350336911.556311283320782285.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <881036.47658.qm@web76207.mail.sg1.yahoo.com>
Subject: Re: 4K drives, sectsz=512, bsize=4096
MIME-Version: 1.0
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
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: xfs@oss.sgi.com


----- "Gim Leong Chin" <chingimleong@yahoo.com.sg> wrote:

> Hi,
> 
> I would like to know how the inode size should be configured for 4 kB
> sector drives?

There is no direct correlation between inode size and sector size.

> Should we leave it at the default 256 bytes, or set it to the maximum
> of 2 kB?

See above.  Keep the defaults unless you have a good reason not to.

> Do inodes occupy discrete sectors, or do they occupy part of the
> filesystem block?

They occupy part of a filesystem block.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
