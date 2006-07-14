Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Jul 2006 22:52:59 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.173])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6E5qZDW005208
	for <xfs@oss.sgi.com>; Thu, 13 Jul 2006 22:52:36 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: XFS bmap to disk lba question.
Date: Fri, 14 Jul 2006 07:52:00 +0200
Message-ID: <55EF1E5D5804A542A6CA37E446DDC2062D6068@mapibe17.exchange.xchg>
From: "Sebastian Brings" <sebas@silexmedia.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>, "Michael Li (gmail)" <mikore.li@gmail.com>
Cc: xfs@oss.sgi.com

For Irix I am aware of two ways. One is to do the math, using xvm show
-verbose phys/* and so on to get the sizes of labels and volume header
and figure out where the first data block starts.
The other way is to use a program which does direct IO read on an
existing file and run it under control of "par -k". This produces plenty
of output, but holds information like "read from device X starting at
offset Y number of bytes Z. You then can match it with your xfs_bmap -v
list.

Cheers

Sebastian 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
Of
> Nathan Scott
> Sent: Freitag, 14. Juli 2006 07:31
> To: Michael Li (gmail)
> Cc: xfs@oss.sgi.com
> Subject: Re: XFS bmap to disk lba question.
> 
> On Fri, Jul 14, 2006 at 01:58:04AM +0800, Michael Li (gmail) wrote:
> > We know that the command xfs_bmap can show us the file's extent
range,
> > for example [20 - 100], but how can we know the real physical
secoter ID
> > (or
> > named as LBA) of file's first block(512Bytes) on a raw disk? I've
read
> > XVM admin for IRIX,  it show us less clue for this mapping.
> 
> For a single disk, its relatively simple.  bmap gives you the starting
> offset for each extent in  basic blocks (512 bytes) always, which maps
> directly to sectors on the logical device.
> 
> You need to consider any partition table or volume manager header at
> the start of a physical device, and factor that into the calculation,
> they are not any one fixed size (I don't know how large an XVM label
> would be for example).
> 
> > We can get this mapping method on linux, as linux/xfs is open
sourced,
> > but IRIX is not, we don't know how to do it on IRIX, although the
> > filesystem is the in the same name XFS.
> 
> The xfs_bmap command is basically the same between IRIX and Linux.
> 
> > Furthermore, is it the same way to mapping the bmap/LBA in a striped
> > volume. ...
> > unit is 128. each stripe unit has 32 512B-blocks. How can we map the
> > first block in the file to one of disk's X sector?
> 
> Well, it gets more complex now of course, bmap gives you one number
> (for the single logical address space presented by the raid or volume
> manager), and its an exercise for the reader to figure out which
> actual disk that corresponds to based on the raid geometry.  Theres
> no tools for doing this that I know of, you just have to sit down and
> do the math... (well, thats how I've done it in the past anyway)... a
> bit of a pain, I know.
> 
> > BTW: If we should not talk about IRIX here, I will stop posting such
a
> > topic here. Sorry for the noise.
> 
> Heh, yes, its more usual to speak to SGI customer support folks for
> this sort of topic.
> 
> cheers.
> 
> --
> Nathan
> 
