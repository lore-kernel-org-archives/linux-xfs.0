Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 01E5D7F53
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 00:26:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE8DB8F8037
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 22:26:25 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RtLEGbcOlAD2DD2m for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 22:26:21 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WJGsv-0002R9-0I
	for xfs@oss.sgi.com; Fri, 28 Feb 2014 17:25:25 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WJGsu-0000NU-Vh
	for xfs@oss.sgi.com; Fri, 28 Feb 2014 17:25:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] metadump: fixes for obfuscated dumps
Date: Fri, 28 Feb 2014 17:25:20 +1100
Message-Id: <1393568723-982-1-git-send-email-david@fromorbit.com>
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

The single patch to fix verifier failures in metadata dump has
grown. I identified a problem with processing of multiple objects in
a single buffer which prevented crcs from being calculated correctly
on obfuscated buffers. The first patch fixes that.

The second patch is the 3rd version ofteh original patch. If fixes
the problems that Eric pointed out, and it does the correct thing
w.r.t to contiguous blocks of single objects as well as inodes with
local format data.

The third patch is a fix for a problem that I came across in
testing. fsstress left a symlink that consumed the entire inode
literal area and so exposed a bug in the path name obfuscation where
it failed to correctly recognise the end of the symlink. We don't
store symlinks in null terminated form, so the use of strlen to
calculate the length of the last componenet was a timebomb waiting
to go off...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
