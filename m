Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n992T3eN041269 for <xfs@oss.sgi.com>; Thu, 8 Oct 2009 21:29:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8DC512278DF
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2009 19:30:28 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	qQRkH6VJ4AkS5pZ8 for <xfs@oss.sgi.com>;
	Thu, 08 Oct 2009 19:30:28 -0700 (PDT)
Date: Fri, 9 Oct 2009 13:30:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: add discard support
Message-ID: <20091009023022.GL9464@discord.disaster>
References: <20091006184758.GA4780@infradead.org>
	<20091007044215.GK9464@discord.disaster>
	<87iqerymu0.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87iqerymu0.fsf@basil.nowhere.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Oct 07, 2009 at 10:24:07PM +0200, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> > On Tue, Oct 06, 2009 at 02:47:58PM -0400, Christoph Hellwig wrote:
> >> Call the BLKDISCARD ioctl to mark the whole disk as unused before creating
> >> a new filesystem.  This will allow SSDs, Arrays with thin provisioning support
> >> and virtual machines to make smarter allocation decisions.
> >
> > Good idea, but perhaps the discard should be optional rather than
> > unconditional.  My immediate thought was the SOP for setting up
> > encrypted devices - fill the empty disk with random data before
> > setting up the encrypted device. If you then send it a discard....
>
> This actually doesn't really work for SSDs, because SSDs typically
> have more internal capacity than they advertise and when you fill
> it up then it will just allocate new blocks and leave some of the
> blocks with the existing data around.

Agreed, but initialisation with random data before encryption is not
to delete existing information on the drive - it is to prevent
simple side-channel attacks that can significantly reduce the
strength of the encryption (e.g. an observer can tell the difference
between written, encrypted regions and unused space).  Using
discards during mkfs and during filesystem operation opens up this
avenue of attack, hence my reasoning for making discards
optional....

> So I think Christoph's case of making it default is fine.

So do I, but for different reasons ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
