Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B99AC7F59
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 01:17:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87F24304066
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 23:17:21 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xXfrYzwtwDbUqQic for <xfs@oss.sgi.com>;
	Tue, 21 Jan 2014 23:17:20 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W5s3p-0001YN-K9
	for xfs@oss.sgi.com; Wed, 22 Jan 2014 18:17:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W5s3p-0002jq-J2
	for xfs@oss.sgi.com; Wed, 22 Jan 2014 18:17:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs_repair: fix discontiguous directory block
Date: Wed, 22 Jan 2014 18:17:10 +1100
Message-Id: <1390375033-10483-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This series fixes up one of the problems that was causing xfs/291
to fail on crc enabled filesystems. basically CRCs were failing on
directory buffers because they weren't being treated as a
discontiguous buffer correctly by prefetch and hence CRCs were only
eve calculated over a portion of the directory block. Hence it threw
lots of errors. Non CRC filesystems threw the same badness on lookup
errors, but repair managed to rebuild the directory buffers
sufficiently for things to work.

Anyway, this patchset fixes the xfs_repair prefetch code to handle
discontiguous buffers and so avoid all the noise that was being
generated and the errors that were being triggered on CRC
filesystems.

This does no make xfs/291 pass on CRC filesystems. Making xfs_reapir
work has pointed out that metadump's handling of multi-block
directory buffers on CRC enable filesystems also appears to be
broken. Fixing that is another patchset, however.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
