Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4866C7F5D
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 23:05:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0961AC001
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 21:05:07 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9bHKU1bxGxtg01wi for <xfs@oss.sgi.com>;
	Sun, 10 Feb 2013 21:05:06 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1U4lZg-0000qx-O7
	for xfs@oss.sgi.com; Mon, 11 Feb 2013 16:05:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1U4lZg-0005KV-K1
	for xfs@oss.sgi.com; Mon, 11 Feb 2013 16:05:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: couple of patches for 3.9
Date: Mon, 11 Feb 2013 16:05:00 +1100
Message-Id: <1360559102-20432-1-git-send-email-david@fromorbit.com>
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

These are a couple of patches I have in my queue that are should be
OK for the 3.9 cycle. The first is a fixed version of the
specualtive preallocation sparse file handling improvement - it now
does what it claims to do. :)

The second is a re-organisation of xfs_bmap.c, I got sick of having
to jump all over the file when trying to work on a small part of the
code, so I rearranged the code into a more sane layout. It's a big
patch, but it doesn't change any code except to remove the forward
declarations of various functions. It's not a big deal if nobody
wants this, but I find the re-organised layout much easier to deal
with, and potentially points at ways that big file can be split up
if we want to...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
