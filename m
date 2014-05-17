Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F6657F3F
	for <xfs@oss.sgi.com>; Sat, 17 May 2014 13:03:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BBEA304039
	for <xfs@oss.sgi.com>; Sat, 17 May 2014 11:03:19 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id xG5MpDtwJmhJF9rO (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 17 May 2014 11:03:14 -0700 (PDT)
Subject: Bug#748483: xfsprogs: Let's add a watch file
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.748483.B.14003496038004@bugs.debian.org>
Content-Type: multipart/mixed; boundary="===============8774757689455281661=="
MIME-Version: 1.0
From: Vincent Blut <vincent.debian@free.fr>
Message-ID: <20140517175957.5232.71552.reportbug@lamella>
Date: Sat, 17 May 2014 19:59:57 +0200
Reply-To: Vincent Blut <vincent.debian@free.fr>, 748483@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Debian Bug Tracking System <submit@bugs.debian.org>

This is a multi-part MIME message sent by reportbug.


--===============8774757689455281661==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Source: xfsprogs
Version: 3.1.9
Severity: wishlist

Hey guys,

Even if it doesn't necessarily improve your workflow, the watch file could 
improve some Debian tools that check it (e.g. UDD). 
Could you please apply the attached one in your next upload?

Good day,
Vincent

-- System Information:
Debian Release: jessie/sid
  APT prefers testing
  APT policy: (990, 'testing'), (500, 'stable-updates'), (500, 'unstable'), (500, 'stable'), (1, 'experimental')
Architecture: amd64 (x86_64)

Kernel: Linux 3.14-1-amd64 (SMP w/4 CPU cores)
Locale: LANG=fr_FR.UTF-8, LC_CTYPE=fr_FR.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash

--===============8774757689455281661==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="watch"

version=3
opts=uversionmangle=s/(\d)[_\.\-\+]?((RC|rc|pre|dev|beta|alpha)\d*)$/$1~$2/ \
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-(.+)\.tar\.gz

--===============8774757689455281661==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8774757689455281661==--
