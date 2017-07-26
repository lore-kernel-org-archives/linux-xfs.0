Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750925AbdGZLPm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jul 2017 07:15:42 -0400
Date: Wed, 26 Jul 2017 07:15:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Recover file after truncate
Message-ID: <20170726111541.GB59833@bfoster.bfoster>
References: <575c9d8d-04c9-4d60-93d2-ccc86ec893a9@ashurst.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <575c9d8d-04c9-4d60-93d2-ccc86ec893a9@ashurst.eu.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Bennett <andyjpb@ashurst.eu.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2017 at 01:48:59AM +0100, Andy Bennett wrote:
> Hi,
> 
> I have a file (~6GiB) that I was doing some analysis on. In the course of
> this I managed to do 'xxd something-else my-file' and overwrote it with <
> 4.0K of data.
> 

This basically truncated the file and allocated new blocks for the xxd
output.

> 
> Running xfs_bmap on it gives me:
> 
> -----
> my-file:
>        0: [0..7]: 236935320..236935327
> -----
> 
> Running xfs_bmap on another, similar big, file that was created around the
> same time gives me:
> 
> -----
> other-file:
>        0: [0..4194175]: 335806496..340000671
>        1: [4194176..13828055]: 342870632..352504511

A ~2GB extent followed by a ~4.5GB extent.

> -----
> 
> 
> A quick experiment with xxd suggests that the inode of the file remains the
> same if it exists before xxd writes to it. So my new file still has the same
> inode as the one I want to recover.
> 
> There hasn't been any write activity on this file system since I made this
> mistake.
> 
> 
> Is there any hope of recovering any part of the original data?
> 

I suspect that most of your file data currently sits on free blocks in
the filesystem. If you had a bmap from before this incident, you could
probably point to exactly where they are. Since I assume that is
unlikely, you'd have to run something like you have below to try and
identify where that data is in the block device and try to piece
together the starting block and length of the associated extents.

I suppose that if you can distinguish the file data in any particular 4k
block from other random data then it might be possible to identify the
exact start/length values of the extents directly from the block device.
If you are luckier still and the original file was allocated with only
one or two extents similar to the above example, then you may be able to
piece together the file by putting the extents in the appropriate order.
FWIW, there are tools such as photorec that supposedly are able to do
this kind of thing with known file formats.

Note that I don't think there's any way to reassign the blocks to the
inode without doing some form of manual surgery on the filesystem, which
I would not recommend. If you actually were able to locate the file data
on the raw block device, the best course of action is to copy the data
from the block device to a new file on a separate filesystem and then
copy that file back into the original fs. Also note that once you start
writing anything to the original fs, the original data is at risk of
being overwritten. You may want to decommission the original storage or
make a copy to preserve the original state.

> I have an xxd dump of the first 624 bytes of the original file and there are
> some recurring features in it.
> 
> Grepping through the partition for that signature gives me this:
> 
> -----
> $ sudo grep -obUaP "\x66\x66\xa2" /dev/nvme0n1p8 |tee TRACE
> grep: exceeded PCRE's line length limit
> 519554640:ff¢
> 4377654787:ff¢
> 7961215381:ff¢
> 10165641473:ff¢
> 10849981825:ff¢
> 17851384491:ff¢
> 23231901998:ff¢
> 33898050969:ff¢
> 41781142596:ff¢
> 51651699392:ff¢
> 56040569029:ff¢
> 56277711167:ff¢
> 56814897544:ff¢
> 61037797435:ff¢
> 61269592210:ff¢
> 73946170693:ff¢
> 75199462354:ff¢
> 76071192135:ff¢
> -----
> 
> 
> The partition is on an NVMe SSD.
> 
> 
> I'm not sure how to use xfs_logprint but converting the inode number to hex
> and grepping through doesn't seem to give me any matches.
> 

What does the xfs_logprint output look like? Also, what is the inode
number of the original file? It is possible to get a hint on the
startblock and length of the original extent(s) if the log still has
EFI/EFD items present that describe the extent free operations, and that
information can be corroborated against either the inode information
and/or with the regions where file data is found in the blockdev scan.

Do note that the simple act of mounting the filesystem runs the risk of
overwriting previous log data. An 'xfs_metadump -go' might be a good way
to preserve current log content.

Brian

> 
> 
> Is there a way to find out how this file was allocated and restore it or
> fish the data out some how?
> 
> My mount options are
> 
> -----
> /dev/nvme0n1p8 on /var/spool type xfs (rw,relatime,attr2,inode64,noquota)
> -----
> 
> ...and I'm running under Debian Jessie.
> 
> I've not (knowingly) got any manual TRIM or DISCARD jobs that will run.
> 
> 
> 
> What's the best way of working out what current files the offsets from grep
> correspond to? I guess the ones that don't correspond to a current file
> might be my data?
> 
> 
> 
> Thanks for anything you can do to help.
> 
> 
> 
> 
> Regards,
> @ndy
> 
> -- 
> andyjpb@ashurst.eu.org
> http://www.ashurst.eu.org/
> 0x7EBA75FF
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
