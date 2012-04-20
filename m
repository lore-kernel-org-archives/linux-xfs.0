Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3K5Swhn183191 for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 00:28:58 -0500
Received: from mailout3.smartt.com (mailout3.smartt.com [69.67.187.28]) by
	cuda.sgi.com with ESMTP id 9T6Xe7NLTIL6lkUo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Apr 2012 22:28:57 -0700 (PDT)
Received: from [192.168.163.67] (d66-183-100-118.bchsia.telus.net
	[66.183.100.118])
	by mailout3.smartt.com (Postfix) with ESMTPA id 712D845187
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 22:28:56 -0700 (PDT)
Message-ID: <4F90F45F.2010507@neulion.com>
Date: Thu, 19 Apr 2012 22:30:07 -0700
From: Nick Hollingsworth <nick.hollingsworth@neulion.com>
MIME-Version: 1.0
Subject: XFS restored to lost and found
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

Hi all,

So I've managed to corrupt an XFS files system running on software RAID. 
How exactly I'm not sure....it may have been when using CentOS rescue 
when trying to get the system to boot.

Using xfs_repair with various options I've managed to get the FS to a 
state where it'll mount but there are no directories only inode numbers 
in the lost and found directory.

Is there any way to remap these back to directories? Any ideas how I may 
have gotten into this mess?

Thanks.

Nick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
