Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA9D77CA0
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 16:19:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC601304043
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 14:19:39 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TNE4DiFbF6vAQXTw for <xfs@oss.sgi.com>;
	Thu, 08 Sep 2016 14:19:34 -0700 (PDT)
Date: Fri, 9 Sep 2016 07:19:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
	detected
Message-ID: <20160908211931.GX30056@dastard>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
	<1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
	<20160903003919.GI30056@dastard>
	<1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
	<CA+55aFyfDNR9vkQ3sZMhLcoizE5VCLJDVukyPk=gbhDz9aNLgA@mail.gmail.com>
	<268523885.1013251.1473367174650.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <268523885.1013251.1473367174650.JavaMail.zimbra@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 04:39:34PM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Linus Torvalds" <torvalds@linux-foundation.org>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: "Dave Chinner" <david@fromorbit.com>, "Al Viro" <viro@zeniv.linux.org.uk>, "linux-xfs"
> > <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com
> > Sent: Thursday, September 8, 2016 2:01:23 PM
> > Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
> > 
> > On Thu, Sep 8, 2016 at 8:29 AM, CAI Qian <caiqian@redhat.com> wrote:
> > > Right. FYI, revert the commit below fixes the regression,
> > >
> > > 8d02076 : ->splice_write() via ->write_iter()
> > 
> > I guess you didn't actually revert that, because so much else has
> > changed. So you just tested the pre- and post- state of that commit?
> Right, I just reverted that commit while that one is as a HEAD. It is
> not going to be a straight-forward revert. There have had a few commits
> on the top already, so there will be some additional work to bake a proper
> revert to the current origin HEAD.
> 
> Though, Everything else looks straigtforward (PAGE_CACHE_* conversion,
> inode_lock* conversion, file_remove_privs() converstion). It seems only
> tricky thing is that generic_write_sync() starts to use struct kiocb *
> instead of struct file *, so generic_file_splice_write() and probably
> xfs_file_splice_write() need to change to use kiocb as well.

Don't bother. You'll just hit a different lockdep issue - a locking
order problem on the write side. I tried to get that fixed years
ago:

https://lkml.org/lkml/2011/7/18/4
http://oss.sgi.com/archives/xfs/2011-08/msg00122.html
http://oss.sgi.com/archives/xfs/2012-11/msg00671.html

That specific problem was fixed by the above write_iter
infrastructure fixes, but introduced the read side problem.  i.e.
splice has /always/ had locking order issues that XFS exposed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
