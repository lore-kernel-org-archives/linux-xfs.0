Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E5667CA0
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 15:39:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 20009AC002
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 13:39:39 -0700 (PDT)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id wuo6ZcOHxX6Hen1m (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Sep 2016 13:39:38 -0700 (PDT)
Date: Thu, 8 Sep 2016 16:39:34 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <268523885.1013251.1473367174650.JavaMail.zimbra@redhat.com>
In-Reply-To: <CA+55aFyfDNR9vkQ3sZMhLcoizE5VCLJDVukyPk=gbhDz9aNLgA@mail.gmail.com>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
	<1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
	<20160903003919.GI30056@dastard>
	<1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
	<CA+55aFyfDNR9vkQ3sZMhLcoizE5VCLJDVukyPk=gbhDz9aNLgA@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
	detected
MIME-Version: 1.0
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com



----- Original Message -----
> From: "Linus Torvalds" <torvalds@linux-foundation.org>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Dave Chinner" <david@fromorbit.com>, "Al Viro" <viro@zeniv.linux.org.uk>, "linux-xfs"
> <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com
> Sent: Thursday, September 8, 2016 2:01:23 PM
> Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
> 
> On Thu, Sep 8, 2016 at 8:29 AM, CAI Qian <caiqian@redhat.com> wrote:
> > Right. FYI, revert the commit below fixes the regression,
> >
> > 8d02076 : ->splice_write() via ->write_iter()
> 
> I guess you didn't actually revert that, because so much else has
> changed. So you just tested the pre- and post- state of that commit?
Right, I just reverted that commit while that one is as a HEAD. It is
not going to be a straight-forward revert. There have had a few commits
on the top already, so there will be some additional work to bake a proper
revert to the current origin HEAD.

Though, Everything else looks straigtforward (PAGE_CACHE_* conversion,
inode_lock* conversion, file_remove_privs() converstion). It seems only
tricky thing is that generic_write_sync() starts to use struct kiocb *
instead of struct file *, so generic_file_splice_write() and probably
xfs_file_splice_write() need to change to use kiocb as well.
   CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
