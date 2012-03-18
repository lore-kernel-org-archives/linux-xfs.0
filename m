Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2ILHWeN027048 for <xfs@oss.sgi.com>; Sun, 18 Mar 2012 16:17:32 -0500
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id l1HJhQ47oxEtM8qx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 18 Mar 2012 14:17:26 -0700 (PDT)
Subject: Bug#664550: xfs_quota: "report -p" doesn't show all projects
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.664550.B.133210510920574@bugs.debian.org>
Date: Sun, 18 Mar 2012 22:11:11 +0100
From: Sergio Gelato <Sergio.Gelato@astro.su.se>
Message-ID: <20120318211111.GA22507@hanuman.astro.su.se>
MIME-Version: 1.0
Content-Disposition: inline
Reply-To: Sergio Gelato <Sergio.Gelato@astro.su.se>, 664550@bugs.debian.org
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
To: submit@bugs.debian.org

Package: xfsprogs
Version: 3.1.4

When invoked without an explicit -U argument, the report and dump subcommands
of xfs_quota only mention projects that have a corresponding entry in
/etc/projid . This important fact is not mentioned in the man page.
It could easily result in loss of quota limit information across dump/restore
on systems where /etc/projid is out of date, corrupt or missing.

(Aside: even the fact that the dump subcommand accepts -L and -U isn't 
documented in the man page. Why not?)

With an explicit -U, the code switches from getprent() (which iterates
over the contents of /etc/projid) to a simple loop over all project IDs
in the given range. This is better, except possibly for performance if
the project ID space is sparse.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
