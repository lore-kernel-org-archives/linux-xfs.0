Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:25:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72BOsbm003236
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:24:59 -0700
Subject: PARTIAL TAKE 968563 - cleanup definitions of BMBT_*BITLEN macros
Message-Id: <20070802112453.44B6C58F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:24:53 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

cleanup definitions of BMBT_*BITLEN macros

The BMBT_*BITLEN are currently defined in a complicated way depending
on XFS_NATIVE_HOST.  But if all the macros are expanded they
(obviously) expand to the same value for both cases.

This patch defines the macros in the most simple way and updates the
comment describing them to remove outdated bits.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Aug  2 21:24:18 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29320a
fs/xfs/xfs_bmap_btree.h - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
	- Remove the dependency of the BMBT_*BITLEN macros on XFS_NATIVE_HOST
