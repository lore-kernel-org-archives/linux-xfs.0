Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qABMYkt9174929 for <xfs@oss.sgi.com>; Sun, 11 Nov 2012 16:34:46 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ds2CZL4LlZTQCbFR for <xfs@oss.sgi.com>;
	Sun, 11 Nov 2012 14:36:46 -0800 (PST)
Date: Mon, 12 Nov 2012 09:36:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem recovery from secondary superblocks
Message-ID: <20121111223643.GM24575@dastard>
References: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
	<20121101225938.GS29378@dastard>
	<CABJyUz+VhUY=tVKpEeKXfQRoaL4s+gwNmRr4wNAnRX6zTt5xXg@mail.gmail.com>
	<CABJyUz+r7yQSswqyBng_W=fAXxTz9heb88NeiKSeFU7j4ZD=Hw@mail.gmail.com>
	<20121108210210.GP6434@dastard>
	<CABJyUzKy4YXVZAj=awVNfPD69eWo2mKhM7a-xWF1Vy-PD989sg@mail.gmail.com>
	<20121109104839.GE6434@dastard>
	<CABJyUzJVj-rpGW=i5QG=AZPvhuD-qdbujuwOdu_EdGbYGZ++Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABJyUzJVj-rpGW=i5QG=AZPvhuD-qdbujuwOdu_EdGbYGZ++Rg@mail.gmail.com>
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

On Fri, Nov 09, 2012 at 07:22:01AM -0800, Aaron Goulding wrote:
> On Fri, Nov 9, 2012 at 2:48 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Thu, Nov 08, 2012 at 11:28:20PM -0800, Aaron Goulding wrote:
> > > On Thu, Nov 8, 2012 at 1:02 PM, Dave Chinner <david@fromorbit.com>
> > wrote:
> > >
> > > > That seems like way too many to be filesystem metadata hits. I woul
> > > > dhave expected the same number of hits as there are AGs in the
> > > > filesytem. What you want is the XFSB string in the first 4
> > > > bytes of a sector, with the next sector having XAGF as the first
> > > > four bytes....
> > > >
> > >
> > > Okay this proved helpful. I ran a check of the first 1024 bytes at each
> > of
> > > those 19000 results for XAGF, then limited that to results that occurred
> > at
> > > the 512 byte relative mark. This dropped the results down to  11. I then
> > > went and grabbed 8192 bytes starting at each of those 11 points, and
> > > attached them.
......
> > $ xfs_db -c "sb 0" -c p -f 1099514834944.dmp2
> > <snip warnings>
> > magicnum = 0x58465342
> > blocksize = 4096
> > dblocks = 3375866880
> > rblocks = 0
> > rextents = 0
> > uuid = e36d4151-2bf0-4f0e-87e2-c21963022640
> > logstart = 1073741828
> > rootino = 128
> > rbmino = 129
> > rsumino = 130
> > rextsize = 1
> > agblocks = 268435455
....
> > blocklog = 12
....
> > So I now know that there are only 13 AGs (0-12), and you are only
> > missing 0, 2 and 8, and that the log starts at 4398046527490 which
> > matches with the chunk that I though was a log record. The AGFs
> > indicate the sequence numbers are in the correct order and match the
> > offsets, so AFAICT you've assembled the array in the right order.
> >
> > I think the best thing you could do copy the first 512 bytes from
> > the 1099514834944.dmp2 to the first sector of the device you dumped
> > this from (i.e. offset zero), and then running xfs_repair -n on it
> > to see whether it validates it as correct. (save the sector contents
> > first, jsut in case).
> >
> > root@jarvis:~/dump1# dd if=1099514834944.dmp2 of=/dev/md1 bs=512 count=1
> 1+0 records in
> 1+0 records out
> 512 bytes (512 B) copied, 0.0649365 s, 7.9 kB/s
> root@jarvis:~/dump1# xfs_i
> xfs_info  xfs_io
> root@jarvis:~/dump1# xfs_repair -n /dev/md1
> Phase 1 - find and verify superblock...
> couldn't verify primary superblock - not enough secondary superblocks with
> matching geometry !!!

Which means it found less than 13/2 = 6 valid secondary superblocks.

I should have looked at this previously: the addresses of the
secondary superblocks should be:

$ for i in `seq 0 1 12`; do echo $((i * 268435455 << 12)) ; done
0
1099511623680
2199023247360
3298534871040
4398046494720
5497558118400
6597069742080
7696581365760
8796092989440
9895604613120
10995116236800
12094627860480
13194139484160

and the offsets with superblocks in them are:

1099514834944.dmp2
3298535133184.dmp2
4398047346688.dmp2
5497559560192.dmp2
6597069676544.dmp2
7696579268608.dmp2
9895606972416.dmp2
10995117088768.dmp2
12094629761024.dmp2
13194139877376.dmp2

All wrong. The difference is between AG 1 is 3,211,264 bytes, Ag 3
is 262144 bytes, AG 4 is 851,968 bytes, and so on. There is no
consistency in the difference between where you found the headers
and where they should. There's no way I can put this back together
into a repairable filesystem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
