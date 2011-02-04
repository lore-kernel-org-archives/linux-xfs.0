Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p14CNSID011869 for <xfs@oss.sgi.com>; Fri, 4 Feb 2011 06:23:29 -0600
Received: from wydra.ncac.torun.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48C91155178B
	for <xfs@oss.sgi.com>; Fri,  4 Feb 2011 04:25:57 -0800 (PST)
Received: from wydra.ncac.torun.pl (wydra.ncac.torun.pl [158.75.101.26]) by
	cuda.sgi.com with ESMTP id DB4vRKeYS4DHSwmJ for
	<xfs@oss.sgi.com>; Fri, 04 Feb 2011 04:25:57 -0800 (PST)
Received: from [158.75.101.16] (jb.ncac.torun.pl [158.75.101.16])
	(authenticated bits=0)
	by wydra.ncac.torun.pl (8.14.4/jb.29.V.2010) with ESMTP id
	p14CPr0H015496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256
	verify=NOT) for <xfs@oss.sgi.com>; Fri, 4 Feb 2011 13:25:54 +0100
Message-ID: <4D4BF051.9000608@ncac.torun.pl>
Date: Fri, 04 Feb 2011 13:25:53 +0100
From: Jerzy Borkowski <jubork@ncac.torun.pl>
MIME-Version: 1.0
Subject: project quota: df/reservations
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

Hello,

1) Fancy a project with quota set to 10GB, and filled
with 5GB of data. When I type

  df /path/to/project/tree

it shows 5GB free space. Now, the root user
fills up the disk (outside project tree), so the
XFS filesystem is really 100% full. The df command
still shows 5GB free space. I guess, this is
intentional. I propose to add some switch/flag
(either during mount or project creation),
which would tell XFS to report in statfs() calls
the free space as: min(project_free_space, filesystem_free_space).

2) is there any way to have space reservations for projects (like in ZFS) ?
For instance, a project with 10GB quota and 7GB of preallocated
space, so even root, writing outside the project tree, cannot
completely fill up the disk.

Thanks,

Jurek


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
