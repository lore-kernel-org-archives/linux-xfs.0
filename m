Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9E187F4E
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 15:33:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B38D8F8033
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:33:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UozE9XIe9Kl8AVbp for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:33:17 -0800 (PST)
Message-ID: <5283EFFE.5090700@redhat.com>
Date: Wed, 13 Nov 2013 15:32:46 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com>
	<20131113185645.GA20869@infradead.org>
	<5283CE2E.2070702@sandeen.net> <20131113212658.GJ6188@dastard>
In-Reply-To: <20131113212658.GJ6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On 11/13/13, 3:26 PM, Dave Chinner wrote:
> On Wed, Nov 13, 2013 at 01:08:30PM -0600, Eric Sandeen wrote:
>> On 11/13/13, 12:56 PM, Christoph Hellwig wrote:
>>> On Wed, Nov 13, 2013 at 12:25:33PM -0600, Eric Sandeen wrote:
>>>> Pure RFC; this might be crazy.  Here's the problem I'm trying to solve:
>>>>
>>>> Today, mkfs.xfs will select a 4k sector size for a 4k physical / 512 logical
>>>> drive.  (that change was done by me).  The thought was that it'd be an
>>>> efficiency gain to not make the drive do the (possible) RMW cycles on
>>>> 512-byte log IO, primarily.
>>>>
>>>> However, now this restricts all DIO to 4k alignment, not the otherwise-
>>>> possible 512.
>>>>
>>>> This came up when qemu-kvm, in cache=none mode, tries to boot off an
>>>> image hosted on such a filesystem, and its bios wants to do a 512 byte
>>>> direct IO read off the disk - it fails.
>>>>
>>>> But I'm wondering - the buftarg's bt_sshift and bt_smask are only used
>>>> in a few places.  
>>>
>>> No need to mess with kernel code IFF we want to change that, just keep
>>> the sector size at 512 bytes and set a log stripe unit at mkfs time.
>>>
>>> I have to admit that I'm not really sure if that's what we really want,
>>> through.  A drive that has a larger physical block size will need
>>> read-modify-write cycles internally, which we try to avoid.
>>
>> Yeah, the problem comes up when it is 100% impossible to boot a
>> qemu-kvm guest hosted on such a filesystem/drive.  :(
> 
> No it's not. Just use cache=writethrough and the page cache will
> take care of the mismatch when it occurs.

Sorry, I meant impossible w/ cache=none.

TBH, I don't know what best practice is.

>> (of course I guess that means it fails on a hard 4k drive too)
> 
> And on any other filesystem that thinks it has sectors larger than
> 512 bytes underlying it (e.g. cdrom has a 2k sector size).
> 
>> I don't know what the guest sees for logical/physical on its
>> file-backed block device in these cases.
> 
> Seems like that's the avenue for improvement here to me. i.e. expose
> the correct values to the guest so it's mkfs does the right thing.
> Or, alternatively, make qemu buffer non-aligned/sized IOs itself
> internally.

The guest never _boots_ - it's not a guest mkfs issue.

The guest bios wants to read 512 via DIO off the image on this 4k
sector FS, and fails.

> After all, it has been told to use direct IO, and when that happens
> it is the application's responsibility to ensure IO alignment
> requirements are met...

Agreed, but in talking to a qemu guy... 

"In my understanding, that's a limitation that directly comes from the BIOS interface."
"int 13h just assumes 512 bytes"

But this is above my pay grade.  I don't speak BIOS.

>> Anyway, if we took your suggestion, normal internal fs operations
>> (log IO) wouldn't RMW.  But we'd still presumably advertise and allow
>> smaller DIO sizes, which are inefficient.  We could advertise 4k, but
>> still allow 512 for less-smart apps, maybe?
> 
> I'd say such a problem is a matter of user education and making qemu
> aware of logical/physical differences - hacking weird corner cases
> into what a sector size means is only going to lead to confusion and
> bite us in unexpected ways...

Probably so; hence the "crazy" disclaimer.  ;)

But it does seem a little odd to semi-artificially reject DIOs which
the drive could actually handle.

Indeed, do_blockdev_direct_IO looks right at the logical block size,
and allows it:

        if (offset & blocksize_mask) {
                if (bdev)
                        blkbits = blksize_bits(bdev_logical_block_size(bdev));
                blocksize_mask = (1 << blkbits) - 1;
                if (offset & blocksize_mask)
                        goto out;
        }

it's our checks in XFS that fail.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
