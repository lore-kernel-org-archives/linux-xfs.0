Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7TKtgu4072126
	for <linux-xfs@oss.sgi.com>; Wed, 29 Aug 2012 15:55:45 -0500
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id icEzOdX87eysTBwu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Wed, 29 Aug 2012 13:56:34 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1T6pJQ-0002KI-Fg
	for linux-xfs@oss.sgi.com; Wed, 29 Aug 2012 22:56:32 +0200
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 29 Aug 2012 22:56:32 +0200
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 29 Aug 2012 22:56:32 +0200
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: XFS or MDADM issue?
Date: Wed, 29 Aug 2012 13:49:34 -0700
Message-ID: <urb2h9xiba.ln2@goaway.wombat.san-francisco.ca.us>
References: <EEB5584C-116B-4D39-8765-D3ED0F982B98@gmail.com>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

On 2012-08-29, Blair Sonnen <blair.sonnen@gmail.com> wrote:
>
> Greetings.  I do not know where to inquire next for my issue and I would =
> appreciate it if anyone could suggest something to potentially help =
> regarding XFS.  I have already submitted this bug report to mdadm on =
> 5/31 (http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D675394#5), with =
> no updates as of yet. =20

There are many issues with this bug report.

==Is it repeatable?  If not, it's probably just a problem (perhaps
with the underlying hardware), not an actual software bug.
==If it's a legitimate bug, are you hoping for Debian to fix it?
Because in general they simply repackage the code and compile it, so if
the bug is truly in md or mdadm, it should be reported upstream.
==If it's not an actual bug, you're more likely to get help on the linux
md mailing list than on the Debian bug tracker.
==Have you tried a similar procedure with a different filesystem?  That
would confirm or deny whether it's an issue with XFS.

I think the best thing to do at this point is check with the Linux RAID
mailing list.  The mdadm developer is very active there.

http://vger.kernel.org/vger-lists.html#linux-raid

They can help decide whether it's a bug or local problem, and in any case
may have some ideas for either recovery or deciding that recovery is not
possible.  (I am a newbie reader on that list.)

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
