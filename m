Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAF6L8j0034568 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 00:21:08 -0600
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32CAD24E46A
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 22:21:05 -0800 (PST)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id Sz5LwK25xomOwmad for
	<xfs@oss.sgi.com>; Mon, 14 Nov 2011 22:21:05 -0800 (PST)
Subject: Bug#553875: fixed in xfsprogs 3.1.6
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.553875.B553875.13213379076815@bugs.debian.org>
Date: Tue, 15 Nov 2011 07:18:22 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
Message-ID: <20111115061822.GA6219@hall.aurel32.net>
References: <E1ROjxS-0007Tc-0c@franck.debian.org>
	<20111114214850.GA16572@volta.aurel32.net>
	<CAAp5ZgNLZHEJaHU3J+kspf0B6BbAtp=6hhwWbo3_NRLjVxO3=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAp5ZgNLZHEJaHU3J+kspf0B6BbAtp=6hhwWbo3_NRLjVxO3=A@mail.gmail.com>
Reply-To: Aurelien Jarno <aurelien@aurel32.net>, 553875@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nathan Scott <nathans@debian.org>
Cc: 553875@bugs.debian.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

On Tue, Nov 15, 2011 at 12:00:50PM +1100, Nathan Scott wrote:
> Hi Aurelien,
> 
> On 15 November 2011 08:48, Aurelien Jarno <aurelien@aurel32.net> wrote:
> 
> >
> > This new version basically replaced the build-depends on
> >  libreadline-gplv2-dev
> > by a build-depends on
> >  libreadline5-dev | libreadline-gplv2-dev
> >
> > Given libreadline5-dev is not in the archive, the package can't be
> > built,
> 
> 
> It seems to work as expected for me (iow, if either of the two are
> installed, it proceeds with using the installed package).  I tested both
> variants on latest unstable, so I'm at a loss to explain the failure you're
> seeing - can you forward the build output showing the issue?

The buildd daemons require that the first package of an alternative
exists in the archive, which is not the case there. You'll find
attached a build log showing the issue.

-- 
Aurelien Jarno	                        GPG: 1024D/F1BCDB73
aurelien@aurel32.net                 http://www.aurel32.net

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: attachment; filename="xfsprogs_3.1.6-s390-20111115-0227"
Content-Transfer-Encoding: 8bit

sbuild (Debian sbuild) 0.61.0 (23 Feb 2011) on zandonai.debian.org

╔══════════════════════════════════════════════════════════════════════════════╗
║ xfsprogs 3.1.6 (s390)                                      15 Nov 2011 02:27 ║
╚══════════════════════════════════════════════════════════════════════════════╝

Package: xfsprogs
Version: 3.1.6
Source Version: 3.1.6
Architecture: s390
Get:1 http://ftp.de.debian.org unstable InRelease [146 kB]
Get:2 http://incoming.debian.org unstable InRelease [146 kB]
Get:3 http://ftp.de.debian.org unstable/main Sources [5933 kB]
Ign http://incoming.debian.org  InRelease
Get:4 http://incoming.debian.org  Release.gpg [836 B]
Get:5 http://incoming.debian.org unstable/main Sources [5933 kB]
Get:6 http://ftp.de.debian.org unstable/contrib Sources [57.2 kB]
Get:7 http://ftp.de.debian.org unstable/non-free Sources [103 kB]
Get:8 http://ftp.de.debian.org unstable/main s390 Packages [7631 kB]
Get:9 http://ftp.de.debian.org unstable/contrib s390 Packages [54.9 kB]
Ign http://ftp.de.debian.org unstable/contrib TranslationIndex
Get:10 http://ftp.de.debian.org unstable/main TranslationIndex [2045 B]
Ign http://ftp.de.debian.org unstable/contrib Translation-en
Get:11 http://incoming.debian.org unstable/contrib Sources [57.2 kB]
Get:12 http://incoming.debian.org unstable/non-free Sources [103 kB]
Get:13 http://incoming.debian.org unstable/main s390 Packages [7633 kB]
Get:14 http://incoming.debian.org unstable/contrib s390 Packages [54.9 kB]
Ign http://incoming.debian.org unstable/contrib TranslationIndex
Get:15 http://incoming.debian.org unstable/main TranslationIndex [2045 B]
Get:16 http://incoming.debian.org  Release [1604 B]
Get:17 http://incoming.debian.org  Sources [30.5 kB]
Get:18 http://incoming.debian.org  Packages [502 kB]
Ign http://incoming.debian.org unstable/contrib Translation-en
Ign http://incoming.debian.org  Translation-en
Fetched 28.4 MB in 26s (1068 kB/s)
Reading package lists...

┌──────────────────────────────────────────────────────────────────────────────┐
│ Fetch source files                                                           │
└──────────────────────────────────────────────────────────────────────────────┘


Check APT
─────────

Checking available source versions...

Download source files with APT
──────────────────────────────

