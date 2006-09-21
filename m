Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Sep 2006 23:46:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8L6kjaG022228
	for <xfs@oss.sgi.com>; Wed, 20 Sep 2006 23:46:49 -0700
Subject: TAKE 956363 956371 - md.raid_disks, __u32 from asm/types.h
Message-Id: <20060921064602.BCDE358CF853@chook.melbourne.sgi.com>
Date: Thu, 21 Sep 2006 16:46:02 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Update xfsprogs so that the libdisk/md.c code sets stripe width using number
of raid-disks and doesn't include spare disks.
Make xfsprogs get its __u32 & friends types from <asm/types.h> if it exists.


Date:  Thu Sep 21 16:44:55 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  stripathi@agami.com,bnaujok@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27016a
xfsprogs/configure.in - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/configure.in.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
	- Add a AC_CHECK_TYPES for __u32 in <asm/types.h>.

xfsprogs/VERSION - 1.163 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.163&r2=text&tr2=1.162&f=h
	- Bump to 2.8.13.

xfsprogs/doc/CHANGES - 1.220 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.220&r2=text&tr2=1.219&f=h
	- Describe changes for 2.8.13.

xfsprogs/libdisk/md.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libdisk/md.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Use raid_disks in lieu of nr_disks so that we don't include spares.
	  Thanks to Shailendra.

xfsprogs/include/platform_defs.h.in - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/platform_defs.h.in.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
	- Don't define the __u32 family types if we can get them from <asm/types.h>.
