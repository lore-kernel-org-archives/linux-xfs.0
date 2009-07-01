Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n61Kojjq036962 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 15:50:46 -0500
Received: from ssec.wisc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B234C14993E4
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 13:57:39 -0700 (PDT)
Received: from ssec.wisc.edu (mahogany.ssec.wisc.edu [128.104.110.2]) by
	cuda.sgi.com with ESMTP id JXibA1mNMTg6sR72 for
	<xfs@oss.sgi.com>; Wed, 01 Jul 2009 13:57:39 -0700 (PDT)
Message-ID: <4A4BCC44.7050302@ssec.wisc.edu>
Date: Wed, 01 Jul 2009 15:51:16 -0500
From: Jesse Stroik <jstroik@ssec.wisc.edu>
MIME-Version: 1.0
Subject: Re: Seg fault during xfs repair (segmentation fault / segv)
References: <4A4A596D.8030800@ssec.wisc.edu>
	<4A4A5C4E.7030605@sandeen.net>	<4A4A7D44.7040009@ssec.wisc.edu>
	<4A4BBECC.8000308@sandeen.net> <4A4BC83A.3080401@sandeen.net>
In-Reply-To: <4A4BC83A.3080401@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric,

Thanks for addressing the issue with xfs_repair.


> that's one crunchy filesystem you've got there; what happened to it?


It's not entirely clear -- the JBOD and SAS controller seem to have 
gotten into inconsistent states and I was observing a few SCSI errors 
for those particular LUNs.  While the system was exhibiting the SCSI 
errors, the user of this file system (and a few others like it on the 
host) noticed file corruption when reading/writing certain files, then 
spontaneous corruption after making copies of the files.

I'll take a look at the new xfs_check and see what happens.

Best,
Jesse

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
