Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0A2gDbj052195 for <xfs@oss.sgi.com>; Mon, 9 Jan 2012 20:42:14 -0600
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id hYCT0a0sphg02RMy
	for <xfs@oss.sgi.com>; Mon, 09 Jan 2012 18:42:12 -0800 (PST)
Received: by lagr15 with SMTP id r15so2111801lag.26
	for <xfs@oss.sgi.com>; Mon, 09 Jan 2012 18:42:11 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 10 Jan 2012 10:42:09 +0800
Message-ID: <CAGdb-8fyseE+ARMUWaQYcx1VCnmph=xL7XeTBUXg2wSSdF_7hw@mail.gmail.com>
Subject: xfsdump 3.0.6, ERROR: xfs_quota failed with exit status: -1
From: Tommy Wu <wu.tommy@gmail.com>
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

Hi!

when I use xfsdump 3.0.6, it always got ERROR for xfs_quota like this:

/sbin/xfsdump: using file dump (drive_simple) strategy
/sbin/xfsdump: version 3.0.6 (dump format 3.0) - Running single-threaded
/sbin/xfsdump: saving user quota information for: /var/www
/sbin/xfsdump: ERROR: xfs_quota failed with exit status: -1
/sbin/xfsdump: ERROR: failed to save user quota information, continuing
/sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/var/www
/sbin/xfsdump: dump date: Tue Jan 10 10:34:24 2012

downgrade to 3.0.5, same command (also same xfsprogs 3.1.7), no any error:

/sbin/xfsdump: using file dump (drive_simple) strategy
/sbin/xfsdump: version 3.0.5 (dump format 3.0) - Running single-threaded
/sbin/xfsdump: saving user quota information for: /var/www
/sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/var/www
/sbin/xfsdump: dump date: Tue Jan 10 10:30:36 2012

But even it got error for xfs_quota, the xfsdump_quotas file was
created successful, I check the command used in xfsdump, the same
xfs_quota command work fine without any error in shell script (I also
write a simple C program to use system() to execute it, also no error
for such command).

-- 

Tommy Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
