Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JEbIET105113 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 09:37:19 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id f8fOjQMaVhlqVUvL for
	<xfs@oss.sgi.com>; Tue, 19 Jun 2012 07:37:18 -0700 (PDT)
Date: Tue, 19 Jun 2012 16:37:07 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
In-Reply-To: <20120619141933.GC10637@thunk.org>
Message-ID: <alpine.LFD.2.00.1206191622200.2241@dhcp-1-248.brq.redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
	<alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
	<20120619141933.GC10637@thunk.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571144193-1142892503-1340116630=:2241"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571144193-1142892503-1340116630=:2241
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 19 Jun 2012, Ted Ts'o wrote:

> Date: Tue, 19 Jun 2012 10:19:33 -0400
> From: Ted Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Spelic <spelic@shiftmail.org>, xfs@oss.sgi.com,
>     linux-ext4@vger.kernel.org,
>     device-mapper development <dm-devel@redhat.com>
> Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
> 
> On Tue, Jun 19, 2012 at 04:09:48PM +0200, Lukáš Czerner wrote:
> > 
> > With thin provisioning you'll get totally different file system
> > layout than on fully provisioned disk as you push more and more
> > writes to your drive. This unfortunately has great impact on
> > performance since file systems usually have a lot of optimization on
> > where to put data/metadata on the drive and how to read them.
> > However in case of thinly provisioned storage those optimization
> > would not help. And yes, you just have to expect lower performance
> > with dm-thin from the file system on top of it. It is not and it
> > will never be ideal solution for workloads where you expect the best
> > performance.
> 
> One of the things which would be nice to be able to easily set up is a
> configuration where we get the benefits of thin provisioning with
> respect to snapshost, but where the underlying block device used by
> the file system is contiguous.  That is, it would be really useful to
> *not* use thin provisioning for the underlying file system, but to use
> thin provisioned snapshots.  That way we only pay the thinp
> performance penalty for the snapshots, and not for normal file system
> operations.  This is something that would be very useful both for ext4
> and xfs.
> 
> I talked to Alasdair about this a few months ago at the Collab Summit,
> and I think it's doable today, but it was somewhat complicaed to set
> up.  I don't recall the details now, but perhaps someone who's more
> familiar device mapper could outline the details, and perhaps we can
> either simplify it or abstract it away in a convenient front-end
> script?

like ssm for example ? :)

Yes this would definitely help and I think there are actually more
possible optimization like this.

If we "cripple" the dm-thin so that only snapshot feature is
provided, but the actual thinp feature is not used. It would
definitely help the performance for those who are only interested in
snapshots. You'll still have your file system layout mixed up once
you start using snapshot, but it'll be definitely better. Also some
king of fs/dm interface for optimizing the layout might helpful as
well.

The other thing which could be done is to still enable to utilize
thinp feature, but try to keep file systems on the dm-thin relatively
separated and contiguous (although probably not in it's entire size).
It would certainly work only to some thin pool utilization threshold,
but it is something. Also if we can add some fs related optimization
to try not to span entire file system but rather utilize smaller parts
first (alter the block allocator so it does not allocate blocks from
random groups from entire fs but rather have smaller block group
working set at start), this can be even more useful.

-Lukas

> 
> 						- Ted
> 
--571144193-1142892503-1340116630=:2241
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--571144193-1142892503-1340116630=:2241--