Reading package lists...
Building dependency tree...
Reading state information...
Need to get 1398 kB of source archives.
Get:1 http://ftp.de.debian.org/debian/ unstable/main xfsprogs 3.1.6 (dsc) [1096 B]
Get:2 http://ftp.de.debian.org/debian/ unstable/main xfsprogs 3.1.6 (tar) [1397 kB]
Fetched 1398 kB in 0s (2784 kB/s)
Download complete and in download only mode

Check arch
──────────


┌──────────────────────────────────────────────────────────────────────────────┐
│ Install core build dependencies (internal resolver)                          │
└──────────────────────────────────────────────────────────────────────────────┘

Build-Depends: build-essential, fakeroot
Checking for already installed dependencies...
build-essential: already installed (11.5)
fakeroot: already installed (1.18.1-1)
Checking for dependency conflicts...
Installing positive dependencies: 
Reading package lists...
Building dependency tree...
Reading state information...
0 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
Removing negative dependencies: 
Reading package lists...
Building dependency tree...
Reading state information...
0 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
Checking correctness of dependencies...

┌──────────────────────────────────────────────────────────────────────────────┐
│ Install xfsprogs build dependencies (internal resolver)                      │
└──────────────────────────────────────────────────────────────────────────────┘

Build-Depends: base-files, base-passwd, bash, coreutils, dash, debianutils, diffutils, dpkg, e2fsprogs, findutils, grep, gzip, hostname, ncurses-base, ncurses-bin, perl-base, sed, login, sysvinit-utils, sysvinit, tar, bsdutils, mount, util-linux, libc6-dev | libc-dev, gcc (>= 4:4.4.3), g++ (>= 4:4.4.3), make, dpkg-dev (>= 1.13.5), uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline5-dev | libreadline-gplv2-dev, libblkid-dev (>= 2.17)
Checking for already installed dependencies...
base-files: already installed (6.5)
base-passwd: already installed (3.5.23)
bash: already installed (4.1-3)
coreutils: already installed (8.13-3)
dash: already installed (0.5.7-2)
debianutils: already installed (4.0.4)
diffutils: already installed (1:3.2-1)
dpkg: already installed (1.16.1.1)
e2fsprogs: already installed (1.42~WIP-2011-10-16-1)
findutils: already installed (4.4.2-1+b1)
grep: already installed (2.9-2)
gzip: already installed (1.4-2)
hostname: already installed (3.06)
ncurses-base: already installed (5.9-4)
ncurses-bin: already installed (5.9-4)
perl-base: already installed (5.14.2-3)
sed: already installed (4.2.1-9)
login: already installed (1:4.1.4.2+svn3283-3)
sysvinit-utils: already installed (2.88dsf-13.13)
sysvinit: already installed (2.88dsf-13.13)
tar: already installed (1.26-3)
bsdutils: already installed (1:2.19.1-5)
mount: already installed (2.19.1-5)
util-linux: already installed (2.19.1-5)
libc6-dev: already installed (2.13-21)
gcc: already installed (4:4.6.1-3 >= 4:4.4.3 is satisfied)
g++: already installed (4:4.6.1-3 >= 4:4.4.3 is satisfied)
make: already installed (3.81-8.1)
dpkg-dev: already installed (1.16.1.1 >= 1.13.5 is satisfied)
uuid-dev: missing
autoconf: missing
debhelper: missing
Using default version 8.9.9
gettext: missing
libtool: missing
libreadline5-dev: missing
libreadline-gplv2-dev: missing
libblkid-dev: missing
Using default version 2.19.1-5
Checking for dependency conflicts...
E: Package 'libreadline5-dev' has no installation candidate
Installing positive dependencies: uuid-dev autoconf debhelper gettext libtool libreadline5-dev libblkid-dev
Reading package lists...
Building dependency tree...
Reading state information...
Package libreadline5-dev is not available, but is referred to by another package.
This may mean that the package is missing, has been obsoleted, or
is only available from another source
However the following packages replace it:
  libreadline-gplv2-dev lib64readline-gplv2-dev

E: Package 'libreadline5-dev' has no installation candidate
apt-get failed.
Package installation failed
Not removing build depends: cloned chroot in use
Source-dependencies not satisfied; skipping xfsprogs
Purging /var/lib/schroot/mount/sid-s390-sbuild-03b3f6a5-6fa3-4646-9e64-e51bea664789/build/buildd-xfsprogs_3.1.6-s390-Hf4YVI
Not cleaning session: cloned chroot in use

┌──────────────────────────────────────────────────────────────────────────────┐
│ Summary                                                                      │
└──────────────────────────────────────────────────────────────────────────────┘

Architecture: s390
Build-Space: 0
Build-Time: 0
Distribution: sid
Fail-Stage: install-deps
Install-Time: 0
Job: xfsprogs_3.1.6
Package: xfsprogs
Package-Time: 0
Source-Version: 3.1.6
Space: 0
Status: given-back
Version: 3.1.6
────────────────────────────────────────────────────────────────────────────────
Finished at 20111115-0227
Build needed 00:00:00, 0k disc space

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--LZvS9be/3tNcYl/X--
