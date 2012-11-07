Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7DauYL153903 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 07:36:56 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8PAnOy6nKv5uxafg for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 05:38:53 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TW5p1-0001dW-9I
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 00:37:35 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TW5p1-0001GR-4v
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 00:37:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: CRCs for log buffers
Date: Thu,  8 Nov 2012 00:37:30 +1100
Message-Id: <1352295452-4726-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

These patches introduce the first little piece of the CRC picture.
The first patch introduces the calculation and checking functions,
as well as the superblock feature bit for CRCs. The superblock bit
is not set anywhere, not is it really needed for 3.8. There's no
real harm in introducing it now, and doing so means that the log
code can demonstrate how it will differentiate between advisory
warnings and fatal errors on CRC mistmatches during recovery.

The second patch converts the log checksum code to use the CRCs and
enables it for *all* filesystems. This can be done because the log
header already has a CRC field in it, and for production kernels it
is guaranteed to be zeroed. Hence for production kernels, only
issuing a CRC mistmatch warning when the log header CRC field is non
zero means that people can upgrade to a kernel with this
functionality and not see any CRC mismatch warnings.

Warnings look like:

XFS (vda): log record CRC mismatch: found 0xa05866c2, expected 0xd9290110.

ffffc90001088000: 00 00 00 14 00 00 00 00 69 01 00 00 6e 14 a5 3d  ........i...n..=
ffffc90001088010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00  ....i...NART*...


The only issue with this is that filesystems that were not cleanly
shut down on debug kernels will throw CRC mismatch warnings the
first time the are recovered after mount. After the first mount on
upgrade, the warnings won't happen again unless you downgrade to an
older debug kernel. I don't see this as a major problem - debug
kernels are not used in production, and anyone using a debug kernel
should be following this mailing list. ;)

Anyway, the overhead is negliable - I don't see any measurable
impact on metadata heavy operations (cpu verhead or performance),
and the benefits of even advisory warnings on production kernels are
of significant benefit. e.g. the recent log buffer wrap recovery
problem would have triggered a CRC mismatch warning long before
the bad client id error was detected....

As such, I'd really like to have this in the 3.8 kernel - it gets
the initial CRC code more testing, and provides us with an immediate
integrity benefit and important debug information when log recovery
problems are reported (i.e. we know definitely that the log is or
isn't corrupted). I think the risk is rather small that it will
cause problems, and the worst it can cause is scary looking noise
in the logs.

Comments?

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
