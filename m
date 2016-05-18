Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 427377CA0
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 11:37:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 05B79304048
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 09:37:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FAPKCc2zCEBbeUD8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 May 2016 09:37:35 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 11B198AE73
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 16:37:35 +0000 (UTC)
Received: from tarantula.localdomain (ovpn-116-102.phx2.redhat.com
	[10.3.116.102])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4IGbX9I012942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Wed, 18 May 2016 12:37:34 -0400
Date: Wed, 18 May 2016 11:37:33 -0500
From: Jeffrey Bastian <jbastian@redhat.com>
Subject: struct fsxattr redefinition
Message-ID: <20160518163733.GB14165@tarantula.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There was a discussion a few months ago about adding a guard for the
fsxattr struct [0] because it's defined in two places, the Linux kernel
header linux/fs.h [1] and xfsprogs header xfs/linux.h [2].

xfs/linux.h has a FS_IOC_FSGETXATTR guard around the struct fsxattr
definition, but this only works if linux/fs.h is included *before*
xfs/linux.h (or xfs/xfs.h).  If you include linux/fs.h after, then you
get a struct redefinition error.

Is it a requirement that linux/fs.h is included first?  If so, then
there is a bug in xfstests because it includes them in the wrong order
[3] and fails to build.  If there is not an order requirement, then both
header files should probably have a HAVE_FSXATTR guard around the struct
definition.

[0] http://oss.sgi.com/archives/xfs/2016-02/msg00306.html
[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/fs.h?h=v4.6#n152
[2] http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=blob;f=include/linux.h;h=cc0f70ceed72406822885d878b939b3e66c03ffd;hb=53cefc406eb1047ce9dc85906a0117f8da9f44ca#l177
[3] http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=blob;f=src/t_immutable.c;h=87ffc75f2d0229941ad6c5235ce9deea272d66c9;hb=HEAD#l41

-- 
Jeff Bastian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
