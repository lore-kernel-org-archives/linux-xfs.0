Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C12197F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:25:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F1FA304043
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 08:25:06 -0700 (PDT)
Received: from ppsw-33.csi.cam.ac.uk (ppsw-33.csi.cam.ac.uk [131.111.8.133])
	by cuda.sgi.com with ESMTP id TFoMHPNSQzi8ONbq for
	<xfs@oss.sgi.com>; Mon, 29 Jul 2013 08:25:03 -0700 (PDT)
Received: from nat.mrc-lmb.cam.ac.uk ([131.111.85.79]:31023
	helo=mail.lmb.internal)
	by ppsw-33.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.137]:25)
	with esmtp id 1V3pJn-0004FH-hI (Exim 4.80_167-5a66dd3) for
	xfs@oss.sgi.com (return-path <dhoworth@mrc-lmb.cam.ac.uk>);
	Mon, 29 Jul 2013 16:25:03 +0100
Received: from cpepc210-3.lmb.internal ([10.21.64.91])
	by mail.lmb.internal with esmtp (Exim 4.63)
	(envelope-from <dhoworth@mrc-lmb.cam.ac.uk>) id 1V3pJn-0003cx-5V
	for xfs@oss.sgi.com; Mon, 29 Jul 2013 16:25:03 +0100
Message-ID: <51F68952.8020603@mrc-lmb.cam.ac.uk>
Date: Mon, 29 Jul 2013 16:25:06 +0100
From: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
MIME-Version: 1.0
Subject: Re: A short digression on FOSS (Re: understanding
	speculative	preallocation)
References: <22688573.2526.1375108427119.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <22688573.2526.1375108427119.JavaMail.root@benjamin.baylink.com>
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
To: xfs@oss.sgi.com

Jay Ashworth wrote:
> I really do apologize for sounding so combative about this stuff; I'm not really
> trying to be, but "things have version numbers" has been best practice for 3 
> decades for a reason, and I think it's a pretty good one: avoiding fights like
> this.

I think you're missing a fundamental point. If you go back and look at
what you've quoted, you've been asked e.g. for which kernel you're
running, rather than what kernel version, because a kernel doesn't
really have a version either. As you yourself have pointed out there are
package versions. There are multiple trees and within each tree somebody
may have chosen to apply or not particular patches.

So the easiest way for a non-expert to describe the kernel they're using
is most likely to name a distro and release, plus whatever updates have
been applied. A distro-expert can translate that into the general age of
the code and the commit numbers of the exact patches that have been
applied if necessary. And that's why the FAQ

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

asks people to report the uname -a amongst a lot of other stuff.

So arguing about semantics of whether or not there are or should be
version numbers for various things is a bit pointless. And as well as
being combative, it's also insulting to the good folks that are trying
to help you, IMHO. They've set up a reporting system to give them the
best chance of accurately diagnosing problems with minimal wasted time.
So most people who want to solve problems are happy to go along with
that procedure, instead of going out of their way to challenge it.

If you really care about this issue and believe that it is significant,
then I think you need to go away and do a bunch of quiet research until
you understand it deeply, and then come back with specific, detailed
proposals to improve it. Otherwise, it's better to let it rest, IMHO.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
