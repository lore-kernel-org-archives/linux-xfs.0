Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C57C7F5F
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 15:05:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CDF37AC011
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 13:05:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	W47VngO8oHoAx0gP for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 13:05:02 -0700 (PDT)
Date: Wed, 2 Sep 2015 06:04:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] progs: use make provided CURDIR instead of rolling our own
Message-ID: <20150901200448.GK26895@dastard>
References: <1441131010-5439-1-git-send-email-dev@lynxeye.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441131010-5439-1-git-send-email-dev@lynxeye.de>
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
To: Lucas Stach <dev@lynxeye.de>
Cc: xfs@oss.sgi.com

On Tue, Sep 01, 2015 at 08:10:10PM +0200, Lucas Stach wrote:
> This fixes broken header symlinks when make isn't triggered from the xfsprogs
> source location, but as a recursion from another make in a different
> directory. This is a common pattern found in cross build systems.

It should actually use TOPDIR to be consistent with the result of
the makefiles. i.e. all paths are relative to TOPDIR, not PWD or
CURDIR.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
