Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA8007CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 14:40:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ADD10304039
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:40:49 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hB1HjRTdjmhbh4Zh for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 12:40:47 -0800 (PST)
Date: Tue, 16 Feb 2016 07:40:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS fiemap issue with Linux 3.10.0-327.el7.x86_64 (CentOS 7)
Message-ID: <20160215204009.GJ14668@dastard>
References: <CAJkH1p6LU=d5oLh3A+j_GQ70uoCYMjR=a5yS1w8p5d5ZXz6fwg@mail.gmail.com>
	<56C219F0.3050002@sandeen.net>
	<CAJkH1p5ZP-Wg=UgwBZKz6rZS=_5-o625HZPAosW7tt-zpaNDOg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJkH1p5ZP-Wg=UgwBZKz6rZS=_5-o625HZPAosW7tt-zpaNDOg@mail.gmail.com>
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
To: Jim Wilcoxson <prirun@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Feb 15, 2016 at 02:28:36PM -0500, Jim Wilcoxson wrote:
> Thanks Eric.
> 
> I ran xfs_bmap -v and it returned extents 0-19999, alternating data
> with holes.  The holes and data were various sizes, I suppose for xfs
> alignment reasons, but everything was there.
> 
> Running fiemap again after xfs_bmap still returned 1364 extents.

Yes, fiemap in XFS uses a buffer size of:

        bm.bmv_count = min_t(__s32, bm.bmv_count,
                             (PAGE_SIZE * 16 / sizeof(struct getbmapx)));

i.e. limits a single fiemap fetch to a maximum of 64k of extent
data.

I think you have an incorrect assumption about fiemap behaviour.
fiemap is not designed to return or even count all the extents in a
file in a single call; on XFS it returns how many extents it can
return in a single call. When you then map the file, if the
FIEMAP_EXTENT_LAST is not set on the last extent returned, then the
application needs to make another FIEMAP call from the end offset of
last extent mapping returned in the last call, and it will then
return the next N extents in the file.

IOWs, you have to keep calling FIEMAP to map the entire file, not
assume a single call will return an arbitrary amount of data to you
in a single call.

But, as Eric said - fiemap is a diagnosis tool, not an interface you
can rely on for anything involving data movement.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
