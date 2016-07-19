Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 129067CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 14:00:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA6DF304032
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 12:00:05 -0700 (PDT)
Received: from pavilion.ashurst.eu.org (pavilion.ashurst.eu.org
	[85.119.82.45]) by cuda.sgi.com with ESMTP id jFA86hRooo8yOZRJ
	(version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 12:00:02 -0700 (PDT)
Received: from 109.21.187.81.in-addr.arpa ([81.187.21.109] helo=[172.25.11.32])
	by pavilion.ashurst.eu.org with esmtpsa
	(TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80)
	(envelope-from <andyjpb@ashurst.eu.org>) id 1bPaFM-0003M5-SB
	for xfs@oss.sgi.com; Tue, 19 Jul 2016 20:00:00 +0100
From: Andy Bennett <andyjpb@ashurst.eu.org>
Message-ID: <578E78B0.2010602@ashurst.eu.org>
Date: Tue, 19 Jul 2016 20:00:00 +0100
MIME-Version: 1.0
Subject: xfsdump quota failures
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

I'm running XFS for a few filesystems under a i686 Debian Linux VPS.

Last night I upgraded from Debian Squeeze to Debian Wheezy. Before I
started the upgrade I took a backup using xfs_dump with my usual script
and everything went fine.

Tonight I am trying to upgrade from Debian Wheezy to Debian Jessie so I
am taking another backup before I start.

In the logs tonight I see the following errors for file systems that
have quotas enabled:

-----
/usr/sbin/xfsdump: saving user quota information for: /home
/usr/sbin/xfsdump: ERROR: xfs_quota failed with exit status: -1
/usr/sbin/xfsdump: ERROR: failed to save user quota information, continuing
/usr/sbin/xfsdump: saving group quota information for: /home
/usr/sbin/xfsdump: ERROR: xfs_quota failed with exit status: -1
/usr/sbin/xfsdump: ERROR: failed to save group quota information, continuing
-----

-----
/usr/sbin/xfsdump: saving user quota information for: /var
/usr/sbin/xfsdump: ERROR: xfs_quota failed with exit status: -1
/usr/sbin/xfsdump: ERROR: failed to save user quota information, continuing
/usr/sbin/xfsdump: saving project quota information for: /var
/usr/sbin/xfsdump: ERROR: xfs_quota failed with exit status: -1
/usr/sbin/xfsdump: ERROR: failed to save project quota information,
continuing
-----

One of the file systems has user and group quotas enabled and the other
has user and project quotas enabled.

The root file system is XFS but does not have quotas enabled and it
dumps without error.

When I run xfs_quota as root by hand it gives me an interactive prompt
and xfs_quota commands such as `df` and `print` seem to do what I would
expect without errors.


Both last night's dump and tonight's are level 0 dumps.

Last night's dump used Debian Squeeze's xfsdump 3.0.4 with xfsprogs 3.1.4.
Tonight's dump uses Debian Wheezy's xfsdump 3.0.6 with xfsprogs 3.1.7.


Can anyone give me any guidance about what's going on and how to fix it?


Thanks for your help.




Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0290 DA75 E982 7D99 A51F  E46A 387A 7695 7EBA 75FF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
