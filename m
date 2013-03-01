Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10D1E7F63
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 16:31:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C768F8F8040
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 14:31:20 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	X9ZhtEZ6Xip9nDQy for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 14:31:18 -0800 (PST)
Date: Sat, 2 Mar 2013 09:31:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfaults
Message-ID: <20130301223116.GE23616@dastard>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<5131283F.8030704@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5131283F.8030704@sandeen.net>
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
Cc: xfs@oss.sgi.com, Ole Tange <tange@binf.ku.dk>

On Fri, Mar 01, 2013 at 04:14:23PM -0600, Eric Sandeen wrote:
> On 2/28/13 9:22 AM, Ole Tange wrote:
> > I forced a RAID online. I have done that before and xfs_repair
> > normally removes the last hour of data or so, but saves everything
> > else.
> > 
> > Today that did not work:
> > 
> > /usr/local/src/xfsprogs-3.1.10/repair# ./xfs_repair -n /dev/md5p1
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - scan filesystem freespace and inode maps...
> > flfirst 232 in agf 91 too large (max = 128)
> > Segmentation fault (core dumped)
> 
> FWIW, the fs in question seems to need a log replay, so 
> xfs_repair -n would find it in a worse state...
> I had forgotten that xfs_repair -n won't complain about
> a dirty log.  Seems like it should.
> 
> But, the log is corrupt enough that it won't replay:
> 
> XFS (loop0): Mounting Filesystem
> XFS (loop0): Starting recovery (logdev: internal)
> ffff88036e7cd800: 58 41 47 46 00 00 00 01 00 00 00 5b 0f ff ff 00  XAGF.......[....
                                                     ^^
It's detecting AGF 91 is corrupt....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
