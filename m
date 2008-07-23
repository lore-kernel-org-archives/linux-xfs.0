Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:34:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N7XsUS010932
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:33:56 -0700
Subject: TAKE 981498 - don't leak m_fsname/m_rtname/m_logname
Message-Id: <20080723073500.81FF258C4C3F@chook.melbourne.sgi.com>
Date: Wed, 23 Jul 2008 17:35:00 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

don't leak m_fsname/m_rtname/m_logname

Add a helper to free the m_fsname/m_rtname/m_logname allocations and use
it properly for all mount failure cases.  Also switch the allocations
for these to kstrdup while we're at it.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Jul 23 17:33:46 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  hch,dgc,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31728a
fs/xfs/xfs_mount.c - 1.438 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.438&r2=text&tr2=1.437&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.438 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.438&r2=text&tr2=1.437&f=h
