Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4V5UC9e029381 for <xfs@oss.sgi.com>; Tue, 31 May 2011 00:30:13 -0500
Received: from nm7-vm0.bullet.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 4A64748F556
	for <xfs@oss.sgi.com>; Mon, 30 May 2011 22:30:10 -0700 (PDT)
Received: from nm7-vm0.bullet.mail.sg1.yahoo.com
	(nm7-vm0.bullet.mail.sg1.yahoo.com [115.178.12.201]) by
	cuda.sgi.com with SMTP id Hu71yEWAOOeXD1Tb for
	<xfs@oss.sgi.com>; Mon, 30 May 2011 22:30:10 -0700 (PDT)
Message-ID: <164529.98085.qm@web77701.mail.sg1.yahoo.com>
Date: Tue, 31 May 2011 13:30:08 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: Question about Number of Allocation Groups
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
To: xfs@oss.sgi.com

Hi,

I have a question about the number of allocation groups in XFS.

In SUSE Linux Enterprise 10 SP2 kernel 2.6.16, the default number of allocation groups from what I have seen is 16 for a 144 GB filesystem, 32 for a 1.1 TB filesystem.

In SUSE Linux Enterprise 11 kernel 2.6.27, the default number of allocation groups is 4 even for a 800 GB filesystem (from what I have observed on openSUSE 11.4 kernel 2.6.37, that number is still 4).  I have observed that for XFS on mdraid the default is 16 for a 101 GB filesytem, 32 for a 4.5 TB filesystem.

1) May I know what is the  method for computing the default number of allocation groups, and why the big change from kernel 2.6.16 to 2.6.27 (16, 32 to 4)?

2) What are the guide lines for deciding how many allocation groups we should specify?  Is the number related to filesystem size, the IO bandwidth, the number of processor cores, the number of parallelism threads we want to occupy the system, system usage/workload characteristics?

3) I am sure there is some point for any system where an increasing number of allocation groups will first increase performance, and then the performance will start to drop?

4) What would be an optimum number for the root filesystem for the operating system?  As I have 100 GB for the "/", my OS partitions not on mdraid have the default 4 allocation groups for kernel 2.6.27 and 2.6.37.

Thank you!  This are questions that have been puzzling me for a while I would really appreciate the answers.


Chin Gim Leong

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
