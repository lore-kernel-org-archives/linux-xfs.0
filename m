Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASLViPp256353 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 15:31:44 -0600
Received: from mail-yw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72A1C27D54C
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 13:31:43 -0800 (PST)
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id PlGyU1fxKBihgbkE
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 13:31:43 -0800 (PST)
Received: by ywm19 with SMTP id 19so6422440ywm.26
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 13:31:42 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Nov 2011 16:31:42 -0500
Message-ID: <CAOO4vO5ub0rQtJ_OF3E6fyNT2CcxiPNzO_6afBxhXLdHwbf2qQ@mail.gmail.com>
Subject: best stable recent kernel?
From: Paul Anderson <pha@umich.edu>
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
To: xfs-oss <xfs@oss.sgi.com>

I need to start deploying some large XFS based fileservers servers and
wish to try a kernel newer than what we've been using (2.6.38.5 from
kernel.org).

We've stayed at 2.6.38.5 for awhile, but have had metadata loss on
many shutdowns, clean or not.  We've found 0 length files where the
files had been written and closed long before the crash - in some
cases we were careful sync by hand, wait for quiescent drives, then
clean reboot, etc.  This sounds related to a series of commits that
indicates some workarounds and fixes in the time frame of 2.6.38.5 to
3.0 (how completely this particular problem was fixed, I don't know).

Several past threads here on this list have described these servers,
but they are 126 2TB drive RAID 60 used for mostly genetic sequencing
data.

Christoph recently suggested here in another xfs developer list thread:

"I've also backported it to the 3.0-stable issues.  I would recommend
to upgrade to the latest Linux 3.0-stable release, as I'll plan to
backport all important XFS fixes to it."

Is this a decent target for us to try?  We're looking for the best XFS
and NFS stability that is practical.

Thanks,

Paul Anderson
University of Michigan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
