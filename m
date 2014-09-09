Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B7FDA7F3F
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 10:21:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A52D68F8033
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 08:21:39 -0700 (PDT)
Received: from mail02.lsn.net (mail02.lsn.net [66.90.130.128]) by cuda.sgi.com
	with ESMTP id xlASPbMt4ehFJtFP for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 08:21:38 -0700 (PDT)
Received: from [192.168.1.121] (24-155-170-173.dyn.grandenetworks.net
	[24.155.170.173]) (authenticated bits=0)
	by mail02.lsn.net (8.14.4/8.13.6) with ESMTP id s89FLbvW016316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 9 Sep 2014 10:21:38 -0500
Message-ID: <540F1B01.3020700@mygrande.net>
Date: Tue, 09 Sep 2014 10:21:37 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Corrupted files
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hello,

	I have an issue with my primary RAID array.  I have 13T of data on the 
array, and I suffered a major array failure.  I was able to rebuild the 
array, but some data was lost.  Of course I have backups, so after 
running xfs_repair, I ran an rsync job to recover the lost data.  Most 
of it was recovered, but there are several files that cannot be read, 
deleted, or overwritten.  I have tried running xfs_repair several times, 
but any attempt to access these files continuously reports "cannot stat 
XXXXXXXX: Structure needs cleaning".  I don't need to try to recover the 
data directly, as it does reside on the backup, but I need to clear the 
file structure so I can write the files back to the filesystem.  How do 
I proceed?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
