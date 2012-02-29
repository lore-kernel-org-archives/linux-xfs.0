Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T4nKV7246213 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 22:49:20 -0600
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id 8Q0wauCejoD208py (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 20:49:17 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q1T4nGgR021777
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 04:49:16 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q1T4nFbi003484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 04:49:15 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q1T4nEgf004798 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 22:49:14 -0600
Message-ID: <4F4D8413.4050709@oracle.com>
Date: Wed, 29 Feb 2012 09:49:07 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Question about project quota with container
Reply-To: jeff.liu@oracle.com
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

Recently, I myself working on a RFC/PATCH regarding supply quota
supports to Linux container.

Per my investigation, looks the project quota feature in XFS is a great
start point, so that all the tasks/processes running at a particular
container(most likely in a virtual guest environment) would have
constrained by project quota.  Project quota is pretty cool, thank you
guys for working it out!

Now I have two rough ideas related to combine container with XFS:

The first choice is, mount XFS with PQUOTA option, place the virtual
guest on XFS disk, and setup project quota on the desired directory in
the first place, then assign the project_id to container via cgroup
control files.
The limits value(i.e, inode quota/block quota are setup based on cgroup
control files too).  In this case, there is no need to specify those
limits via xfs_quota(1).

However, to implement that, the projects directory path and project id
are still need to configured at /etc/projects && /etc/projid firstly if
they are not setup through command line directly.  Or even they are
configured via command line, but those two files will still be take into
account if they are presented.

I was wondering if other file system will also implement project quota
based on these two configuration files in the future? In other words, is
it a standard?

Alternatively, maybe the project path and ID can be setup at cgroup
control files too, the following things could be implemented like
"xfsprogs/quota/edit.c", but I would put aside this idea for now.


Would you guys please give any suggestions?

Thanks in advance!
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
