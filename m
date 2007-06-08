Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 00:53:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l587rVWt011344
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 00:53:32 -0700
Subject: TAKE 963528 - xfs_growfs_data_private not logging agf length change
Message-Id: <20070608075327.35F7B58C38C1@chook.melbourne.sgi.com>
Date: Fri,  8 Jun 2007 17:53:27 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Log the agf_length change in xfs_growfs_data_private().

Date:  Fri Jun  8 17:52:33 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  dgc@sgi.com,hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28856a
fs/xfs/xfs_fsops.c - 1.125 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.125&r2=text&tr2=1.124&f=h
	- Log the agf_length change in xfs_growfs_data_private().
