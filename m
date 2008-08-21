Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Aug 2008 22:14:00 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7L5DugU004554
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 22:13:56 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3D3E1A1D49F
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 22:15:14 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id hZxueCxdH7JJMKLi for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 22:15:14 -0700 (PDT)
Date: Thu, 21 Aug 2008 15:15:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080821051508.GB5706@disturbed>
References: <20080820004326.519405a2.akpm@linux-foundation.org> <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2> <20080820143916.1a7eddab.akpm@linux-foundation.org> <20080821021259.GA5706@disturbed> <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 21, 2008 at 05:46:00AM +0300, Szabolcs Szakacsits wrote:
> On Thu, 21 Aug 2008, Dave Chinner wrote:
> > On Wed, Aug 20, 2008 at 02:39:16PM -0700, Andrew Morton wrote:
> > > On Thu, 21 Aug 2008 00:25:55 +0300 (MET DST)
> > > Szabolcs Szakacsits <szaka@ntfs-3g.org> wrote:
> > > > I ran compilebench on kernel 2.6.26 with freshly formatted volumes. 
> > > > The behavior of NILFS2 was interesting.
> > > > 
> > > > Its peformance rapidly degrades to the lowest ever measured level 
> > > > (< 1 MB/s) but after a while it recovers and gives consistent numbers.
> > > > However it's still very far from the current unstable btrfs performance. 
> > > > The results are reproducible.
> > > > 
> > > >                     MB/s    Runtime (s)
> > > >                    -----    -----------
> > > >   btrfs unstable   17.09        572
> > > >   ext3             13.24        877
> > > >   btrfs 0.16       12.33        793
> > > >   nilfs2 2nd+ runs 11.29        674
> > > >   ntfs-3g           8.55        865
> > > >   reiserfs          8.38        966
> > > >   nilfs2 1st run    4.95       3800
> > > >   xfs               1.88       3901
> > > 
> > > err, what the heck happened to xfs?  Is this usual?
> > 
> > No, definitely not usual. I suspect it's from an old mkfs and
> > barriers being used.  What is the output of the xfs.mkfs when
> > you make the filesystem and what mount options being used?
> 
> Everything is default.
> 
>   % rpm -qf =mkfs.xfs
>   xfsprogs-2.9.8-7.1 
> 
> which, according to ftp://oss.sgi.com/projects/xfs/cmd_tars, is the 
> latest stable mkfs.xfs. Its output is
> 
> meta-data=/dev/sda8              isize=256    agcount=4, agsize=1221440 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=4885760, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096  
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Ok, I thought it might be the tiny log, but it didn't improve anything
here when increased the log size, or the log buffer size.

Looking at the block trace, I think elevator merging is somewhat busted. I'm
seeing adjacent I/Os being dispatched without having been merged.  e.g:

104,48   1     2139     4.803090086  4175  Q   W 18540712 + 8 [pdflush]
104,48   1     2140     4.803092492  4175  G   W 18540712 + 8 [pdflush]
104,48   1     2141     4.803094875  4175  P   N [pdflush]
104,48   1     2142     4.803096205  4175  I   W 18540712 + 8 [pdflush]
104,48   1     2143     4.803160324  4175  Q   W 18540720 + 40 [pdflush]
104,48   1     2144     4.803162724  4175  M   W 18540720 + 40 [pdflush]
104,48   1     2145     4.803231701  4175  Q   W 18540760 + 48 [pdflush]
104,48   1     2146     4.803234223  4175  M   W 18540760 + 48 [pdflush]
.....
104,48   1     2163     4.803844214  4175  Q   W 18541032 + 56 [pdflush]
104,48   1     2164     4.803846694  4175  M   W 18541032 + 56 [pdflush]
104,48   1     2165     4.803932321  4175  Q   W 18541088 + 48 [pdflush]
104,48   1     2166     4.803937177  4175  G   W 18541088 + 48 [pdflush]
104,48   1     2167     4.803940416  4175  I   W 18541088 + 48 [pdflush]
104,48   1     2168     4.804005265  4175  Q   W 18541136 + 24 [pdflush]
104,48   1     2169     4.804007664  4175  M   W 18541136 + 24 [pdflush]
.....
104,48   1     2183     4.804518129  4175  D   W 18540712 + 376 [pdflush]
104,48   1     2184     4.804537981  4175  D   W 18541088 + 248 [pdflush]

In entry 2165, a new request is made rather than merging the
existing, adjacent request that is already open. The result is we
then dispatch two I/Os instead of one.

Also, CFQ appears to not be merging WRITE_SYNC bios or issuing them
with any urgency.  The result of this is that it stalls the XFS
transaction subsystem by capturing all the log buffers in the
elevator and not issuing them. e.g.:

