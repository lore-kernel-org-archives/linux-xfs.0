Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 18:39:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4J1dihh030185
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 18:39:45 -0700
Subject: PARTIAL TAKE 981558 - Add configurable xattr copy support
Message-Id: <20080519014029.3685258C4C29@chook.melbourne.sgi.com>
Date: Mon, 19 May 2008 11:40:29 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

The current attribute copying functions attr_copy_file and
attr_copy_fd is a static list of exceptions for attributes that need special
treatment. The list of those attributes tends to change (slowly) with kernel
versions. We replaced the static list with a config file a while ago; this is
the patch used.


Date:  Mon May 19 11:39:49 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  agruen@suse.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31181a
attr/libattr/attr_copy_action.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libattr/attr_copy_action.c
attr/libattr/Makefile - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libattr/Makefile.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
attr/include/libattr.h - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/include/libattr.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
attr/libattr/attr_copy_fd.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libattr/attr_copy_fd.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
attr/libattr/attr_copy_file.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libattr/attr_copy_file.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
attr/libattr/attr_copy_check.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libattr/attr_copy_check.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- Add configurable xattr copy
