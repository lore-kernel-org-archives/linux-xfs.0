Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 465C37CA0
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 17:15:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F20CF304032
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 15:15:18 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id jU63neR0HxvgE3fZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Apr 2016 15:15:16 -0700 (PDT)
Subject: Bug#822369: xfsprogs: FTBFS: error: redefinition of 'struct fsxattr'
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.822369.B822369.146162246118545@bugs.debian.org>
Date: Tue, 26 Apr 2016 08:14:03 +1000
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20160425221403.GB18496@dastard>
References: <20160423205226.67773120316@dl580gen9-02.hlinux>
	<20160423210831.GA19384@jirafa.cyrius.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160423210831.GA19384@jirafa.cyrius.com>
Reply-To: Dave Chinner <david@fromorbit.com>, 822369@bugs.debian.org
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
To: Martin Michlmayr <tbm@hpe.com>, 822369@bugs.debian.org
Cc: submit@bugs.debian.org

On Sat, Apr 23, 2016 at 02:08:31PM -0700, Martin Michlmayr wrote:
> Package: xfsprogs
> Version: 4.3.0+nmu1
> Severity: serious
> 
> This package fails to build in unstable:
> 
> > sbuild (Debian sbuild) 0.68.0 (15 Jan 2016) on dl580gen9-02.hlinux
> ...
> >     [CC]     fiemap.o
> > In file included from ../include/xfs.h:58:0,
> >                  from io.h:19,
> >                  from fiemap.c:24:
> > ../include/xfs/xfs_fs.h:42:8: error: redefinition of 'struct fsxattr'
> >  struct fsxattr {
> >         ^
> > In file included from fiemap.c:22:0:
> > /usr/include/linux/fs.h:155:8: note: originally defined here
> >  struct fsxattr {
> >         ^
> > ../include/buildrules:59: recipe for target 'fiemap.o' failed
> > make[3]: *** [fiemap.o] Error 1
> > include/buildrules:35: recipe for target 'io' failed

Kernel uapi change in 4.5 caused it. Upgrade to xfsprogs 4.5.0.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
