Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3UFOXit126380
	for <linux-xfs@oss.sgi.com>; Sat, 30 Apr 2011 10:24:33 -0500
Received: from april.london.02.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1D01422D46
	for <linux-xfs@oss.sgi.com>; Sat, 30 Apr 2011 08:28:07 -0700 (PDT)
Received: from april.london.02.net (april.london.02.net [87.194.255.143]) by
	cuda.sgi.com with ESMTP id kDWPY2yGaBPz7uZq for
	<linux-xfs@oss.sgi.com>; Sat, 30 Apr 2011 08:28:07 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <19900.8703.214676.218477@tree.ty.sabi.co.UK>
Date: Sat, 30 Apr 2011 15:51:43 +0100
Subject: op-journaled fs, journal size and storage speeds
From: pg_xf2@xf2.to.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <linux-xfs@oss.sgi.com>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>

Been thinking about journals and RAID6s and SSDs.

In particular for file system designs like JFS and XFS that do
operation journaling (while ext[34] do block journaling).

The issue is: journal size?

It seems to me that adopting as guideline a percent of the
filesystem is very wrong, and so I have been using a rule of
thumb like one second of expected transfer rate, so "in flight"
updates are never much behind.

But even at a single disk *sequential* transfer rate of say
80MB/s average, a journal that contains operation records could
conceivably hold dozens if not hundreds of thousands of pending
metadata updates, probably targeted at very widely scattered
locations on disk, and playing a journal fully could take a long
time.

So the idea would be that the relevant transfer rate would be
the *random* one, and since that is around 4MB/s per single
disk, journal sizes would end up pretty small. But many people
allocate very large (at least compared to that) journals.

This seems to me a fairly bad idea, because then the journal
becomes a massive hot spot on the disk and draws the disk arm
like black hole. I suspect that operations should not stay on
the journal for a long time. However if the journal is too small
processes that do metadata updates start to hang on it.

So some questions for which I have guesses but not good answers:

  * What should journal size be proportional to?
  * What is the downside of a too small journal?
  * What is the downside of a too large journal other than space?

Again I expect answers to be very different for ext[34] but I am
asking for operation-journaling file system designs like JFS and
XFS.

BTW, another consideration is that for filesystems that are
fairly journal-intensive, putting the journal on a low traffic
storage device can have large benefits.

But if they can be pretty small, I wonder whether putting the
journals of several filesystems on the same storage device then
becomes a sensible option as the locality will be quite narrow
(e.g. a single physical cylinder) or it could be wortwhile like
the database people do to journal to battery-backed RAM.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