104,48   0      149     0.107856547  4160  Q  WS 35624860 + 128 [pdflush]
104,48   0      150     0.107861855  4160  G  WS 35624860 + 128 [pdflush]
104,48   0      151     0.107865332  4160  I   W 35624860 + 128 [pdflush]
...
104,48   0      162     0.120791581  4159  Q  WS 35624988 + 128 [python]
104,48   0      163     0.120805714  4159  G  WS 35624988 + 128 [python]
104,48   0      164     0.120813427  4159  I   W 35624988 + 128 [python]
104,48   0      165     0.132109889  4159  Q  WS 35625116 + 128 [python]
104,48   0      166     0.132128642  4159  G  WS 35625116 + 128 [python]
104,48   0      167     0.132132988  4159  I   W 35625116 + 128 [python]
104,48   0      168     0.143612843  4159  Q  WS 35625244 + 128 [python]
104,48   0      169     0.143640248  4159  G  WS 35625244 + 128 [python]
104,48   0      170     0.143644697  4159  I   W 35625244 + 128 [python]
104,48   0      171     0.158243553  4159  Q  WS 35625372 + 128 [python]
104,48   0      172     0.158261652  4159  G  WS 35625372 + 128 [python]
104,48   0      173     0.158266233  4159  I   W 35625372 + 128 [python]
104,48   0      174     0.171342555  4159  Q  WS 35625500 + 128 [python]
104,48   0      175     0.171360707  4159  G  WS 35625500 + 128 [python]
104,48   0      176     0.171365036  4159  I   W 35625500 + 128 [python]
104,48   0      177     0.183936429  4159  Q  WS 35625628 + 128 [python]
104,48   0      178     0.183955172  4159  G  WS 35625628 + 128 [python]
104,48   0      179     0.183959726  4159  I   W 35625628 + 128 [python]
...
104,48   0      180     0.194008953  4159  Q  WS 35625756 + 128 [python]
104,48   0      181     0.194027120  4159  G  WS 35625756 + 128 [python]
104,48   0      182     0.194031311  4159  I   W 35625756 + 128 [python]
...
104,48   0      191     0.699915104     0  D   W 35624860 + 128 [swapper]
...
104,48   0      196     0.700513279     0  C   W 35624860 + 128 [0]
...
104,48   0      198     0.711808579  4159  Q  WS 35625884 + 128 [python]
104,48   0      199     0.711826259  4159  G  WS 35625884 + 128 [python]
104,48   0      200     0.711830589  4159  I   W 35625884 + 128 [python]
104,48   0      201     0.711848493  4159  D   W 35624988 + 128 [python]
104,48   0      202     0.711861868  4159  D   W 35625116 + 128 [python]
104,48   0      203     0.711868531  4159  D   W 35625244 + 128 [python]
104,48   0      204     0.711874967  4159  D   W 35625372 + 128 [python]
....
104,48   1       72     0.900288147     0  D   W 35625500 + 128 [swapper]
104,48   1       73     0.900296058     0  D   W 35625628 + 128 [swapper]
104,48   1       74     0.900302401     0  D   W 35625756 + 128 [swapper]
104,48   1       75     0.900308516     0  D   W 35625884 + 128 [swapper]
.....

here we see all 8 log buffers written and queued in ~95ms. At this point
(0.194s into the trace) the log stalls because we've used all the log
buffers and have to wait for I/O to complete. The filesystem effectively
sits idle now for half a second waiting for I/O to be dispatched.

At 0.699s, we have a single buffer issued and it completes in 500
*microseconds* (NVRAM on raid controller). We do completion
processing, fill and dispatch that buffer in under 10ms (on a 1GHz
P3) at which point we dispatch the 4 oldest remaining buffers. 200ms
later, we dispatch the remainder.

Effectively, the elevator has stalled all transactions in the
filesystem for close to 700ms by not dispatching the SYNC_WRITE
buffers, and all the bios could have been merged into a single 512k
I/O when they were to be dispatched. I guess the only way to prevent
this really is to issue explicit unplugs....

On 2.6.24:

104,48   0      975     1.707253442  2761  Q  WS 35753545 + 128 [python]
104,48   0      976     1.707268811  2761  G  WS 35753545 + 128 [python]
104,48   0      977     1.707275455  2761  I   W 35753545 + 128 [python]
104,48   0      978     1.728703316  2761  Q  WS 35753673 + 128 [python]
104,48   0      979     1.728714289  2761  M  WS 35753673 + 128 [python]
104,48   0      980     1.761603632  2761  Q  WS 35753801 + 128 [python]
104,48   0      981     1.761614498  2761  M  WS 35753801 + 128 [python]
104,48   0      982     1.784522988  2761  Q  WS 35753929 + 128 [python]
104,48   0      983     1.784533351  2761  M  WS 35753929 + 128 [python]
....
104,48   0     1125     2.475132431     0  D   W 35753545 + 512 [swapper]

The I/Os are merged, but there's still that 700ms delay before dispatch.
i was looking at this a while back but didn't get to finishing it off.
i.e.:

http://oss.sgi.com/archives/xfs/2008-01/msg00151.html
http://oss.sgi.com/archives/xfs/2008-01/msg00152.html

I'll have a bit more of a look at this w.r.t to compilebench performance,
because it seems like a similar set of problems that I was seeing back
then...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
