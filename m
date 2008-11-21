Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAL0Uvgq009000 for <xfs@oss.sgi.com>; Thu, 20 Nov 2008 18:30:58 -0600
Subject: PARTIAL TAKE 990014 - xfs-cmds: Add parallel build support
Message-Id: <20081121003048.12CC159391F4@chook.melbourne.sgi.com>
Date: Fri, 21 Nov 2008 11:30:48 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Allow parallel builds of xfs-cmds.


Date:  Fri Nov 21 11:29:51 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  "Eric Sandeen" <sandeen@sandeen.net>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32514a
acl/Makefile - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/Makefile.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
acl/man/Makefile - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/man/Makefile.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
acl/include/buildrules - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/include/buildrules.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
attr/Makefile - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/Makefile.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
attr/man/Makefile - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/man/Makefile.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
attr/include/buildrules - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/include/buildrules.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/Makefile - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/Makefile.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
xfsprogs/man/Makefile - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/Makefile.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
xfsprogs/include/buildrules - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/buildrules.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsdump/Makefile - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/Makefile.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsdump/man/Makefile - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/man/Makefile.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfsdump/include/buildrules - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/include/buildrules.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
dmapi/Makefile - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/dmapi/Makefile.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
dmapi/man/Makefile - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/dmapi/man/Makefile.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
dmapi/include/buildrules - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/dmapi/include/buildrules.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
dmapi/include/buildmacros - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/dmapi/include/buildmacros.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/include/buildmacros - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/buildmacros.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
acl/include/buildmacros - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/include/buildmacros.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
attr/include/buildmacros - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/include/buildmacros.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsdump/include/buildmacros - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/include/buildmacros.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
nfs4acl/Makefile - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/nfs4acl/Makefile.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
nfs4acl/include/buildmacros - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/nfs4acl/include/buildmacros.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
nfs4acl/include/buildrules - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/nfs4acl/include/buildrules.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Allow parallel builds of xfs-cmds


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
