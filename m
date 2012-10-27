Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9RLbHOL109553 for <xfs@oss.sgi.com>; Sat, 27 Oct 2012 16:37:17 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id O4Mvu7zTEJx2hgxQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 27 Oct 2012 14:39:04 -0700 (PDT)
Subject: Bug#691630: xfsprogs doesn't include the program xfsctl
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.691630.B.13513738375832@bugs.debian.org>
Message-ID: <508C5237.4010904@sandeen.net>
Date: Sat, 27 Oct 2012 16:29:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
References: <20121027183300.8033.65529.reportbug@logan-VirtualBox>
In-Reply-To: <20121027183300.8033.65529.reportbug@logan-VirtualBox>
Reply-To: Eric Sandeen <sandeen@sandeen.net>, 691630@bugs.debian.org
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
To: Logan Rosen <logatronico@gmail.com>, 691630@bugs.debian.org
Cc: Debian Bug Tracking System <submit@bugs.debian.org>

On 10/27/12 1:33 PM, Logan Rosen wrote:
> Package: xfsprogs
> Version: 3.1.7build1
> Severity: important
> User: ubuntu-devel@lists.ubuntu.com
> Usertags: origin-ubuntu raring
> 
> Dear Maintainer,
> 
> This bug report was also filed in Ubuntu and can be found at
> http://launchpad.net/bugs/1071800
> The description, from Austin S. Hemmelgarn, follows:
> 
> Multiple other manpages in the package reference this program, and some of the
> functionality of the XFS filesystem is only availible through it.  I believe
> that it was included in a previous package version, as it shows up in the list
> obtained from `apropos xfs`

Please close NOTABUG.

xfsctl is an interface, not an application; note that it is in section 3 of
the manual, which is for C library functions:

XFSCTL(3)                                                            XFSCTL(3)

NAME
       xfsctl - control XFS filesystems and individual files

C SYNOPSIS
       #include <xfs/xfs.h>

       int xfsctl(const char *path, int fd, int cmd, void *ptr);


> ProblemType: Bug
> DistroRelease: Ubuntu 12.10
> Package: xfsprogs 3.1.7build1
> ProcVersionSignature:
> 
> Uname: Linux 3.5.7-local x86_64
> ApportVersion: 2.6.1-0ubuntu6
> Architecture: amd64
> Date: Fri Oct 26 11:34:06 2012
> InstallationDate: Installed on 2012-06-14 (133 days ago)
> InstallationMedia: Xubuntu 12.04 LTS "Precise Pangolin" - Release amd64
> (20120425)
> MarkForUpload: True
> SourcePackage: xfsprogs
> UpgradeStatus: Upgraded to quantal on 2012-10-20 (6 days ago)
> 
> -- System Information:
> Debian Release: wheezy/sid
>   APT prefers raring-updates
>   APT policy: (500, 'raring-updates'), (500, 'raring-security'), (500,
> 'raring'), (100, 'raring-backports')
> Architecture: amd64 (x86_64)
> Foreign Architectures: i386
> 
> Kernel: Linux 3.5.0-17-generic (SMP w/1 CPU core)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
