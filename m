Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45333 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752309AbdBBRev (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Feb 2017 12:34:51 -0500
Subject: Re: 4.9-stable updates for XFS
References: <1486022171-8076-1-git-send-email-hch@lst.de>
 <e2f39f4b-b906-5b66-56a3-0cd42fa7a309@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <af6be1f1-693d-f0ae-4bc6-4e301951bfcc@sandeen.net>
Date: Thu, 2 Feb 2017 11:34:50 -0600
MIME-Version: 1.0
In-Reply-To: <e2f39f4b-b906-5b66-56a3-0cd42fa7a309@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>

On 2/2/17 10:00 AM, Eric Sandeen wrote:
> On 2/2/17 1:55 AM, Christoph Hellwig wrote:
>> Hi all,
>>
>> below are backports up to 4.10-rc6 for XFS.  I've selected all clear
>> bugfixes for reported bugs.  I've skipped the finobt space reservation
>> patch for now - I think it is stable material, but I want it to settle
>> a bit more first.
> 
> fwiw, the finobt space reservation thing also seems to be doing something
> odd with allocation on striped storage, unless I'm missing something.
> 
> If I stick an xfs_bmap -v into generic/108 after we write the initial
> file, we find that it's not stripe aligned with that patch in place,
> which seems unexpected.  I haven't yet worked out why, was first trying
> to sort out that lvm error propagation problem...

Ok, I guess this may not be a big deal.  Because this is a small filesystem
in the test, and striped, we end up with small AGs:

meta-data=/dev/mapper/vg_108-lv_108 isize=512    agcount=9, agsize=7168 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
data     =                       bsize=4096   blocks=63488, imaxpct=25
         =                       sunit=1024   swidth=2048 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =/dev/sdb3              bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

each only 7168 blocks, or about 28M.

We try to do a 16M write, and xfs would like that to be stripe aligned.
I'm not quite sure why it's failing, but for a larger filesystem things
do come out aligned again.  I'll keep digging but I don't think there's
any fundamental problem here, this is a weird, small filesystem.

-Eric


