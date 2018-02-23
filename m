Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55954 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753662AbeBWTbA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Feb 2018 14:31:00 -0500
Subject: Re: xfs_repair questions
References: <CACssdW1a=+6Dh=TEV1g13ipfM1TXd29SEHNuz_ar7RfwpmgdFg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <99fc8927-31d4-7634-c96e-7905f3d74646@sandeen.net>
Date: Fri, 23 Feb 2018 13:30:58 -0600
MIME-Version: 1.0
In-Reply-To: <CACssdW1a=+6Dh=TEV1g13ipfM1TXd29SEHNuz_ar7RfwpmgdFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alatun Rom <alatun.rom@gmail.com>, linux-xfs@vger.kernel.org

On 2/22/18 5:42 PM, Alatun Rom wrote:
> Now I'm trying to fix the xfs in this partition dump. xfs_repair found
> 7 candidates of secondary superblocks, but is unable to verify them. I
> was rather disappointed with the lack of information xfs_repair
> reported.
> 
> So I made a git clone of xfstools and looked for the code doing the
> repair and added some more output. I added information about the file
> offset of the candidates and the status, why it is considered unusable.
> The output of xfs_repair for my broken partition now looks like this:
> ---
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!

So right off the bat, the first superblock in sector zero looks bad.
Are you sure you properly extracted this part of the disk?  What
does i.e. blkid or file -s say about what you extracted, and
what does a hexdump look like?

> attempting to find secondary superblock...
> found candidate secondary superblock... off: 32204029952
> checking sbs#: 4
> check sbs@ 32212221952 - status: 1

without knowing what your patches do, I don't know what "status: 1"
means here.  Is that a failure?

And backing up, what version of xfsprogs are you using?

> check sbs@ 64424443904 - status: 1
> check sbs@ 96636665856 - status: 1
> unable to verify superblock, continuing... error code: 16

#define XR_INSUFF_SEC_SB        16      /* not enough matching secondary sbs */

        if (num_ok < num_sbs / 2) {
                retval = XR_INSUFF_SEC_SB;

> found candidate secondary superblock... off: 57813565440
> checking sbs#: 4
> check sbs@ 32212221952 - status: 1
> check sbs@ 64424443904 - status: 1
> check sbs@ 96636665856 - status: 1
> unable to verify superblock, continuing... error code: 16
> found candidate secondary superblock... off: 64185663488
> checking sbs#: 4
> check sbs@ 32212221952 - status: 1
> check sbs@ 64424443904 - status: 1
> check sbs@ 96636665856 - status: 1
> unable to verify superblock, continuing... error code: 16
> found candidate secondary superblock... off: 96412992512
> checking sbs#: 4
> check sbs@ 7232069632 - status: 1
> check sbs@ 14464139264 - status: 1
> check sbs@ 21696208896 - status: 1
> unable to verify superblock, continuing... error code: 16
> found candidate secondary superblock... off: 96413164544
> checking sbs#: 4
> check sbs@ 7232069632 - status: 1
> check sbs@ 14464139264 - status: 1
> check sbs@ 21696208896 - status: 1
> unable to verify superblock, continuing... error code: 16
> found candidate secondary superblock... off: 96413271040
> checking sbs#: 4
> check sbs@ 7232069632 - status: 1
> check sbs@ 14464139264 - status: 1
> check sbs@ 21696208896 - status: 1
> unable to verify superblock, continuing... error code: 16
> found candidate secondary superblock... off: 96419537920
> checking sbs#: 4
> check sbs@ 7232069632 - status: 1
> check sbs@ 14464139264 - status: 1
> check sbs@ 21696208896 - status: 1
> unable to verify superblock, continuing... error code: 16
> Sorry, could not find valid secondary superblock
> Exiting now.
> --
> (error code 16: not enough superblocks to validate
> status code 1: invalid superblock signature)
> I also extracted the blocks at the given offsets (eg @ 32204029952) ,
> examined them and the contents of the SSBs are looking quite good:
> --
> 00000000  58 46 53 42 00 00 10 00  00 00 00 00 01 df ff e0  |XFSB............|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000020  b1 f2 a8 ad 7d 75 4d a0  9a be 3f e6 a4 e4 05 c3  |....}uM...?.....|
> 00000030  00 00 00 00 01 00 00 04  00 00 00 00 00 00 00 80  |................|
> 00000040  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
> 00000050  00 00 00 01 00 77 ff f8  00 00 00 04 00 00 00 00  |.....w..........|
> 00000060  00 00 3b ff b4 a4 02 00  01 00 00 10 68 79 00 00  |..;.........hy..|
> 00000070  00 00 00 00 00 00 00 00  0c 09 08 04 17 00 00 19  |................|
> 00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000090  00 00 00 00 01 df c3 d1  00 00 00 00 00 00 00 00  |................|
> 000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 000000b0  00 00 00 00 00 00 00 02  00 00 00 00 00 00 00 00  |................|
> 000000c0  00 00 00 00 00 00 00 01  00 00 00 08 00 00 00 08  |................|
> 000000d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000200
> --
> As far as I understood, xfs_repair considers the file system
> unfixable, because the secondary superblocks are not found at the offsets,
> where they should be. The blocks found look quite ok.
> My guess: because the VMDK container got damaged, the information of
> the internal partitions is now incorrect, so testdisk did extract a
> file that is somehow broken. But from what I've seen so far, it could
> be possible to fix it up to the point, to extract some files.
> 
> What is unclear for me: why are 7 SSB found?

It may have found logged superblocks in the log region.

> Is this a geometry issue?
> The found superblocks tell, that a total of 4 superblocks should
> exist. What happens if you grow an XFS file system? Do additional
> stripes generate a layout like this? 

you get extra allocation groups added, and the superblock AG count
will reflect this.

> Is the distance between the
> superblock copies ALWAYS a constant value? 

yes, though the last one may be a smaller size.

> In my scenario the distance
> of the first 3 superblocks is not a fixed value. But how can blocks
> get lost? I don't think this is possible with VMDK to "mark blocks as
> deleted" inside a partition and they are skipped when reading a partition.
> 
> Perhaps somebody with more knowledge can comment on this and can give me
> some pointers.

So, xfs_repair used to be really braindead and scan the entire device
sector by sector looking for candidate superblocks.  A while back some
heuristics were added to try to be a little smarter; once a candidate was
found, try checking the other locations that the found superblock
points to.  However if things fail, IIRC it is supposed to fall back to
a block-by-block scan.

Can you try xfsprogs-4.6.0, and run an xfs_repair -n from that?

(-n will be check only and will leave the fs unchanged; if that does
work I'd like to get to the bottom of why newer xfsprogs fails for you,
so would rather not modify anything yet, if you can tolerate a bit of
a wait)

-Eric
