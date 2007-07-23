Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 23:31:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6N6Vjbm007749
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 23:31:47 -0700
Subject: TAKE 967986 - Don't query project quota info on filesystems not mounted with pquota
Message-Id: <20070723063144.443DA58CC4CD@chook.melbourne.sgi.com>
Date: Mon, 23 Jul 2007 16:31:44 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Mon Jul 23 16:30:14 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  utako@tnes.nec.co.jp

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29202a
xfsprogs/VERSION - 1.175 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.175&r2=text&tr2=1.174&f=h
xfsprogs/doc/CHANGES - 1.244 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.244&r2=text&tr2=1.243&f=h
	- Update to 2.9.3

xfsprogs/quota/free.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/quota/free.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- Don't query project quota on filesystems not mounted with pquota
