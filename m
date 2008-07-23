Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:57:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N7v7gT013834
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:57:08 -0700
Subject: TAKE 981498 - Move xfs_attr_rolltrans to xfs_trans_roll
Message-Id: <20080723075810.8F0B958C4C3F@chook.melbourne.sgi.com>
Date: Wed, 23 Jul 2008 17:58:10 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Move xfs_attr_rolltrans to xfs_trans_roll

Move it from the attr code to the transaction code and make the attr
code call the new function.

We rolltrans is really usefull whenever we want to use rolling
transaction, should be generic, it isn't dependent on any part of the
attr code anyway.

We use this excuse to change all the:
 if ((error = xfs_attr_rolltrans()))

calls into:
 error = xfs_trans_roll();
 if (error)

Signed-off-by: Niv Sardi <xaiki@sgi.com>


Date:  Wed Jul 23 17:57:24 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  hch,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31729a
fs/xfs/xfs_attr_leaf.h - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.h.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
fs/xfs/xfs_attr_leaf.c - 1.114 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.114&r2=text&tr2=1.113&f=h
fs/xfs/xfs_trans.c - 1.186 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.186&r2=text&tr2=1.185&f=h
fs/xfs/xfs_trans.h - 1.150 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.150&r2=text&tr2=1.149&f=h
fs/xfs/xfs_attr.c - 1.156 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.156&r2=text&tr2=1.155&f=h
