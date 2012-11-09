Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9Al7cQ099869 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 04:47:07 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DAM5fRrl9zUPTvlO for <xfs@oss.sgi.com>;
	Fri, 09 Nov 2012 02:49:05 -0800 (PST)
Date: Fri, 9 Nov 2012 21:48:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem recovery from secondary superblocks
Message-ID: <20121109104839.GE6434@dastard>
References: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
	<20121101225938.GS29378@dastard>
	<CABJyUz+VhUY=tVKpEeKXfQRoaL4s+gwNmRr4wNAnRX6zTt5xXg@mail.gmail.com>
	<CABJyUz+r7yQSswqyBng_W=fAXxTz9heb88NeiKSeFU7j4ZD=Hw@mail.gmail.com>
	<20121108210210.GP6434@dastard>
	<CABJyUzKy4YXVZAj=awVNfPD69eWo2mKhM7a-xWF1Vy-PD989sg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABJyUzKy4YXVZAj=awVNfPD69eWo2mKhM7a-xWF1Vy-PD989sg@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Aaron Goulding <aarongldng@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 08, 2012 at 11:28:20PM -0800, Aaron Goulding wrote:
> On Thu, Nov 8, 2012 at 1:02 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > That seems like way too many to be filesystem metadata hits. I woul
> > dhave expected the same number of hits as there are AGs in the
> > filesytem. What you want is the XFSB string in the first 4
> > bytes of a sector, with the next sector having XAGF as the first
> > four bytes....
> >
> 
> Okay this proved helpful. I ran a check of the first 1024 bytes at each of
> those 19000 results for XAGF, then limited that to results that occurred at
> the 512 byte relative mark. This dropped the results down to  11. I then
> went and grabbed 8192 bytes starting at each of those 11 points, and
> attached them.

bad:

4398367673432.dmp2 - has a headr followed by zeros, then parts of a
transaction headers, etc. just looks like random bits of filesystem
metadata record. It's probably the log.

12094629761024.dmp2 - has the first part of a superblco, but the
empty part of the sb is not zeroed - looks like a utf8 string?
Perhaps directory structure? components.ini.new is the repeated
name... AGI, AGF AGF look intact. Has this fs been grown in the
past?

13194139877376.dmp2 - Looks like an empty, pristine AG just freshly
allocated by mkfs. (AGFL contains only blocks 4,5,6 and 7, and the
AGF and ABTB block show a single large freespace extent covering the
entire AG (0x937a4 blocks in size).

So, judging by what I've got here, the file names are the block
offset of the data and that the offsets start at 0. That gives me
the headers for AGs 1, 3, 4, (the log in AG 4), 5, 6, 7, 9, 10, 11
and 12. Missing are 0, 2 and 8.

/me hugs xfs_db

$ xfs_db -c "sb 0" -c p -f 1099514834944.dmp2
<snip warnings>
magicnum = 0x58465342
blocksize = 4096
dblocks = 3375866880
rblocks = 0
rextents = 0
uuid = e36d4151-2bf0-4f0e-87e2-c21963022640
logstart = 1073741828
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 268435455
agcount = 13
rbmblocks = 0
logblocks = 521728
versionnum = 0xb4b4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 28
rextslog = 0
inprogress = 0
imax_pct = 5
icount = 3970688
ifree = 11
fdblocks = 260163907
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0xa
bad_features2 = 0xa

So I now know that there are only 13 AGs (0-12), and you are only
missing 0, 2 and 8, and that the log starts at 4398046527490 which
matches with the chunk that I though was a log record. The AGFs
indicate the sequence numbers are in the correct order and match the
offsets, so AFAICT you've assembled the array in the right order.

I think the best thing you could do copy the first 512 bytes from
the 1099514834944.dmp2 to the first sector of the device you dumped
this from (i.e. offset zero), and then running xfs_repair -n on it
to see whether it validates it as correct. (save the sector contents
first, jsut in case).

I'd say that there's probably only a small chance of recovering
much, there's a very good chance that you'll have to resort to tools
like xfs_irecover to find lost inodes on the disk to be able to
recover data. Still, one step at a time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
