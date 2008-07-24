Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 01:20:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6O8JvQ7032417
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 01:19:58 -0700
Subject: TAKE 981498 - convert xfs to use ERR_CAST
Message-Id: <20080724082106.10A7958C4C3F@chook.melbourne.sgi.com>
Date: Thu, 24 Jul 2008 18:21:05 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

 convert xfs to use ERR_CAST

Looks like somehow xfs got missed in the conversion that
took place in e231c2ee64eb1c5cd3c63c31da9dac7d888dcf7f,
"Convert ERR_PTR(PTR_ERR(p)) instances to ERR_CAST(p) <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e231c2ee64eb1c5cd3c63c31da9dac7d888dcf7f>"

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Acked-by: David Howells <dhowells@redhat.com>


Date:  Thu Jul 24 18:20:25 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  esandeen,dhowells@redhat.com,hch,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31757a
fs/xfs/linux-2.6/xfs_export.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
