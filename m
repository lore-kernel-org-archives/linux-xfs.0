Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ILhuHD160970 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 15:43:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B8CD101E34C
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 13:46:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	5jfGxZ9K6nBBE0sr for <xfs@oss.sgi.com>;
	Tue, 18 Jan 2011 13:46:13 -0800 (PST)
Date: Wed, 19 Jan 2011 08:46:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/12] xfs: kill xfs_fs_mount_cmn_err() macro
Message-ID: <20110118214610.GW28803@dastard>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294792553-8378-8-git-send-email-david@fromorbit.com>
	<20110118130023.GA23988@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118130023.GA23988@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 18, 2011 at 08:00:23AM -0500, Christoph Hellwig wrote:
> On Wed, Jan 12, 2011 at 11:35:48AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The xfs_fs_mount_cmn_err() hide a simple check as to whether the
> > mount path should output an error or not. Remove the macro and open
> > code the check.
> 
> I would be nice to just move the quite flag into the normal mount flags
> and have a xfs_mount_warn that checks it based off the mp.

Given it is a flag that is only relevant for the mount context, is
there really any need to use a flag that persists for the entire
life of the filesystem for it? I don't think the code is that hard
to follow right now. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
