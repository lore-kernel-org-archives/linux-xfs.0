Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 00:25:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l727PFbm012238
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 00:25:18 -0700
Subject: TAKE PARTIAL 968554 - Filestreams fixes for 2.6.23
Message-Id: <20070802072515.9F08058F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 17:25:15 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

On-demand reaping of the MRU cache

Instead of running the mru cache reaper all the time based on a
timeout, we should only run it when the cache has active objects.
This allows CPUs to sleep when there is no activity rather than
be woken repeatedly just to check if there is anything to do.

Date:  Thu Aug  2 17:24:38 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  donaldd

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29305a
fs/xfs/xfs_mru_cache.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mru_cache.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Change the reaper to start when the first object is stored
	  in the cache and stop when the last object is reaped.

fs/xfs/xfs_mru_cache.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mru_cache.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Change the reaper to start when the first object is stored
	  in the cache and stop when the last object is reaped.

fs/xfs/xfs_filestream.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_filestream.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- No longer need to tell the MRU cache to restart the reaper
	  when we flush the cache.
