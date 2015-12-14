Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C6547F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 14:03:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DDE8C8F8037
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 12:03:13 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id 5fP5FuhGCZ5Hfjig (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2015 12:03:06 -0800 (PST)
Subject: Bug#807879: xfsprogs: Cannot mount XFS filesystem formated with
	mkfs.xfs newer than 3.2.1
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.807879.B.145012317118986@bugs.debian.org>
Date: Tue, 15 Dec 2015 06:59:14 +1100
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20151214195914.GN26718@dastard>
References: <145005783346.24095.10578707004408280277.reportbug@flop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <145005783346.24095.10578707004408280277.reportbug@flop>
Reply-To: Dave Chinner <david@fromorbit.com>, 807879@bugs.debian.org
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
To: Emil <ee@la.mine.nu>, 807879@bugs.debian.org
Cc: Debian Bug Tracking System <submit@bugs.debian.org>

On Mon, Dec 14, 2015 at 01:50:33AM +0000, Emil wrote:
> Package: xfsprogs
> Version: 4.3.0
> Severity: normal
> 
> For any version of xfsprogs after v3.2.1 formating with default options:
....
> Kernel: Linux 3.4.110 (SMP w/4 CPU cores)

You're using a old kernel that does not support the newer features
that mkfs.xfs now sets by default. Upgrade your kernel or turn off
the features your kernel does not support. (i.e. -m crc=0)

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
