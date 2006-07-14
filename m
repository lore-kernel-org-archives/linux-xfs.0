Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Jul 2006 22:32:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6E5VqDW001581
	for <xfs@oss.sgi.com>; Thu, 13 Jul 2006 22:32:03 -0700
Date: Fri, 14 Jul 2006 15:31:06 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS bmap to disk lba question.
Message-ID: <20060714153106.I1768738@wobbly.melbourne.sgi.com>
References: <44B689AC.8030408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44B689AC.8030408@gmail.com>; from mikore.li@gmail.com on Fri, Jul 14, 2006 at 01:58:04AM +0800
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Michael Li (gmail)" <mikore.li@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 14, 2006 at 01:58:04AM +0800, Michael Li (gmail) wrote:
> We know that the command xfs_bmap can show us the file's extent range, 
> for example [20 - 100], but how can we know the real physical secoter ID 
> (or
> named as LBA) of file's first block(512Bytes) on a raw disk? I've read 
> XVM admin for IRIX,  it show us less clue for this mapping.

For a single disk, its relatively simple.  bmap gives you the starting
offset for each extent in  basic blocks (512 bytes) always, which maps
directly to sectors on the logical device.

You need to consider any partition table or volume manager header at
the start of a physical device, and factor that into the calculation,
they are not any one fixed size (I don't know how large an XVM label
would be for example).

> We can get this mapping method on linux, as linux/xfs is open sourced, 
> but IRIX is not, we don't know how to do it on IRIX, although the 
> filesystem is the in the same name XFS.

The xfs_bmap command is basically the same between IRIX and Linux.

> Furthermore, is it the same way to mapping the bmap/LBA in a striped 
> volume. ...
> unit is 128. each stripe unit has 32 512B-blocks. How can we map the 
> first block in the file to one of disk's X sector?

Well, it gets more complex now of course, bmap gives you one number
(for the single logical address space presented by the raid or volume
manager), and its an exercise for the reader to figure out which
actual disk that corresponds to based on the raid geometry.  Theres
no tools for doing this that I know of, you just have to sit down and
do the math... (well, thats how I've done it in the past anyway)... a
bit of a pain, I know.

> BTW: If we should not talk about IRIX here, I will stop posting such a 
> topic here. Sorry for the noise.

Heh, yes, its more usual to speak to SGI customer support folks for
this sort of topic.

cheers.

-- 
Nathan
