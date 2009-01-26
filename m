Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0QIbosk243167 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 12:37:51 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C6081861CB5
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 10:37:08 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id ErEHjjFrXRUAwpIE for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2009 10:37:08 -0800 (PST)
Message-ID: <497E02CD.2020000@sandeen.net>
Date: Mon, 26 Jan 2009 12:37:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Strange fragmentation in nearly empty filesystem
References: <20090123102130.GB8012@doctronic.de>	<20090124003329.GE32390@disturbed>
	<20090126075724.GA1753@doctronic.de>
In-Reply-To: <20090126075724.GA1753@doctronic.de>
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
To: Carsten Oberscheid <oberscheid@doctronic.de>
Cc: xfs@oss.sgi.com

Carsten Oberscheid wrote:
> On Sat, Jan 24, 2009 at 11:33:29AM +1100, Dave Chinner wrote:
>> Oh, that's vmware being incredibly stupid about how they write
>> out the memory images. They only write pages that are allocated
>> and it's sparse file full of holes. Effectively this guarantees
>> file fragmentation over time as random holes are filled. For
>> example, a .vmem file on a recent VM I built:
>>
>> $ xfs_bmap -vvp foo.vmem |grep hole |wc -l
>> 675
>> $ xfs_bmap -vvp foo.vmem |grep -v hole |wc -l
>> 885
>> $
>>
>> Contains 675 holes and almost 900 real extents in a 512MB memory
>> image that has only 160MB of data blocks allocated.
> 
> Well, things look a bit different over here:
> 
> 
> [co@tangchai]~/vmware/foo ls -la *.vmem
> -rw------- 1 co co 536870912 2009-01-23 10:42 foo.vmem
> 
> [co@tangchai]~/vmware/foo xfs_bmap -vvp  voo.vmem | grep hole | wc -l
> 28
> 
> [co@tangchai]~/vmware/foo xfs_bmap -vvp  foo.vmem | grep -v hole | wc -l
> 98644
> 
> 
> The hole/extent ratio cannot really be compared with your example. The
> vmem file has been written about three or four times to reach this
> state.

It could still be being written backwards & synchronously, or some other
way which doesn't play well with the allocator in xfs....

> Now rebooting the VM to create a new vmem file:
> 
> 
> [co@tangchai]~/vmware/foo xfs_bmap -vvp  foo.vmem | grep hole | wc -l
> 3308
> 
> [co@tangchai]~/vmware/foo xfs_bmap -vvp  foo.vmem | grep -v hole | wc -l
> 3327
> 
> 
> That looks more like swiss cheese to me. And remember, it is a new file.
> 
> Now suspending the fresh VM for the first time, causing the vmem file
> to be written again:
> 
> 
> [co@tangchai]~/vmware/foo xfs_bmap -vvp  foo.vmem | grep hole | wc -l
> 38
> 
> [co@tangchai]~/vmware/foo xfs_bmap -vvp  foo.vmem | grep -v hole | wc -l
> 6678
> 
> 
> Hmmm.
> 
> Now one more thing:
> 
> 
> [co@tangchai]~/vmware/foo sudo xfs_fsr -v *vmem
> foo.vmem
> extents before:6708 after:77 DONE foo.vmem

ok, so now it's reasonably rearranged; if you had 38 holes that means
around 38 extents, 77 in the end seems about right.  How many holes are
left, then?

> I happily accept your point about vmware writing the vmem file in a
> clumsy way that guarantees fragmentation. What bothers me is that
> today these files get fragmented *much* faster than they did about a
> year ago. Back then the vmem files used to start with one extent,
> stayed between one and a handful for a week (being written 6-10 times)
> and then rose to several thousand, maybe 10k or 20k during one or two
> more weeks. Applying xfs_fsr to the file then got it back to one
> extent.

It's possible that vmware changed too, I suppose.  If it's leaving holes
now, you won't get back to one extent.

> Today: see above. Heavy fragmentation right from the start, jumping to
> 90k and more within 2 or 3 writes. No chance to defragment the file
> completely with xfs_fsr.

Probably due to holes left by the application.

How hard would it be to boot a kernel from a year ago, with your current
vmware, and see how that goes - it might be an interesting test.

> All this on the same disk with the same filesystem which is and always
> has been more than 90% empty.
> 
> So even vmware's way of writing the vmem files causes fragmentation,
> something has happened affecting the way fragmentation takes
> place. Can this really be an application problem, or is the
> application just making something obvious that happens on the
> filesystem level?

I'd try to sort out the 2 moving parts you have, vmware & kernel.  See
which one seems to have affected this behavior the most; downgrade one
of the 2 pieces, and see how it behaves.

-Eric

> Best regards
> 
> 
> Carsten Oberscheid
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
