Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AEE767CBF
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 04:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B354AC002
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 02:33:18 -0700 (PDT)
Received: from nm7-vm8.bullet.mail.sg3.yahoo.com
	(nm7-vm8.bullet.mail.sg3.yahoo.com [106.10.148.183]) by
	cuda.sgi.com with ESMTP id tkC3AzNNC6edmvyv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 02:33:16 -0700 (PDT)
Message-ID: <1370597593.78403.YahooMailClassic@web192202.mail.sg3.yahoo.com>
Date: Fri, 7 Jun 2013 17:33:13 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: How to Override Default inode64 mount option in openSUSE 12.3?
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,


I have just set up openSUSE 12.3 on my Acer notebook with a 750 GB WD hard drive, "/" with 80 GB and "/home" with 587 GB, both are XFS.

Both file systems are mounted with inode64 and no matter what I put in /etc/fstab, I am not able to remove inode64 option.

Is there any method to override the inode64 default mount option?

The reason I need to get rid of it is that acroread will not start, and I suspect that it is due to inode64, although I cannot confirm with strace on acroread.

Since the two file systems are under 1 TB, what is the point of inode64 any way?



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
