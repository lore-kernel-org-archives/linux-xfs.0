Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n06Mstt0019989 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 16:54:56 -0600
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C263217ACA66
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 14:54:54 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com
	[209.85.146.176]) by cuda.sgi.com with ESMTP id
	C13hEkaGVexU9AG7 for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2009 14:54:54 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id j5so4566468wah.4
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2009 14:54:53 -0800 (PST)
Message-ID: <b75ef8170901061454v76081ca8x6f87e4bf14eb8491@mail.gmail.com>
Date: Wed, 7 Jan 2009 00:54:52 +0200
From: "Gergely Soos" <sogerc1@gmail.com>
Subject: Re: need help to repair XFS partition
In-Reply-To: <4963DDD2.4030501@sandeen.net>
MIME-Version: 1.0
References: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>
	<49638190.3070803@sandeen.net>
	<b75ef8170901061004n75f52cffg7f810a51aca21ff@mail.gmail.com>
	<4963A706.8000500@sandeen.net>
	<b75ef8170901061351madb546flbc1631bc55cd4412@mail.gmail.com>
	<4963D320.9010000@sandeen.net>
	<b75ef8170901061431i68f8ebdey3ab08ea3dec9c079@mail.gmail.com>
	<4963DDD2.4030501@sandeen.net>
Content-Disposition: inline
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Jan 7, 2009 at 12:40 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Gergely Soos wrote:
> > Eric,
> > your intuition was absolutely correct. The starting point of my
> > partition was moved only not up but down 63 sectors (63*512 bytes)
> > It all makes sense, the whole partition grew 63*512 bytes = 0x7E (126)
> > inodes that is why I found the root inode on inode 0xFE instead of 0x80.
> > Now the question remains how the hell should I move it back??
> > And what kind of an idiot program moves the partition table without any
> > confirmation? That would kill any filesystem.
>
> Strangely, I've seen this before.  No idea why, or what is doing it.
>
> Hopefully you have saved copies of all the things you edited & dd'd?  So
> I'd start by putting those back.
>

Fortunately I did. And I copied them back.


>
> Then you can use a partition editor to move the start of the partition
> back where it belongs, I guess.  (w/o seeing where you found the
> superblocks, I'm not certain).
>
> Or, if I'm reading you right, do you mean that the first "XFSB" is 63
> sectors ahead of the start of hdd1?  If so, then maybe mounting /dev/hdd
> (not /dev/hdd1) just works.
>

Unfortunately it's not that simple. Actually that HDD has two partitions and
hdd2 is physically before hdd1 (they are reversed in the partition table),
so I absolutely need to move the start of the partition to the address which
is 63 sectors more than it is now.
Currently it starts at absolute byte position 5132575420 and it should start
at 5132606976.
Do you know what program is capable of doing this? I looked for MBR
documentation and in the partition table it is stored in CHS format
so it would be really hard (at least for me) to do it by hand.

Gergely


>
> -Eric
>
> > Gergely
> >
> > On Tue, Jan 6, 2009 at 11:54 PM, Eric Sandeen <sandeen@sandeen.net
> > <mailto:sandeen@sandeen.net>> wrote:
> >
> >     Gergely Soos wrote:
> >     > That is a good idea, I'm gonna search for the XFSB on the entire
> disk.
> >     > I will also give PhotoRec a try if nothing else works.
> >     > In the meantime, Eric, you can download the metadata from here:
> >     > http://bluepantherit.net/metadump.bz2
> >     > It would be real nice from you if you would take a closer look.
> >     >
> >     > And one more thing, xfs_check -s /dev/hdd1 prints the following:
> >     > can't seek in filesystem at bb 58701991023656163
> >     > can't read agfl block for ag 4082146910
> >     > can't seek in filesystem at bb 58702015871605112
> >
> >     ... it's basically reading garbage as block numbers, but they are
> well
> >     past the end of the device, so failing.
> >
> >     Very confused, it is.  :)
> >
> >     -Eric
> >
> >
>
>


[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
