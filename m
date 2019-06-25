Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45796 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728580AbfFYNGd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 09:06:33 -0400
Subject: Re: Want help with messed-up dump
References: <2fE_FncH_93Kynhm46N3zVvFfq26C-AMOypRvdJX2gQM9UPDFVqsyW6svbeS_v1PWpH1lNG7P2cRBL81XDNXn8qioH18PY6aQYwn9_LHwBw=@unascribed.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <df58093d-9b7f-a6e2-5859-bcab9e9617e1@sandeen.net>
Date: Tue, 25 Jun 2019 08:06:31 -0500
MIME-Version: 1.0
In-Reply-To: <2fE_FncH_93Kynhm46N3zVvFfq26C-AMOypRvdJX2gQM9UPDFVqsyW6svbeS_v1PWpH1lNG7P2cRBL81XDNXn8qioH18PY6aQYwn9_LHwBw=@unascribed.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Una Thompson <una@unascribed.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On 6/25/19 12:00 AM, Una Thompson wrote:
> Hi,
> 
> Years ago (around 2015, if I remember correctly), while shrinking a 4.3TiB XFS partition on a RAID5 array, I attempted to perform a dump/restore cycle and lost exactly half of my data. (I was shrinking the partition by a few MB to make room for LUKS metadata to encrypt the filesystem.)
> 
> The array had 4 disks (3 online, 1 spare) - I took two disks out, degrading the array, to make room for the dump. Rather than join the two disks into a JBOD, I used xfsdump's ability to write two files, as the disks were 3.7TiB each and the filesystem was nearly full. As said, this was years ago, I forget the exact invocation.

Unfortunately xfsdump doesn't have a lot of experts anymore, but we can at least try.

Just to be clear, you did something like

xfsdump .... -f file1 -f file2 ?

and

"The split is done in filesystem inode number (ino) order, at boundaries selected
to equalize the size of each stream."

and now you only have file2, and file1 is lost?

> After restoring the dump to the new filesystem with the desired smaller size, I realized the filesystem was only half full. I looked around and a bunch of directories and files were missing. I tried xfsrestore again in various ways to try and get it to read both halves of the dump, but it'd always abort with an error when it finished with the first half.
> 
> I fully accept this was my fault and is user error, and I chalked it up as a learning experience at the time, and to avoid losing any more data, rejoined the disk with the first part of the dump to the array. However, now, I'm attempting to find some important files from 2011 or so that were on the array that were lost during this messed up dump/restore.
> 
> The spare was never used, and still has the second part of the dump on it; the part I believe didn't get restored correctly. The first part is now gone, after the RAID resync and LUKS format.
> 
> I've run photorec on the dump in an attempt to recover the files I'm looking for. I've found a few things that are familiar, but I'm mainly looking for a directory, not an archive, and photorec has been little help. Running xfsrestore on the orphaned half of the dump gives an error about a missing directory dump.

sharing the exact error you get when you try would be helpful.

-Eric

> Is there anything at all I may be able to do to restore the data from this dump? I've tried everything I can think of and have been unsuccessful. I have a feeling by losing the first half of the dump I've made any recovery impossible, but I figured if anyone knew a way for me to climb out of this hole I've dug for myself, it'd be someone on the XFS list.
> 
> Thanks
> 
