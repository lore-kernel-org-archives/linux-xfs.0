Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3743A7F4C
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 10:27:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9D86AC007
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 08:27:08 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id t0IigCZZNBMDGC1C (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 08:27:07 -0700 (PDT)
Subject: Bug#705483: xfsprogs: xfs_quota misinterprets usernames with leading
	digits
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.705483.B.13660395475485@bugs.debian.org>
Message-ID: <516C12DB.3060806@bytemark.co.uk>
Date: Mon, 15 Apr 2013 15:46:51 +0100
From: James Carter <james.carter@bytemark.co.uk>
MIME-Version: 1.0
Reply-To: James Carter <james.carter@bytemark.co.uk>, 705483@bugs.debian.org
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
To: submit@bugs.debian.org

Subject: xfsprogs: xfs_quota misinterprets usernames with leading digits
Package: xfsprogs
Version: 3.1.4
Severity: normal

*** Please type your report below this line ***

xfs_quota interprets usernames with leading digits as a numeric UID so,
for example:

# xfs_quota -c 'quota -h -u 2000ad' /store
Disk quotas for User test (2000)
Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
/dev/sdb1       12K     1G     1G  00 [------] /store

This is returning quota information for the user "test" (UID 2000), rather
than the user "2000ad".

-- System Information:
Debian Release: 6.0.7
   APT prefers stable
   APT policy: (500, 'stable')
Architecture: amd64 (x86_64)

Kernel: Linux 3.2.0-0.bpo.4-amd64 (SMP w/12 CPU cores)
Locale: LANG=en_GB, LC_CTYPE=en_GB (charmap=UTF-8) (ignored: LC_ALL set 
to en_GB.UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages xfsprogs depends on:
ii  libblkid1                     2.17.2-9   block device id library
ii  libc6                         2.11.3-4   Embedded GNU C Library: 
Shared lib
ii  libreadline5                  5.2-7      GNU readline and history 
libraries
ii  libuuid1                      2.17.2-9   Universally Unique ID library

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
pn  acl <none>     (no description available)
pn  attr <none>     (no description available)
pn  quota <none>     (no description available)
pn  xfsdump <none>     (no description available)

-- no debconf information

-- 
James Carter                                           Bytemark Hosting
                                              http://www.bytemark.co.uk/
                                               tel: +44 (0) 1904 890 890

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
