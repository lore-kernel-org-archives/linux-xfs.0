Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0975C7CA4
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 01:23:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71D94AC002
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 23:23:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aeYuxCyiYOb1bv1l for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2016 23:22:59 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] iomap: fixes for fiemap interface
Date: Mon,  8 Aug 2016 16:22:29 +1000
Message-Id: <1470637351-27933-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

Hi folks,

A couple of fixes things that Darrick and I noticed when using the
iomap fiemap implementation. Darrick noticed that the attribute fork
couldn't be mapped when updating his XFS scrubbing utility, and I
noticed that the FIEMAP_FLAG_SYNC was being ignored by the code
while looking at the attribute mapping issue.  Both are regressions
agains the old XFS fiemap implementation.

The attribute mapping patch is the one that needs the most attention
as it adds an iomap control flag and a new iomap internal error. The
issue is that we don't know if there are attributes to map until
we call down into the filesystem specific code, and at that point we
need to tell iomap_apply() that there is nothing to map and so break
out. This is done by returning -ENOENT, and then capturing that
in iomap_fiemap() and treating it like we've reached the end of
file. This causes fiemap to report the attribute map as having no
extents.

We also need to protect against write mappings being made against
the attribute fork in XFS as it's not valid to write into the
attribute extent map via this method. Hence we return -EINVAL if we
detect an attempt to do so through the iomap control flags.

I'm not sure it's the best way to solve the problem, but it does
work. Better ideas are welcome...

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
