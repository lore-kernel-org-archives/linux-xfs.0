Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OAh5AG177173 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 05:43:05 -0500
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA08C98F47
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 03:44:00 -0700 (PDT)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	h9avY8CI3TG2fjGk for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 03:44:00 -0700 (PDT)
Received: by gyf1 with SMTP id 1so1097015gyf.26
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 03:43:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C9A6298.106@sandeen.net>
References: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
	<4C9A6298.106@sandeen.net>
Date: Fri, 24 Sep 2010 11:43:59 +0100
Message-ID: <AANLkTinz4rYCb8cHH69pYy-oPT-041y+DmVaWm3N_1hu@mail.gmail.com>
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

On Wed, Sep 22, 2010 at 9:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Daire Byrne wrote:
>> Hi,
>>
>> I have been trying to figure out how to lay down a file sequence (e.g.
>> images) such that they are guaranteed to always be contiguous on disk
>> (i.e. no block gaps between them).
>
> There's no mechanism to guarantee that.
>
> Why is this the goal, what are you trying to achieve?

I am essentially trying to play back a large frame sequence and trying
to minimise seeks as it can lead to sporadic slowdowns on a SATA based
RAID.

>> Currently if I write a sequence to
>> disk things like "filestreams" help keep everything in the same AG and
>> the allocation algorithm seems to prefer to try and place files next
>> to eachother but without the filesystem knowing the total size of the
>> sequence there are always likely to be gaps in the blocks where
>> existing data has been written.
>
> preallocation of each image before writing would help make it more
> likely that each image is itself contiguous (but again this is not
> -guaranteed-)
>
>> So even if the first file is written
>> completely contiguously to disk there is no way to guarantee that
>> there is contiguous free space after it to write the rest of the
>> images.
>>
>> What I really want is to be able to find and reserve enough space for
>> the entire sequence and then write the files into that big contiguous
>> range. I tried to do this with xfs_io hoping that the allocator would
>> just know what I wanted and do the right thing (ever the optimist...).
>
> :)
>
>> So something like this:
>>
>> =A0 # find and reserve a big chunk to fit all my files in
>> =A0 xfs_io -f -c "resvsp 0 136314880" -c "bmap -v" $DIR/test.0
>>
>> =A0 # now shrink it keeping the start block
>> =A0 xfs_io -f -c "freesp 13631488 0" -c "bmap -v" $DIR/test.0
>>
>> =A0 # now write a bunch of files and hope they continue from test.0 on d=
isk
>> =A0 dd if=3D/dev/zero of=3D$DIR/test.0 bs=3D1M count=3D13 conv=3Dnocreat=
,notrunc
>> =A0 for =A0x in `seq 1 4`; do
>> =A0 =A0 =A0 dd if=3D/dev/zero of=3D$DIR/test.$x bs=3D1M count=3D13 conv=
=3Dnotrunc
>> =A0 done
>>
>> But a new allocation is made for the first new file in the sequence
>> elsewhere on disk and I don't know how to get it to use the large
>> chunk of free contiguous space after the "test.0" file instead.
>
> You can't specify a starting block for any given file I'm afraid.

Somebody pointed me at this which looks fairly promising:

  http://oss.sgi.com/archives/xfs/2006-07/msg01005.html

I'm still trying to get my head around how I would actually write a
userspace app/script to use it but I think it should allow me to do
what I want. It would be good if I could script it through xfs_io. I'd
really like a script where I could point it at a directory and it
would do something like:

  1. count total space used by file sequence
  2. find start block for that much contiguous space on disk (or as
much of it as possible)
  3. allocate the files using the start block one after another on disk

>> Another option might be to create a single contiguous large file,
>> concatenate all the images into it and then split it up on disk using
>> offsets but I don't think such a thing is even possible? I always know
>> the image sequence size beforehand, all images are exactly the same
>> size and I can control/freeze the filesystem access if needed.
>>
>> Anybody got any suggestions? It *seems* like something that should be
>> possible and would be useful.
>
> This would be pretty low-level control of the allocator by userspace.
>
> I'll just go back and ask what problem you're trying to solve? =A0There
> may be a better (i.e. currently existing) solution.

The "realtime" option is sometimes suggested as a way to do sequence
streaming but I'd really rather avoid that. It seems to me like the
option to allocate a sequence of files end on end in a known chunk of
contiguous space is something that would be useful in the normal
operating mode. SSDs are an option but they ain't cheap for the amount
of storage I require and besides I know that when the sequence is
written contiguously on disk my current setup can reach the required
speeds.

Thanks,

Daire

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
