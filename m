Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9L1sYti160835 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 20:54:35 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E521319567B1
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 18:55:46 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	Z7L44sOHQ59e00Qq for <xfs@oss.sgi.com>;
	Wed, 20 Oct 2010 18:55:46 -0700 (PDT)
Date: Thu, 21 Oct 2010 12:55:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: avoid mbox file fragmentation
Message-ID: <20101021015543.GF12506@dastard>
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
	<4CBE5BF7.1090001@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CBE5BF7.1090001@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 19, 2010 at 10:03:19PM -0500, Stan Hoeppner wrote:
> Dave Chinner put forth on 10/19/2010 6:42 PM:
> 
> > I've explained how allocsize works, and that speculative allocation
> > gets truncated away whenteh file is closed. Hence is the application
> > is doing:
> > 
> > 	open()
> > 	seek(EOF)
> > 	write()
> > 	close()
> 
> I don't know if it changes anything in the sequence above, but Dovecot
> uses mmap i/o.  As I've said, I'm not a dev.  Just thought this
> could/might be relevant.  Would using mmap be compatible with physical
> preallocation?

mmap() can't write beyond EOF or extend the file. hence it would
have to be:

	open()
	mmap()
	ftrucate(new_size)
	<write via mmap>

In this method, there is no speculative preallocation because the
there is never a delayed allocation that extends the file size.  it
simply doesn't matter where the close() occurs. Hence if you use
mmap() writes like this, the only way you can avoid fragmentation is
to use physical preallocation beyond EOF before you start any
writes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
