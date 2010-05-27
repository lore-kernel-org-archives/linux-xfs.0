Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RDuZ1h137460 for <xfs@oss.sgi.com>; Thu, 27 May 2010 08:56:35 -0500
Received: from kaylee.flamingspork.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DB6737BD7D
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 06:58:57 -0700 (PDT)
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id uLRpdjx3vhmDSW28
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 06:58:57 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: NOW: o_direct   --  WAS: Re: WARNING in xfs_lwr.c, xfs_write()
In-Reply-To: <20100527114736.GA13112@infradead.org>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<4BF9FCA8.8090906@hardwarefreak.com>
	<20100524143428.6f3a117c@abend.internal.xtremedata.com>
	<20100526070620.GT2150@dastard>
	<4BFD3926.6040208@hardwarefreak.com>
	<20100527114736.GA13112@infradead.org>
Date: Thu, 27 May 2010 23:58:55 +1000
Message-ID: <87pr0hbg4g.fsf@willster.local.flamingspork.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Thu, 27 May 2010 07:47:37 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> O_DIRECT is not a Posix standard and not very portable.  It originated
> on IRIX, and Linux inherited it during the 2.4 kernel series days.
> These days FreeBSD/NetBSD and AIX support it as well, but for example
> Solaris, HP-UX and OpenBSD don't, nevermind Windows or Mac OS.

There is O_DIRECT type functionality available on Windows, with similar
restrictions for aligned IO too. You have to use the Win32 APIs to do it
though, the POSIX ones won't get you it (or more than 2048 files open at
once).

In practice we've only ever found Solaris (other than linux) to be
reliable with O_DIRECT (at least on UFS... ZFS is... well... I wouldn't
run a database server on it yet).

-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
