Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEC7C7F37
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 09:18:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B31E4304064
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 07:18:52 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 57kumJpkHzSjadri for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 07:18:51 -0800 (PST)
Message-ID: <5284E9D9.8090706@sandeen.net>
Date: Thu, 14 Nov 2013 09:18:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com> <52841AB9.9050906@sandeen.net>
	<20131114064932.GO6188@dastard>
In-Reply-To: <20131114064932.GO6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/14/13, 12:49 AM, Dave Chinner wrote:
> On Wed, Nov 13, 2013 at 06:35:05PM -0600, Eric Sandeen wrote:
>> On 11/13/13, 12:25 PM, Eric Sandeen wrote:
>>> Pure RFC; this might be crazy.  Here's the problem I'm trying to solve:
>>>
>>> Today, mkfs.xfs will select a 4k sector size for a 4k physical / 512 logical
>>> drive.  (that change was done by me).  The thought was that it'd be an
>>> efficiency gain to not make the drive do the (possible) RMW cycles on
>>> 512-byte log IO, primarily.
>>>
>>> However, now this restricts all DIO to 4k alignment, not the otherwise-
>>> possible 512.
>>
>> So, backing up... ;)
>>
>> XFS isn't doing anything wrong here.  It can make sector sizes as it pleases,
>> and apps had darned well better accommodate its whims if they do direct IO.
>>
>> But some apps don't.  And users are sad and confused, and grow to dislike
>> XFS, because it all worked just fine on that other filesystem, so screw you
>> XFS, and your flux capacitor drives with your power-fail interrupts!
> 
> Funny how it's always XFS is at fault, when the same problem with 4k
> sectors will occur on ext4, for example....

Yep on a non-existent hard 4k disk, ext4 would have the same problem.

Meanwhile in the world of actual hardware, ext4 is fine.  (there's no
similar sector-size switch for ext4).

Again; I'm NOT saying xfs is doing anything wrong, or is at fault.

We can be right all the way to the grave, if apps never get fixed,
and users have a choice of fs.

...

>> We could even ensure that XFS_IOC_DIOINFO offers up "4k" as the answer
>> to miniosz, so that apps which bother to ask get the optimal answer.
> 
> Funnily enough, it does:
> 
> 		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;

...

Of course it does today; I was talking about whether we could report this
but still allow 512 under the covers.
 
>> Or, we could stop setting 4k sectors for AF drives.
> 
> And just take the RMW penalty?

that, and the bonus of existing applications continuing to function.
 
>> Or we could just carry on, and keep telling users that it's their fault,
>> their app's fault, etc...
> 
> ... and getting the problems fixed so they go away forever.

... or not.  *cough*64 bit inodes*cough*

>> (I'm sympathetic to pushing the envelope and dragging apps into the 21st
>> century, but it's s double edged sword).
> 
> Yes, it is, but if we don't take a stand and say "we, as an
> ecosystem, need to support 4k sectors *everywhere*", then we are
> going to have such problems *forever*. This isn't purely an XFS
> problem - this is something that the entire storage stack needs to
> support, from the hardware at the very bottom to the applications at
> the very top.
> 
> XFS is stuck in the middle, where we cop it from both
> the hardware side ("why don't you support our hardware efficiently
> yet?") and from the application side when we do ("4k sectors break
> our assumptions!"). It's a no win situation for us no matter what we
> do, and history has shown that when we don't take a strong
> leadership position the problems don't get solved.
> 
> So, let's take the initiative and make sure that everyone knows how
> to deal with these problems and get them fixed in the right places.
> I don't want to be spending the next 10 years complaining about a
> lack of 4k sector support in qemu. It's too much like the inode64
> saga over all over again.

which, TBH, has still never been fully addressed.

> Let's face it, it wouldn't be right if XFS wasn't fighting some
> battle to drag Linux kicking and screaming into the present...

Well.  With my distro hat on I might have to be pragmatic, and keep
things working that are required to work.

Upstream, sure, we can keep beating users with a stick until they
force their app writers to make things work for them again.  ;)

(Again, though, as middle ground - if there were a way for XFS to do
all internal IO efficiently as 4k-aligned, but allow applications
to do 512 emulation, that would be, IMHO, a great thing.  I'm not
yet sure what it would take.)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
