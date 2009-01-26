Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q875hC206225 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 02:07:06 -0600
Received: from pastinake.doctronic.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D5AD185EBDC
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 00:06:22 -0800 (PST)
Received: from pastinake.doctronic.de (pastinake.doctronic.de [217.6.226.210])
	by cuda.sgi.com with ESMTP id JzhgELCnlmFFkf4x for
	<xfs@oss.sgi.com>; Mon, 26 Jan 2009 00:06:22 -0800 (PST)
Received: from ZWERG.DOCTRONIC.LOCAL (zwerg.doctronic.de [192.168.4.131])
	by pastinake.doctronic.de (8.13.1/8.13.1) with ESMTP id n0Q7vOh4003276
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 08:57:24 +0100
Received: from co by ZWERG.DOCTRONIC.LOCAL with local (Exim 4.63)
	(envelope-from <oberscheid@doctronic.de>) id 1LRMLU-0000a0-7m
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 08:57:24 +0100
Date: Mon, 26 Jan 2009 08:57:24 +0100
From: Carsten Oberscheid <oberscheid@doctronic.de>
Subject: Re: Strange fragmentation in nearly empty filesystem
Message-ID: <20090126075724.GA1753@doctronic.de>
References: <20090123102130.GB8012@doctronic.de>
	<20090124003329.GE32390@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090124003329.GE32390@disturbed>
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
To: xfs@oss.sgi.com

On Sat, Jan 24, 2009 at 11:33:29AM +1100, Dave Chinner wrote:
> Oh, that's vmware being incredibly stupid about how they write
> out the memory images. They only write pages that are allocated
> and it's sparse file full of holes. Effectively this guarantees
> file fragmentation over time as random holes are filled. For
> example, a .vmem file on a recent VM I built:
> 
> $ xfs_bmap -vvp foo.vmem |grep hole |wc -l
> 675
> $ xfs_bmap -vvp foo.vmem |grep -v hole |wc -l
> 885
> $
> 
> Contains 675 holes and almost 900 real extents in a 512MB memory
> image that has only 160MB of data blocks allocated.

Well, things look a bit different over here:


[co@tangchai]~/vmware/foo ls -la *.vmem
-rw------- 1 co co 536870912 2009-01-23 10:42 foo.vmem

[co@tangchai]~/vmware/foo xfs_bmap -vvp  voo.vmem | grep hole | wc -l
28

[co@tangchai]~/vmware/foo xfs_bmap -vvp  foo.vmem | grep -v hole | wc -l
98644


The hole/extent ratio cannot really be compared with your example. The
vmem file has been written about three or four times to reach this
state.

Now rebooting the VM to create a new vmem file:


[co@tangchai]~/vmware/foo xfs_bmap -vvp  foo.vmem | grep hole | wc -l
3308

[co@tangchai]~/vmware/foo xfs_bmap -vvp  foo.vmem | grep -v hole | wc -l
3327


That looks more like swiss cheese to me. And remember, it is a new file.

Now suspending the fresh VM for the first time, causing the vmem file
to be written again:


[co@tangchai]~/vmware/foo xfs_bmap -vvp  foo.vmem | grep hole | wc -l
38

[co@tangchai]~/vmware/foo xfs_bmap -vvp  foo.vmem | grep -v hole | wc -l
6678


Hmmm.

Now one more thing:


[co@tangchai]~/vmware/foo sudo xfs_fsr -v *vmem
foo.vmem
extents before:6708 after:77 DONE foo.vmem


I happily accept your point about vmware writing the vmem file in a
clumsy way that guarantees fragmentation. What bothers me is that
today these files get fragmented *much* faster than they did about a
year ago. Back then the vmem files used to start with one extent,
stayed between one and a handful for a week (being written 6-10 times)
and then rose to several thousand, maybe 10k or 20k during one or two
more weeks. Applying xfs_fsr to the file then got it back to one
extent.

Today: see above. Heavy fragmentation right from the start, jumping to
90k and more within 2 or 3 writes. No chance to defragment the file
completely with xfs_fsr.

All this on the same disk with the same filesystem which is and always
has been more than 90% empty.

So even vmware's way of writing the vmem files causes fragmentation,
something has happened affecting the way fragmentation takes
place. Can this really be an application problem, or is the
application just making something obvious that happens on the
filesystem level?

Best regards


Carsten Oberscheid

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
