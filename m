Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0U0re4O240570 for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 18:53:40 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F06021EA5F79
	for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 16:56:06 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id uAFF79oKHdcDBad1
	for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 16:56:06 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 498CA6C0C3
	for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 18:56:06 -0600 (CST)
Message-ID: <4D44B726.8090409@hardwarefreak.com>
Date: Sat, 29 Jan 2011 18:56:06 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: how to decode metadump info produced by xfs_db, and superblock
	error
References: <SNT130-w5507ED619ADEE5A0761FA4DAE30@phx.gbl>
In-Reply-To: <SNT130-w5507ED619ADEE5A0761FA4DAE30@phx.gbl>
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

lord worm put forth on 1/29/2011 6:25 PM:
> 
> What kind of information is in this file produced by metadump, is it worth reading it somehow?
> 
> I'm trying to first understand what's causing a 'superblock cannot be read' error in my XFS after a succesfully dd of the partition (dd succeeds in copying to a file, and also restoring, but after restoring it cannot mount).
> 
> xfs_repair fails to fix it, how should I attach the 55M metadata file to this email (do we have an upload location for this?), max size on hotmail is 25M ...
> 
> Does the superblock error refer to primary or secondary superblocks? Does xfs_repair attempt to clone the broken superblock from the others?


dd is not a proper XFS filesystem backup/restore utility.  Instead use xfsdump
and xfsrestore, or any file level backup/restore solution.

You obviously now know why you shouldn't use dd for this purpose with XFS. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
