Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E3BCB7F37
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 00:49:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E0D1AC009
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 22:49:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IfomCUDZINFAjvhq for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 22:49:35 -0800 (PST)
Date: Thu, 14 Nov 2013 17:49:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
Message-ID: <20131114064932.GO6188@dastard>
References: <5283C41D.7070503@redhat.com>
 <52841AB9.9050906@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52841AB9.9050906@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 13, 2013 at 06:35:05PM -0600, Eric Sandeen wrote:
> On 11/13/13, 12:25 PM, Eric Sandeen wrote:
> > Pure RFC; this might be crazy.  Here's the problem I'm trying to solve:
> > 
> > Today, mkfs.xfs will select a 4k sector size for a 4k physical / 512 logical
> > drive.  (that change was done by me).  The thought was that it'd be an
> > efficiency gain to not make the drive do the (possible) RMW cycles on
> > 512-byte log IO, primarily.
> > 
> > However, now this restricts all DIO to 4k alignment, not the otherwise-
> > possible 512.
> 
> So, backing up... ;)
> 
> XFS isn't doing anything wrong here.  It can make sector sizes as it pleases,
> and apps had darned well better accommodate its whims if they do direct IO.
> 
> But some apps don't.  And users are sad and confused, and grow to dislike
> XFS, because it all worked just fine on that other filesystem, so screw you
> XFS, and your flux capacitor drives with your power-fail interrupts!

Funny how it's always XFS is at fault, when the same problem with 4k
sectors will occur on ext4, for example....

> So my overarching goal here is to have XFS do its internal IO as efficiently
> as possible on an "advanced format" drive, i.e. in 4k chunks, but not to
> break apps that don't bother to check whether ye olde 512 DIO will work,
> if the underlying storage can actually handle it.

Yup, it's called buffered IO.

> We could even ensure that XFS_IOC_DIOINFO offers up "4k" as the answer
> to miniosz, so that apps which bother to ask get the optimal answer.

Funnily enough, it does:

		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;

$ sudo xfs_info .
meta-data=/dev/md0               isize=256    agcount=32, agsize=21503744 blks
         =                       sectsz=4096  attr=2, projid32bit=0
         =                       crc=0
data     =                       bsize=4096   blocks=688119680, imaxpct=5
         =                       sunit=32     swidth=320 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=335995, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo xfs_io -c stat . |grep dioattr.miniosz
dioattr.miniosz = 4096
$

> But if we know, deep in our hearts, that a 512 byte DIO is ok, let's
> let it pass.

but, well, we don't know it's ok, because we don't know why 4k
sector size was chosen at mkfs time, even though the underlying
device might say it has a 512 byte logical sector size....

> Hacking up bt_sshift and friends might be the wrong way to do it, although
> I'm not so sure - that's really all it's used for (today).
> 
> Christoph's suggestion to leave sector size at 512 but set a log stripe seems
> interesting, too.

Which leaves all AG header writes as single 512 byte sector writes
which will trigger RMW in the hardware. And while those IOs are in
progress, we can't use the AG for allocation or freeing, so
increasing the IO latency of such IO is significant....

> Or, we could stop setting 4k sectors for AF drives.

And just take the RMW penalty?

> Or we could just carry on, and keep telling users that it's their fault,
> their app's fault, etc...

... and getting the problems fixed so they go away forever.

> (I'm sympathetic to pushing the envelope and dragging apps into the 21st
> century, but it's s double edged sword).

Yes, it is, but if we don't take a stand and say "we, as an
ecosystem, need to support 4k sectors *everywhere*", then we are
going to have such problems *forever*. This isn't purely an XFS
problem - this is something that the entire storage stack needs to
support, from the hardware at the very bottom to the applications at
the very top.

XFS is stuck in the middle, where we cop it from both
the hardware side ("why don't you support our hardware efficiently
yet?") and from the application side when we do ("4k sectors break
our assumptions!"). It's a no win situation for us no matter what we
do, and history has shown that when we don't take a strong
leadership position the problems don't get solved.

So, let's take the initiative and make sure that everyone knows how
to deal with these problems and get them fixed in the right places.
I don't want to be spending the next 10 years complaining about a
lack of 4k sector support in qemu. It's too much like the inode64
saga over all over again.

Let's face it, it wouldn't be right if XFS wasn't fighting some
battle to drag Linux kicking and screaming into the present...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
