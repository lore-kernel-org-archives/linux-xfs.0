Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BHOMDT164305 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 11:24:23 -0600
Received: from web76214.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id BF12A159A85
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 09:25:16 -0800 (PST)
Received: from web76214.mail.sg1.yahoo.com (web76214.mail.sg1.yahoo.com
	[124.108.115.162]) by cuda.sgi.com with SMTP id
	sEhBpavREnQdYHK7 for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 09:25:16 -0800 (PST)
Message-ID: <614476.89961.qm@web76214.mail.sg1.yahoo.com>
Date: Tue, 12 Jan 2010 01:25:14 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: allocsize mount option
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

Mount options for xfs
       allocsize=size
       Sets  the buffered I/O end-of-file preallocation size when doing delayed allocation writeout (default size is 64KiB). 


I read that setting allocsize to a big value can be used to combat filesystem fragmentation when writing big files.

I do not understand how allocsize works.  Say I set allocsize=1g, but my file size is only 1 MB or even smaller.  Will the rest of the 1 GB file extent be allocated, resulting in wasted space and even file fragmentation problem?

Does setting allocsize to a big value result in performance gain when writing big files?  Is performance hurt by a big value setting when writing files smaller than the allocsize value?

I am setting up a system for HPC, where two different applications have different file size characteristics, one writes files of GBs and even 128 GB, the other is in MBs to tens of MBs.

I am not able to find documentation on the behaviour of allocsize mount option.

Thank you.


Chin Gim Leong


      New Email names for you! 
Get the Email name you&#39;ve always wanted on the new @ymail and @rocketmail. 
Hurry before someone else does!
http://mail.promotions.yahoo.com/newdomains/sg/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
