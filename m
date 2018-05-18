Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53838 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbeERO4D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 May 2018 10:56:03 -0400
Subject: Re: How to reliably measure fs usage with reflinks enabled?
References: <5398ddaf2b876c3563bc1c2927bfe1b9@ruhr-uni-bochum.de>
 <866a5e96-e900-d330-0efb-6413f85f86a3@sandeen.net>
 <20180514225751.GB10363@dastard>
 <b2fe69d6216f165b2c84ca5a377d06ab@ruhr-uni-bochum.de>
 <20180515012926.GC10363@dastard>
 <CAMU1PDgMH_K1N71SmkwDj159wTjFM3js-hhFGr8uE_GhmLn5mA@mail.gmail.com>
 <20180516001342.GK23861@dastard>
 <CAMU1PDg-aOE-gakEtktq8nDRWXcsdorcx0a25_uQ_MFM1nUTpQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f220ccc1-00ed-879e-94d0-33cb9d5a1e37@sandeen.net>
Date: Fri, 18 May 2018 09:56:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAMU1PDg-aOE-gakEtktq8nDRWXcsdorcx0a25_uQ_MFM1nUTpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Fleetwood <mike.fleetwood@googlemail.com>, Dave Chinner <david@fromorbit.com>
Cc: Tarik Ceylan <Tarik.Ceylan@ruhr-uni-bochum.de>, linux-xfs@vger.kernel.org

On 5/18/18 9:43 AM, Mike Fleetwood wrote:
> (Sorry for the late reply, work commitments)
> 
...

> So after checking, GParted was modified to use the dumpe2fs command to
> read the superblock to get the file system size for mounted ext* file
> systems too.
> 
> https://marc.info/?l=linux-ext4&m=134706477618732&w=2
> 
> I see that xfs_db doesn't allow reading the super block of mounted XFS
> file systems.  So for the case of a mounted XFS on full fat block device
> I guess I'll wait and see how much overhead is subtracted from the
> statvfs f_blocks figure and make sure GParted accounts for that.

Actually you can, with -r:

# mount /dev/sda1 /mnt/test
# xfs_db -r -c "sb 0" -c "p dblocks" /dev/sda1
dblocks = 229771264

though I may be giving you rope to hang yourself here ;)

It's generally a bit dicey to be reading a mounted block device for any
filesystem, as there's no coordination with changes the filesystem may
be making while it's mounted.

The XFS_IOC_FSGEOMETRY would be a better choice for gathering geometry
information for a mounted xfs filesystem.

-Eric
