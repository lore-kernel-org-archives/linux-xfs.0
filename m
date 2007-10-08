Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 23:31:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l986V7ne023066
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 23:31:10 -0700
Subject: PARTIAL TAKE 971186 - lose xfs_hex_dump in favor of print_hex_dump
Message-Id: <20071008063105.2E85558C38F1@chook.melbourne.sgi.com>
Date: Mon,  8 Oct 2007 16:31:05 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

lose xfs_hex_dump in favor of print_hex_dump

No need for xfs to have its own hex dumping routine now that the
kernel has one.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Mon Oct  8 16:30:20 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-oss
Inspected by:  Eric Sandeen <sandeen@sandeen.net>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29847a
fs/xfs/xfs_error.c - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.c.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
fs/xfs/xfs_error.h - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.h.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
fs/xfs/support/debug.c - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/debug.c.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
	- lose xfs_hex_dump in favor of print_hex_dump
