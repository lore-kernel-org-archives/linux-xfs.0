Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F8347F92
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 17:53:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5CEBD8F8033
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 15:53:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	F5RLzDp4PHrU6qld for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 15:53:46 -0700 (PDT)
Date: Thu, 31 Jul 2014 08:53:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Delaylog information enquiry
Message-ID: <20140730225342.GP20518@dastard>
References: <DUB129-W7B2973281D7E749989D43EEF80@phx.gbl>
	<20140729123815.GA13120@bfoster.bfoster>
	<20140729234151.GJ26465@dastard>
	<CAFLt3phu1kJUjFyP8-+zkRPEsiv8ue=c+W+Ym8PYS1zd3kHyzw@mail.gmail.com>
	<20140730081858.GN26465@dastard>
	<DUB129-W56704A30090C101D9B0E94EEF90@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DUB129-W56704A30090C101D9B0E94EEF90@phx.gbl>
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
To: "Frank ." <frank_1005@msn.com>
Cc: "neutrino8@gmail.com" <neutrino8@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jul 30, 2014 at 01:44:49PM +0200, Frank . wrote:
> Indeed, I turned sync and wsync flags on. As excpected, I had terribly low performance (1MB/s for write operations). So I decided to turn them back off. (I got my 100 MB/s write throughput back). 
> I just wanted to reduce as much as possible unnecessary cache between my VM's and my physcal hard drives knowing that there are up to 8 write cache levels. 
> I'm getting off the subject a bit but here is the list. This is only my conclusion. I don't know if I'm right. 
> 
> - Guest page cache.
> - Virtual disk drive write cache. (off KVM cache=directsync)
> - Host page cache. (off KVM cache=directsync)

Pretty normal. I tend to use cache=none rather than cache=directsync
because cache=none behaves exactly like a normal disk, including
write cache behaviour. So as long as you use barriers in your guest
filesystems (xfs, ext4, btrfs all do by default) then it is
no different to running the guest on a real disk with a small
volatile write cache.

i.e. when your app/database issues a fsync() in the guest, the guest
filesystem issues a flush/fua sequence and KVM then guarantees that
it only returns when all the previously written data to that file is
on stable storage. As long as all the layers below KVM provide this
same guarantee, then you don't need to turn caches off at all.

> - GlusterFS cache. (off)
> - NAS page cache. (?)
> - XFS cache (filesystem).

The gluster client side cache is being avoided due to KVM direct IO
config, the gluster server/NAS page cache/XFS cache are all the same
thing from a data perspective (i.e. 1 layer, not 3). AFAIK this is
all buffered IO, and so the only way to get data in the backing XFS
filesystem consistent on disk is for the application to issue a
fsync() on the file at the gluster client side. This comes from the
guest via KVM translating flush/fua operations or via the KVM IO
mechanism - gluster then takes care of the rest.

If KVM never issues a fsync() operation, then lower level caches
will never be flushed correctly regardless of whether you turn off
all caching or not. IOWs, fsync() is required at the XFS level to
synchronise allocation transactions with data writes, and the only
way to have that happen for the layer above xfs to issue
f[data]sync() on the relevant XFS file(s)...

Hence you need to keep in mind that turning off high level caches
does not guarantee that low level caching behaviour will behave as
you expect - even with high level caching turned off you still need
those layers to propagate the data integrity directives from the top
of the stack to the bottom so that every layer can do the right
thing regardless of whether they are caching data or not.

i.e. caching doesn't cause data loss - it's the incorrect
propagation or non-existant use of application level data
synchronisation primitives that cause data loss....

> - RAID controller write cache. (off)

There's no benefit to turning this off if it's battery backed - all
turning it off will do is cause performance to be horrible,
especially when you turn off all the other layers of caching above
the RAID controller.

> - Physical hard drive write cache. (off)

Right, those definitely need to be off so that the RAID controller
doesn't have internal consistency problems when power fails.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
