Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3J3QsWe016021 for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 22:26:55 -0500
Received: from mail-px0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA1ED14E6A20
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 20:30:20 -0700 (PDT)
Received: from mail-px0-f174.google.com (mail-px0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	vVNdKOe8PFPQ88Xy for <xfs@oss.sgi.com>;
	Mon, 18 Apr 2011 20:30:20 -0700 (PDT)
Received: by pxi15 with SMTP id 15so3977606pxi.5
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 20:30:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110419025949.GA3030@thunk.org>
References: <20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419025949.GA3030@thunk.org>
Date: Tue, 19 Apr 2011 11:30:19 +0800
Message-ID: <BANLkTinM5yWeT7X7pQ3AYYYvK9gTSLO8XA@mail.gmail.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Tue, Apr 19, 2011 at 10:59 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Apr 19, 2011 at 09:58:15AM +0800, Yongqiang Yang wrote:
>> On Mon, Apr 18, 2011 at 10:45 AM, Andreas Dilger <adilger@dilger.ca> wro=
te:
>> > Always passing FIEMAP_FLAG_SYNC is fine in this case. It should
>> > only do anything if there is unwritten data, which is the only
>> > case we are concerned with at this point. =A0In any case, this is a
>> > simple solution for coreutils until such a time that a more
>> > complex solution is added in the kernel (if ever).
>
> I would recommend that coreutils check i_blocks and i_size and only
> try using fiemap (with FIEMAP_FLAG_SYNC) if the file appears to be
> sparse. =A0That's because FIEMAP_FLAG_SYNC will do the effectively
> equivalent of an fsync() system call. =A0Otherwise, in the case of a
> freshly untar'ed directory hierarchy which is then copied using "cp
> -r", cp would end up calling fsync() for each file in the directory,
> with the disastrous performance result that one might expect.
>
> If cp only tries the fiemap optimization on files that appear to be
> sparse, it should avoid this problem.
>
>> > Agreed, SEEK_HOLE/SEEK_DATA is the right way to solve this problem.
>> >
>> > I don't see how this will change the problem in any meaningful way. Th=
ere
>> > will still need to be code that is traversing the on-disk mapping, and=
 also
>> > keeping it coherent with unwritten data in the page cache.
>
> The advantage of SEEK_HOLE/SEEK_DATA is that we don't need to force an
> fsync() of the data.
>
>> It seems that we are being messed up by page cache and disk.
>> Unwritten flag returned from FIEMAP indicates blocks on disk are not
>> written, but it does not say if there is data in page cache. =A0So
>> FIEMAP itself just tells user the map on disk. =A0However there is an
>> exception for delayed allocation, =A0FIEMAP tells users the data is in
>> page cache.
>>
>> Maybe FIEMAP should return all known messages for unwritten extent, if
>> unwritten data exists in page cache, FIEMAP should let users know that
>> data is in page cache and space on disk has been preallocated, but
>> data has not been flushed into disk. =A0Actually, delayed allocation has
>> done like this. Then user-space applications can determine how to do.
>> Taking cp as an example, it will copy from page cache rather ignore
>> it.
>>
>> We need a definite definition for FIEMAP, in other words, it tells
>> users map on disk or both disk and page cache.
>>
>> If the former one is taken, then FIEMAP should not consider delayed
>> allocation. =A0otherwise, FIEMAP should return all known messages for
>> unwritten case like delayed allocation.
>
> The fact that the FIEMAP interface deifnition includes an delayed
> allocation bit could be a strong indication that unlike the XFS's bmap
> interface, that this interface is supposed to return information
> taking into account both on-disk and page cache information. =A0If this
> is the case, then even though there might be a single on-disk
> (uninitialized) extent, if there are pages in the page cache that have
> not yet been written out yet, but which are described by that on-disk
> extent, then instead of returning a single struct fiemap_extent for
> that on-disk extent, the fiemap ioctl would need to return multiple
> struct fiemap_extents, where some would have the FIEMAP_UNWRITTEN bit,
> and others would not (since data has been written to the page cache,
> even if it hasn't been flushed to disk yet).
Maybe we can add a SPLIT flag like MERGE for ext3, which is set if
there are pages in page cache that have not been written out, but
which are described by unwritten extent on disk, and which does not
cover the whole extent.

Thus, an extent returned by FIEMAP may have UNWRITTEN, NOBYPASS and SPLIT f=
lags.

I noticed that there is a NOBYPASS flag in initial FIEMAP, which
indicates data has not been written out to disk.  But it does not
exist in current implementation any more.

>
> But yes, if we're going to make the case that the FIEMAP interface is
> only intended to reflect the on-disk information, then the DELALLOC
> bit shouldn't be returned at all, and we should deprecate it.
> Anything else leads us to a inconsistent interface.
>
>> > Since FIEMAP already exists for most Linux filesystems, it probably ma=
kes
>> > sense to implement SEEK_{HOLE,DATA} by calling FIEMAP to get the disk
>> > mapping in the first place.
>
> Not if it means forcing an FIEMAP_FLAG_SYNC, which implies an fsync().
> If the only way to get consistent data across ext4, btrfs, xfs,
> etc. is to force userspace to issue a FIEMAP_FLAG_SYNC, then we need
> to have a separate interface of SEEK_HOLE/SEEK_DATA that doesn't
> require flushing data to the disk first.
>
> Maybe coreutils will need to use FIEMAP_FLAG_SYNC initially, since
> it's the only way to guarantee correct behaviour for XFS. =A0But I would
> really rather that be the long-term way we leave things!
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0- Ted
>



-- =

Best Wishes
Yongqiang Yang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
