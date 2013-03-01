Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD2BE7FD5
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 14:53:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A1B68F8035
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 12:53:08 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CTvy1TkoLLWT3RBc for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 12:53:07 -0800 (PST)
Date: Sat, 2 Mar 2013 07:53:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfaults
Message-ID: <20130301205305.GD23616@dastard>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<20130301111701.GB23616@dastard>
	<CANU9nTkkEd61UsM+KngGzMzXVXdOa2oXOPtmqN4xGaPuEBN_nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANU9nTkkEd61UsM+KngGzMzXVXdOa2oXOPtmqN4xGaPuEBN_nQ@mail.gmail.com>
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
To: Ole Tange <tange@binf.ku.dk>
Cc: xfs@oss.sgi.com

On Fri, Mar 01, 2013 at 01:24:36PM +0100, Ole Tange wrote:
> On Fri, Mar 1, 2013 at 12:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Feb 28, 2013 at 04:22:08PM +0100, Ole Tange wrote:
> :
> >> I forced a RAID online. I have done that before and xfs_repair
> >> normally removes the last hour of data or so, but saves everything
> >> else.
> >
> > Why did you need to force it online?
> 
> More than 2 harddisks went offline. We have seen that before and it is
> not due to bad harddisks. It may be due to driver/timings/controller.

I thought that might be the case. What filesystem errors occurred
when the srives went offline?

> >> /usr/local/src/xfsprogs-3.1.10/repair# ./xfs_repair -n /dev/md5p1
> >> Phase 1 - find and verify superblock...
> >> Phase 2 - using internal log
> >>         - scan filesystem freespace and inode maps...
> >> flfirst 232 in agf 91 too large (max = 128)
> >
> > Can you run:
> >
> > # xfs_db -c "agf 91" -c p /dev/md5p1
> >
> > And post the output?
> 
> # xfs_db -c "agf 91" -c p /dev/md5p1
> xfs_db: cannot init perag data (117)

Interesting. It's detecting corrupt AG headers.

> magicnum = 0x58414746
> versionnum = 1
> seqno = 91
> length = 268435200
> bnoroot = 295199
> cntroot = 13451007
> bnolevel = 2
> cntlevel = 2
> flfirst = 232
> fllast = 32
> flcount = 191

That implies that the free list is actually 232+191-32 = 391
entries long. That doesn't add up any way I look at it. both the
flfirst and flcount fields look wrong here, which rules out a simple
bit error as the problem. I can't see how these values would have
been written by XFS as they are out of range for 512 byte sector
AGFL:

        be32_add_cpu(&agf->agf_flfirst, 1);
        xfs_trans_brelse(tp, agflbp);
        if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
                agf->agf_flfirst = 0;

So I suspect that something more than just disks going off line here
went wrong here, as I've never seen this sort of corruption before...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
