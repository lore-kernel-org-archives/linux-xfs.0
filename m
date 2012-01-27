Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RKpm0G250120 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 14:51:48 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id Cl9J7HRFTHb3Twzv for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 12:51:47 -0800 (PST)
Message-ID: <4F230E62.8020004@sandeen.net>
Date: Fri, 27 Jan 2012 14:51:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Question on xfstest 274
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
To: wu.bo@cn.fujitsu.com, xfs-oss <xfs@oss.sgi.com>

Hi, I was wondering if you could describe your intent for 274 just a little more.

The test says:

# preallocation test

but that is the only comment other than copyright.  ;)

I see that it does:

# Make a 1G fs
# Create a single 4k file
# Allocate 1M past the EOF on that file
# Completely fill remaining space, using 2 other files
# Write 8k past EOF on the original file which has blocks past EOF

but I am not certain what you are testing.  I presume that
you are testing the fact that the 1M past EOF should be truncated,
freeing up space, and allowing the 8k write to succeed?
Is that right?

However, at least on ext4 I noticed that the "fill the fs"
stage does not succeed; perhaps that should be tested as well.

I can do some similar work on this like I did for 275, but I need
to be sure I understand your original intent for the test, first.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
