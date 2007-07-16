Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 19:08:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G28Ebm025290
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 19:08:16 -0700
Subject: TAKE 958216 - xfs_io requires a target file to be specified even if the subcommand doesn't
Message-Id: <20070716020813.1A83458C38F1@chook.melbourne.sgi.com>
Date: Mon, 16 Jul 2007 12:08:13 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Improve xfs_io and xfs_quota -c handling


Date:  Mon Jul 16 12:07:24 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  nscott@aconex.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29139a
xfsprogs/io/file.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/file.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- Make xfs_io print command global

xfsprogs/libxcmd/quit.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxquit.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Make the quit command global

xfsprogs/libxcmd/help.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxhelp.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Make the help command global

xfsprogs/libxcmd/command.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxcommand.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- Handle global commands once without iterating objects

xfsprogs/include/command.h - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/command.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Define command global command flag

xfsprogs/quota/path.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/quota/path.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Make xfs_quota print and path commands global
