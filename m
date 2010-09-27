Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8RGTdLA195028 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 11:29:39 -0500
Received: from mail-px0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82B71A2264
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 09:30:35 -0700 (PDT)
Received: from mail-px0-f181.google.com (mail-px0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	tJFN5Ry9nLpgvUha for <xfs@oss.sgi.com>;
	Mon, 27 Sep 2010 09:30:35 -0700 (PDT)
Received: by pxi5 with SMTP id 5so1947531pxi.26
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 09:30:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CA018D9.1030803@sandeen.net>
References: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
	<4C9A6298.106@sandeen.net>
	<AANLkTinz4rYCb8cHH69pYy-oPT-041y+DmVaWm3N_1hu@mail.gmail.com>
	<4CA018D9.1030803@sandeen.net>
Date: Mon, 27 Sep 2010 17:30:35 +0100
Message-ID: <AANLkTi=xPjAtjP5E6XK8Xhgvo1FoqAEUKLvDrNJO3-OH@mail.gmail.com>
Subject: Re: Contiguous file sequences
From: Daire Byrne <daire.byrne@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric,

On Mon, Sep 27, 2010 at 5:08 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Daire Byrne wrote:
>>> Why is this the goal, what are you trying to achieve?
>>
>> I am essentially trying to play back a large frame sequence and trying
>> to minimise seeks as it can lead to sporadic slowdowns on a SATA based
>> RAID.
>
> Ok - and you've really seen allocation patterns that cause the playback
> to slow down? =A0xfs_bmap information for a few sequential files that were
> this far off would be interesting to see.
>
> Are you certain that it's seekiness causing the problem? =A0A great way
> to visualize it would be to use the seekwatcher application while you
> run a problematic file sequence.

I'm certain that the seekiness is the culprit. The image files are
pretty big and require 400MB/s+ speeds to play them back at full rate.
I can play a sequence which is aligned perfectly on disk just fine
(readahead) but when seeks are required between frames the framerate
drops noticeably. I'm using SATA disks which probably doesn't help
matters.

>>> You can't specify a starting block for any given file I'm afraid.
>>
>> Somebody pointed me at this which looks fairly promising:
>>
>> =A0 http://oss.sgi.com/archives/xfs/2006-07/msg01005.html
>
> Yeah, that never got merged, but I think it still could be.
>
> It's only half your battle though, you need to find that contiguous
> space first, then specify the start block for it with the interface
> above.

I played around with the patch and I think I have a way to do what I
want using something like:

# allocate a big file that all the frames can fit into and hope it is conti=
guous
BLOCK=3D`xfs_io -f -c "resvsp 0 $TOTALSIZE" -c "freesp $FRAMESIZE 0" -c
"pwrite 0 1" -c "bmap" $DIR/test.0 | grep "0: \[" | sed 's/\../ /g' |
cut -f5 -d" "`
for x in `seq 1 $FRAMES`; do
    allocnear $DIR/test.$x $BLOCK
    BLOCK=3D`xfs_io -f -c "bmap" $DIR/test.$x | grep "0: \[" | sed
's/\../ /g' | cut -f5 -d" "`
    dd if=3D/dev/zero of=3D$DIR/test.$x bs=3D1M count=3D13 conv=3Dnotrunc,n=
ocreat
    sync
done

where "allocnear" just creates a new file with the near block hint. It
isn't pretty atm but it does a better job of allocating files without
any block gaps between them. FYI the allocation patch is bypassed on
newer kernels and is useless without modification thanks to:

  http://www.mail-archive.com/ocfs2-devel@oss.oracle.com/msg04387.html

>> I'm still trying to get my head around how I would actually write a
>> userspace app/script to use it but I think it should allow me to do
>> what I want. It would be good if I could script it through xfs_io. I'd
>> really like a script where I could point it at a directory and it
>> would do something like:
>>
>> =A0 1. count total space used by file sequence
>> =A0 2. find start block for that much contiguous space on disk (or as
>> much of it as possible)
>> =A0 3. allocate the files using the start block one after another on disk
>>
>>>> Another option might be to create a single contiguous large file,
>>>> concatenate all the images into it and then split it up on disk using
>>>> offsets but I don't think such a thing is even possible? I always know
>>>> the image sequence size beforehand, all images are exactly the same
>>>> size and I can control/freeze the filesystem access if needed.
>>>>
>>>> Anybody got any suggestions? It *seems* like something that should be
>>>> possible and would be useful.
>>> This would be pretty low-level control of the allocator by userspace.
>>>
>>> I'll just go back and ask what problem you're trying to solve? =A0There
>>> may be a better (i.e. currently existing) solution.
>>
>> The "realtime" option is sometimes suggested as a way to do sequence
>> streaming but I'd really rather avoid that. It seems to me like the
>> option to allocate a sequence of files end on end in a known chunk of
>> contiguous space is something that would be useful in the normal
>> operating mode.
>
> It would be, but it's not there now. =A0Also, without some more complexity
> it'd still probably end up being a best effort rather than a guarantee,
> but some hints from userspace might be better than nothing.

I'm pretty sure I can do what I need to do now. Just a case of writing
a userspace application to "defrag" a directory of images now ....

Thanks for the feedback,

Daire

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
