Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n54M4WI8003182 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 17:04:33 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B6DC2D2B7E
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 15:04:49 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id xXKk1aLowMMQCDh4 for
	<xfs@oss.sgi.com>; Thu, 04 Jun 2009 15:04:49 -0700 (PDT)
Message-ID: <4A2844FF.7010101@sandeen.net>
Date: Thu, 04 Jun 2009 17:04:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Repairing large partition
References: <dc64e7230906041213s2bb9d67fj2df0b3db4ca37704@mail.gmail.com>	
	<4A283A22.8050003@sandeen.net>
	<dc64e7230906041437k1c1d0e42l80766fa290f2290f@mail.gmail.com>
In-Reply-To: <dc64e7230906041437k1c1d0e42l80766fa290f2290f@mail.gmail.com>
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
To: maillists0@gmail.com, xfs-oss <xfs@oss.sgi.com>

maillists0@gmail.com wrote:
> 
> 
> On Thu, Jun 4, 2009 at 5:18 PM, Eric Sandeen <sandeen@sandeen.net> 
> wrote:
> 
> maillists0@gmail.com <mailto:maillists0@gmail.com> wrote:
>> Pardon if this is the wrong list for this question.
>> 
>> I had a 50T xfs partition, spread across 3 storage devices which 
>> were lvm'd. After a power failure, 2 disks on one device failed. It
>> was raid5, so that data is unrecoverable.
>> 
>> I replaced the failed disks and rebuilt that array. I can mount the
>> partition and see data on the first 2 devices. I ran xfs_repair
>> -n' to see what might be done a couple of days ago and it still
>> hasn't finished.  Does anyone know how I could recreate the
>> partition to include the third device without losing data from the
>> first two devices? Any help will be greatly appreciated, including
>> a pointer to the appropriate docs. Thanks.
> 
> so was it a concat of 3 raid5s?
>
> 
> Exactly.

Ok, I'm not sure there are any appropriate docs for this case ... the
trick will be that the files you can see may well have had portions of
their data on the bad piece, and other portions on the good pieces, so
even if you get the filesystem framework all back in place it might be a
trick to see which remaining files are now corrupted.  Of course inodes
& directories that were on the bad piece are gone, so those files are
pretty well lost.

xfs_repair -n is a good idea for a start, I think; I'd be sure you have
the latest version, and using -P has been reported to actually speed
things up for some people with very large filesystems.

xfs_repair is probably the only documented/supported thing to try,
though normally for this kind of extensive damage I'd suggest doing it
on a filesystem image to see how it ends up... not so feasible with your
filesystem, I suppose.

One other option -might- be to do xfs_info on the mountpoint, get all
the fs geometry, and re-mkfs (preferably with the same mkfs.xfs version)
a sparse filesystem image on a file with the exact same geometry.  Then
dd bits from that freshly mkfs'd filesystem image, at the right offsets,
onto the recreated bad chunk of the concat.  Again, I'd feel better if
you could do a dry run of this somehow ...

You could maybe practice this by doing an xfs_metadump -o of the block
device, xfs_mdrestore the resulting metadata image back into a sparse
filesystem metadata image, do the above mkfs & dd trick into that image,
and xfs_repair the result.  (you'd probably need some way to teach dd to
honor the sparseness, see for example the make-sparse.c tool in
http://bugzilla.kernel.org/show_bug.cgi?id=11525#c4)

Just some random thoughts ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
