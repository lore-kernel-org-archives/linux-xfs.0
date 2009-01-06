Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n06N6ZFg020518 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 17:06:35 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F99367F4B
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 15:06:34 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id FshWW09SA3nXe563 for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2009 15:06:34 -0800 (PST)
Message-ID: <4963DDD2.4030501@sandeen.net>
Date: Tue, 06 Jan 2009 16:40:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: need help to repair XFS partition
References: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>	
	<49638190.3070803@sandeen.net>	
	<b75ef8170901061004n75f52cffg7f810a51aca21ff@mail.gmail.com>	
	<4963A706.8000500@sandeen.net>	
	<b75ef8170901061351madb546flbc1631bc55cd4412@mail.gmail.com>	
	<4963D320.9010000@sandeen.net>
	<b75ef8170901061431i68f8ebdey3ab08ea3dec9c079@mail.gmail.com>
In-Reply-To: <b75ef8170901061431i68f8ebdey3ab08ea3dec9c079@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gergely Soos <sogerc1@gmail.com>
Cc: xfs@oss.sgi.com

Gergely Soos wrote:
> Eric,
> your intuition was absolutely correct. The starting point of my
> partition was moved only not up but down 63 sectors (63*512 bytes)
> It all makes sense, the whole partition grew 63*512 bytes = 0x7E (126)
> inodes that is why I found the root inode on inode 0xFE instead of 0x80.
> Now the question remains how the hell should I move it back??
> And what kind of an idiot program moves the partition table without any
> confirmation? That would kill any filesystem.

Strangely, I've seen this before.  No idea why, or what is doing it.

Hopefully you have saved copies of all the things you edited & dd'd?  So
I'd start by putting those back.

Then you can use a partition editor to move the start of the partition
back where it belongs, I guess.  (w/o seeing where you found the
superblocks, I'm not certain).

Or, if I'm reading you right, do you mean that the first "XFSB" is 63
sectors ahead of the start of hdd1?  If so, then maybe mounting /dev/hdd
(not /dev/hdd1) just works.

-Eric

> Gergely
> 
> On Tue, Jan 6, 2009 at 11:54 PM, Eric Sandeen <sandeen@sandeen.net
> <mailto:sandeen@sandeen.net>> wrote:
> 
>     Gergely Soos wrote:
>     > That is a good idea, I'm gonna search for the XFSB on the entire disk.
>     > I will also give PhotoRec a try if nothing else works.
>     > In the meantime, Eric, you can download the metadata from here:
>     > http://bluepantherit.net/metadump.bz2
>     > It would be real nice from you if you would take a closer look.
>     >
>     > And one more thing, xfs_check -s /dev/hdd1 prints the following:
>     > can't seek in filesystem at bb 58701991023656163
>     > can't read agfl block for ag 4082146910
>     > can't seek in filesystem at bb 58702015871605112
> 
>     ... it's basically reading garbage as block numbers, but they are well
>     past the end of the device, so failing.
> 
>     Very confused, it is.  :)
> 
>     -Eric
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
