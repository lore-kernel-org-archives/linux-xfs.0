Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D40307F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 13:43:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5DBC8F8050
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 11:43:09 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id fCHAz2GAm82ggePt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 11:43:08 -0700 (PDT)
Date: Thu, 25 Jul 2013 14:43:08 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH] xfstests: 091, 240, 268 fix for xfs on 4k sector hard
	drive
Message-ID: <20130725144308.4c4a5f79@oracle.com>
In-Reply-To: <51F142E7.4050500@sandeen.net>
References: <20130724143208.34b77534@oracle.com>
	<20130724235739.GR19986@dastard>
	<51F0AB56.7020705@hardwarefreak.com>
	<20130725102754.7c564098@oracle.com> <51F142E7.4050500@sandeen.net>
Mime-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jeff Moyer <jmoyer@redhat.com>, stan@hardwarefreak.com, xfs@oss.sgi.com

On Thu, 25 Jul 2013 10:23:19 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

[...]
> (You can probably mkfs w/ an explicit 512 sector size, and confirm
> that 512-byte DIOs work again)

Hi Eric, yep, confirmed that doing mkfs.xfs -b size=1024 (used 1024
instead of 512 so that 240 would run) makes 091, 240, and 268 work
without my changes.

> bleah, perhaps that was a mistake - or perhaps we need to fix
> kernelspace to prefer physical-size IOs, but allow logical-size if a
> DIO requests it.

ext4 and btrfs did work, so perhaps that is what they are doing, I
have not looked yet.

[... test 240]
> >>>> -logical_block_size=`blockdev --getss $TEST_DEV`
> >>>> +logical_block_size=`blockdev --getpbsz $TEST_DEV`
> >>>
> >>> FWIW, that doesn't make much sense - putting the physical block
> >>> size into a variable named "logical_block_size".....
> > 
> > Yeah, that name wouldn't make much sense with this change. Its
> > actually being used to compare to the fs block size and then its
> > passed into aiodio_sparse2 as offset. 091 and 268 use the more
> > generic name bsize, should I can change it to that?
> 
> Well, that was put there with:
> 
> commit 2dbd21dc152d89715263990c881025f17c7b632e
> Author: Jeff Moyer <jmoyer@redhat.com>
> Date:   Fri Feb 11 15:20:02 2011 -0500
> 
>     240: only run when the file system block size is larger than the
> disk sector size 
>     This test really wants to test partial file-system block I/Os.
> Thus, if the device has a 4K sector size, and the file system has a
> 4K block size, there's really no point in running the test.  In the
> attached patch, I check that the fs block size is larger than the
> device's logical block size, which should cover a 4k device block
> size with a 16k fs block size.
>     
>     I verified that the patched test does not run on my 4k sector
> device with a 4k file system.  I also verified that it continues to
> run on a 512 byte logical sector device with a 4k file system block
> size. 
>     Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>     Signed-off-by: Christoph Hellwig <hch@lst.de>

The name was added in this commit, and the message would lead me to
believe that Jeff intended for the test to not run on a 4k physical
sector disk with a 4k fs, so is the "logical_block_size" name a
misnomer?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
