Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAU0xJ57251693 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 18:59:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B29A1C8089E
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 17:00:59 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	5rE339iNEbtD41dJ for <xfs@oss.sgi.com>;
	Mon, 29 Nov 2010 17:00:59 -0800 (PST)
Date: Tue, 30 Nov 2010 12:00:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: don't truncate prealloc from frequently
	accessed inodes
Message-ID: <20101130010050.GA3556@dastard>
References: <1290991431-20519-1-git-send-email-david@fromorbit.com>
	<1290991431-20519-3-git-send-email-david@fromorbit.com>
	<87vd3glb3u.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87vd3glb3u.fsf@basil.nowhere.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 10:42:29AM +0100, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> >
> > To avoid this problem, keep a count of the number of ->release calls
> > made on an inode. For most cases, an inode is only going to be opened
> > once for writing and then closed again during it's lifetime in
> > cache. Hence if there are multiple ->release calls, there is a good
> > chance that the inode is being accessed by the NFS server. Hence
> > count up every time ->release is called while there are delalloc
> > blocks still outstanding on the inode.
> 
> Seems like a hack. It would be cleaner and less fragile to add a
> explicit VFS hint that is passed down from the nfs server, similar
> to the existing open intents.

Agreed.

However, we've been asking for the nfsd to change it's behaviour for
various operations for quite some time (i.e. years) to help
filesystems behave better, but and we're no closer to having it
fixed now than we were 3 or 4 years ago. What the nfsd really needs
is an an open file cache so that IO looks like normal file IO rather
than every write being an "open-write-close" operation....

While we wait for nfsd to be fixed, we've still got people reporting
excessive fragmentation during concurrent sequential writes to nfs
servers running XFS, so we really need some kind of fix for the
problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
