Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88AwITw030992 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 05:58:19 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3683817BB084
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 03:59:01 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	H6ja9hRS42Is6qdn for <xfs@oss.sgi.com>;
	Wed, 08 Sep 2010 03:59:01 -0700 (PDT)
Date: Wed, 8 Sep 2010 20:58:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs mount/create options (was: XFS status update for August 2010)
Message-ID: <20100908105858.GZ705@dastard>
References: <20100902145959.GA27887@infradead.org>
	<20100905130809.GI705@dastard> <201009060749.01405@zmi.at>
	<201009080738.58483@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009080738.58483@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Sep 08, 2010 at 07:38:54AM +0200, Michael Monnerie wrote:
> I just found that my questions from Monday were not solved, but this is 
> interesting, so I want to warm it up again.
> 
> On Montag, 6. September 2010 Michael Monnerie wrote:
>  I looked into man mkfs now, which brings up these questions:
>  
>  On Sonntag, 5. September 2010 Dave Chinner wrote:
>  >         - relatime,logbufs=8,attr=2,barrier are all defaults.
>  
>  Why isn't logbsize=256k default, when it's suggested most of the time
>  anyway?

It's suggested when people are asking about performance tuning. When
the performance is acceptible with the default value, then you don't
hear about it, do you?

>  On machines with 32MiB or more 32k is the default, but most
>  machines these days have multi-gigabytes of RAM, so at least for
>  RAM>1GiB that could be made default.

That is definitely not true. XFS is widely used in the embedded NAS
space, where memory is very limited and might be configured with
many filesystems.  32k is the default because those sorts of machines
can't afford to burn 2MB RAM per filesystem just in log buffers.

Also, you can go and search the archives or git history as to why we
don't tune the logbsize based on physical memory size anymore, too.


>  >         - largeio only affects stat(2) output if you have
>  >           sunit/swidth set - unlikely on a laptop drive, and has
>  >           no effect on unlink performance.
>  >         - swalloc only affects allocation if sunit/swidth are set
>  >           and has no effect on unlink performance.
>  
>  Hm, it seems I don't understand that. I tried now on different
>   servers, using
>  stat -f /disks/db --format '%s %S'
>  4096 4096

You're getting the wrong information there. largeio affects the
output of the optimal IO size reported by stat(2). 'stat -f" does
a statfs(2) call. Try 'stat /disk/db/<file> --format %o'....

>  And while I am at it: Why does "mount" not provide the su=/sw=
>   options that we can use to create a filesystem? Would make life
>   easier, as it's much easier to read su=64k,sw=7 than
>   sunit=128,swidth=896.

You should never, ever need to use the mount options.

>  When I defined su/sw on mkfs, is it enough, or would I always have to
>  specify sunit/swidth with every mount too?

Yes, no. mkfs.xfs stores sunit/swidth on disk in the superblock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
