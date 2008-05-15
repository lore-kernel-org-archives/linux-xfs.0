Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 23:46:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F6kBAU020631
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 23:46:15 -0700
Subject: TAKE 981816 - Don't use /tmp for hosting loopback images
Message-Id: <20080515064656.5107D58C4C29@chook.melbourne.sgi.com>
Date: Thu, 15 May 2008 16:46:56 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't use /tmp for hosting loopback images

/tmp might be small, might not support files larger than 2GB,
etc, so trying to host loopback images of 100GB filesystems
will break in some situations. We should use $TEST_DIR for the
images.

Note: remounting of loopback images has a major bug (in mount)
that "leaks" loopback device references. Hence all the hackery
with losetup to work around this.


Date:  Thu May 15 16:46:41 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31169a
xfstests/073 - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/073.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
	- Don't use /tmp for hosting loopback images
