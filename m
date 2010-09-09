Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o896iiqY088736 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 01:44:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F18F2DA4E62
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 23:56:44 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	nox7CxXahCHSuujR for <xfs@oss.sgi.com>;
	Wed, 08 Sep 2010 23:56:44 -0700 (PDT)
Date: Thu, 9 Sep 2010 16:45:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs on armv5 still with erroneous log in kernel 2.6.35.4
Message-ID: <20100909064524.GA7032@dastard>
References: <4C835A34.9080008@googlemail.com> <20100906005230.GX7362@dastard>
	<4C845EDE.3010806@sandeen.net> <4C8534D0.3050003@googlemail.com>
	<20100907060331.GK705@dastard> <4C86B4E3.5090202@googlemail.com>
	<20100908074357.GS705@dastard> <4C87D793.8000103@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C87D793.8000103@googlemail.com>
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
To: Marcus Osdoba <marcus.osdoba@googlemail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Sep 08, 2010 at 08:36:03PM +0200, Marcus Osdoba wrote:
>  Am 08.09.2010 09:43, schrieb Dave Chinner:
> >mount -t xfs /dev/sda1 /data
> >cp /bin/sh /data
> >sync
> >umount /data
> >xfs_printlog /dev/sda1
> #no ERROR entry visible

Again, can you pleae paste the entire logprint output here?  I'm
asking for _exactly_ what is in your terminal as a result of the
commands you ran. That is, if everything is working correctly, I
would expect you to be pasting in something like this:

# mount /dev/vdb /mnt/scratch
# cp /bin/sh /mnt/scratch
# sync
# umount /mnt/scratch
# xfs_logprint -t /dev/vdb
xfs_logprint:
    data device: 0xfd10
    log device: 0xfd10 daddr: 10485792 length: 20480

    log tail: 6924 head: 6924 state: <CLEAN>

#

If it is different to this, then those differences might
tell me is going wrong. but without the exact commands and output,
I cannot help you....

> # The following command chain trys to reproduce the error
> >mount -t xfs /dev/sda1 /data
> >cp /bin/* /data
> >sync
> Device or resource busy.

This should not be occurring.  What is generating this error? is
there anything in your logs/dmesg, etc that indicates what might be
the cause?  This is the error that we need to understand first...

> My expectations:
> - sync should never be mandatory before  unmounting to keep the FS
> clean (any FS)

It's not. I asked you to run it first to separate writeback from the
unmount process to determine if it was writeback that was having
problems. Clearly, if sync is triggering an error, then the problem
is realted to writeback, and not unmount.

FYI: Without a sync, you should still see a clean log:

# mount /dev/vdb /mnt/scratch
# cp /bin/* /mnt/scratch
# umount /mnt/scratch
# xfs_logprint -t /dev/vdb
xfs_logprint:
    data device: 0xfd10
    log device: 0xfd10 daddr: 10485792 length: 20480

    log tail: 8703 head: 8703 state: <CLEAN>

#

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
