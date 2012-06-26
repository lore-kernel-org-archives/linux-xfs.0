Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5QJYcdL139745 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 14:34:39 -0500
Received: from vserv.windfluechter.net (vserv.windfluechter.net
	[178.63.83.104]) by cuda.sgi.com with ESMTP id RJo3HjdAM73rrJGp
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jun 2012 12:34:34 -0700 (PDT)
Subject: Re: mkfs.xfs states log stripe unit is too large
Mime-Version: 1.0 (Apple Message framework v1084)
From: =?iso-8859-1?Q?Ingo_J=FCrgensmann?= <ij@2012.bluespice.org>
In-Reply-To: <20120626023059.GC19223@dastard>
Date: Tue, 26 Jun 2012 21:34:30 +0200
Message-Id: <8A10CAB6-655E-480D-9331-532B2A3FCDFC@2012.bluespice.org>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
	<d71834a062ffd666ab53a4695eb643e9@muaddib.hro.localnet>
	<20120626023059.GC19223@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Am 26.06.2012 um 04:30 schrieb Dave Chinner:

> On Sun, Jun 24, 2012 at 05:03:47PM +0200, Ingo J=FCrgensmann wrote:
>> On 2012-06-24 15:05, Stan Hoeppner wrote:
>> =

>>> The the log stripe unit mismatch error is a direct result of Ingo
>>> manually choosing a rather large chunk size for his two stripe
>>> spindle
>>> md array, yielding a 1MB stripe, and using an internal log with it.
>>> Maybe there is a good reason for this, but I'm going to challenge it.
>> =

>> To cite man mdadm:
>> =

>>       -c, --chunk=3D
>>              Specify chunk size of kibibytes.  The  default  when
>>              creating an array is 512KB.  To ensure compatibility
>>              with earlier versions, the default when Building and
>>              array  with no persistent metadata is 64KB.  This is
>>              only meaningful for RAID0, RAID4, RAID5, RAID6,  and
>>              RAID10.
>> =

>> So, actually there's a mismatch with the default of mdadm an
>> mkfs.xfs. Maybe it's worthwhile to think of raising the log stripe
>> maximum size to at least 512 kiB? I don't know what implications
>> this could have, though...
> =

> You can't, simple as that. The maximum supported is 256k. As it is,
> a default chunk size of 512k is probably harmful to most workloads -
> large chunk sizes mean that just about every write will trigger a
> RMW cycle in the RAID because it is pretty much impossible to issue
> full stripe writes. Writeback doesn't do any alignment of IO (the
> generic page cache writeback path is the problem here), so we will
> lamost always be doing unaligned IO to the RAID, and there will be
> little opportunity for sequential IOs to merge and form full stripe
> writes (24 disks @ 512k each on RAID6 is a 11MB full stripe write).
> =

> IOWs, every time you do a small isolated write, the MD RAID volume
> will do a RMW cycle, reading 11MB and writing 12MB of data to disk.
> Given that most workloads are not doing lots and lots of large
> sequential writes this is, IMO, a pretty bad default given typical
> RAID5/6 volume configurations we see....
> =

> Without the warning, nobody would have noticed this. I think the
> warning has value - even if it is just to indicate MD now uses a
> bad default value for common workloads..

Seconded. But I think the warning, as it is, can confuse the use - like me.=
 ;)

Maybe you can an URL to this warning message and point it to a detailed exp=
lanation: =


=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
Q: mkfs.xfs states log stripe unit is too large

A: On RAID devices created with mdadm and a 1.2 format superblock,
the default chunk size is 512 kiB. When creating a filesystem with =

mkfs.xfs on top of such a device, mkfs.xfs will use the chunk size
of the underlying RAID device to set some parameters of the file-
system, e.g. log stripe size. XFS is limited to 256 kiB of log stripe
size, so mkfs.xfs falls back to its default value of 32 kiB size when
it can't use larger values from underlying chunk sizes. This is, in
general, a good decision for your filesystem.  =


Best thing in general is to align all log writes to the
underlying stripe unit of the array. That way as multiple frequent
log writes occur, it is guaranteed to form full stripe writes and
basically have no RMW overhead. 32k is chosen by default because
that's the default log buffer size and hence the typical size of
log writes.

If you increase the log stripe unit, you also increase the minimum
log buffer size that the filesystem supports. The filesystem can
support up to 256k log buffers, and hence the limit on maximum log
stripe alignment.

The maximum supported log stripe size in XFS is 256k. As it is,
a default chunk size of 512k is probably harmful to most workloads -
large chunk sizes mean that just about every write will trigger a
RMW cycle in the RAID because it is pretty much impossible to issue
full stripe writes. Writeback doesn't do any alignment of IO (the
generic page cache writeback path is the problem here), so we will
lamost always be doing unaligned IO to the RAID, and there will be
little opportunity for sequential IOs to merge and form full stripe
writes (24 disks @ 512k each on RAID6 is a 11MB full stripe write).

IOWs, every time you do a small isolated write, the MD RAID volume
will do a RMW cycle, reading 11MB and writing 12MB of data to disk.
Given that most workloads are not doing lots and lots of large
sequential writes this is, IMO, a pretty bad default given typical
RAID5/6 volume configurations we see....

When benchmarking out mdraid stripe sizes a size of 32kb for XFS is
a clear winner, anything larger decreases performance.
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-

As you can see, I've conducted some answers from Dave and Chris that helped=
 me to understand the issue and the implications of log stripe size. =


I would welcome a FAQ entry and an URL to it included in the already existi=
ng warn message. Regardless whether you will do so, I've blogged today abou=
t this issue and the "solution": http://blog.windfluechter.net/content/blog=
/2012/06/26/1475-confusion-about-mkfsxfs-and-log-stripe-size-being-too-big
Maybe this helps other people to not come up with the same question... :-) =


Many thanks to all who helped me to understand this "issue"! :-) =


-- =

Ciao...            //      Fon: 0381-2744150
      Ingo       \X/       http://blog.windfluechter.net


gpg pubkey:  http://www.juergensmann.de/ij_public_key.asc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
