Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D9C3C7FC4
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 16:33:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8DE6304053
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 14:33:56 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rysCdDvJL2HdF5bj for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 14:33:50 -0800 (PST)
Date: Fri, 30 Jan 2015 09:32:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question about one example in section 3.2.3 of "XFS Filesystem
	Structure"
Message-ID: <20150129223249.GB6282@dastard>
References: <tencent_42169E2221E1D724084C7345@qq.com>
	<20150129132023.GA44129@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150129132023.GA44129@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Wang Sheng-Hui <shhuiw@foxmail.com>, xfs <xfs@oss.sgi.com>

On Thu, Jan 29, 2015 at 08:20:24AM -0500, Brian Foster wrote:
> On Thu, Jan 29, 2015 at 06:39:51PM +0800, Wang Sheng-Hui wrote:
> > Dear,
> > 
> > I'm reading "XFS Filesystem Structure" from the link 
> >              http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html
> > and confused by one example in section 3.2.3:
> >              http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/AG_Free_List.html
> > ---------------------------------------------------------------------------
> > xfs_db> fsblock 7
> > xfs_db> type bnobt
> > xfs_db> p
> > magic = 0x41425442
> > level = 1
> > numrecs = 4
> > leftsib = null
> > rightsib = null
> > keys[1-4] = [startblock,blockcount]
> >            1:[12,16] 2:[184586,3] 3:[225579,1] 4:[511629,1]
> > ptrs[1-4] = 1:2 2:83347 3:6 4:4
> > 
> > Blocks 2, 83347, 6 and 4 contain the leaves for the free space B+tree by starting block. Block 2 would contain offsets 16 up to but not including 184586 while block 4 would have all offsets from 511629 to the end of the AG. 
> > ---------------------------------------------------------------------------
> > 
> > I have thought block 2 contains offsets start from 12, and it will cover 16 free blocks.
> > I wonder why block 2 contains offsets start at 16, instead of 12 here?
> > 
> 
> The text above looks like a typo to me. I believe the
> [startblock,blockcount] shown in each higher level block of the btree
> (e.g., level > 0) represents the first record available in the
> associated block pointed at by 'ptr' (the next level down).
> 
> The above should say that block 2 contains offsets "12 up to but not
> including 184586 ..." and so on. I'm not really sure what the process is
> with these docs and where the source lies vs. what content is generated.
> I thought Dave had done something a while back with intent to try and
> organize docs but the details escape me... perhaps he can chime in on
> if/how this can be edited, if you're willing to post a fix. ;)

I have an ascii-doc converted version of this document that I want
to become the master source for this published document in this
git tree:

git://oss.sgi.com/xfs/xfs-documentation.git

Patches to fix the documentation, or converting any of the other XFS
documentation to asciidoc format (including man pages, xml, stuff,
the faq page on the Wiki, etc) should be made against this
repository and sent to the list.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
