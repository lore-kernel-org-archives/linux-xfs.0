Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47D5B7CA0
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 15:16:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1A7758F8033
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 13:16:35 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	eejH755o6TuWe2dp for <xfs@oss.sgi.com>;
	Mon, 29 Feb 2016 13:16:31 -0800 (PST)
Date: Tue, 1 Mar 2016 08:16:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs resize: primary superblock is not updated immediately
Message-ID: <20160229211628.GK29057@dastard>
References: <3685DFAD20214109878873CF81232704@alyakaslap>
	<20160222212019.GI25832@dastard>
	<CAOcd+r1XY2kcp+qJ=mPOAQSmb90QUnLfmT3-FkMjQN_+Ejmt8A@mail.gmail.com>
	<20160222235628.GK25832@dastard>
	<D5578D3E98EE48B88EA9A1126B671155@alyakaslap>
	<20160223225926.GN25832@dastard>
	<BC0CC25E00CE4CEDA1FFDFC0A2F38742@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BC0CC25E00CE4CEDA1FFDFC0A2F38742@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Christoph Hellwig <hch@infradead.org>, Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com

On Mon, Feb 29, 2016 at 11:47:54AM +0200, Alex Lyakas wrote:
> Hello Dave,
> I have tried the same scenario with the 4.5 kernel from about a week
> ago, latest commit being [1].
> The same crash is happening, stack trace being [2].
> 
> I am not proficient with xfstests, unfortunately. I tried running
> them several times, but I am not sure I was doing that properly.
> 
> As for your question why the "block beyond end of the filesystem
> fails". I tried to debug it further and added a print into
> _xfs_buf_find. What happens is that at some point, the sb_dblocks
> value is updated to the new value, but the in-memory pag object is
> not created. So the test:
> 
> eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
> if (blkno < 0 || blkno >= eofs) {
> ...
> 
> still holds, but the needed pag does not exist.
> 
> Here are the results of the prints that I added:
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.546542] SGI XFS with
> ACLs, security attributes, realtime, no debug enabled
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.551243] XFS (dm-0):
> Mounting V4 Filesystem
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.576677] XFS (dm-0):
> Starting recovery (logdev: internal)
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.577866]
> _xfs_buf_find: blkno=0 eofs=200704 >m_sb.sb_dblocks=25088
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.577872]
> _xfs_buf_find: blkno=0 eofs=200704 >m_sb.sb_dblocks=25088
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.577882]
> _xfs_buf_find: blkno=0 eofs=200704 >m_sb.sb_dblocks=25088
> ===> Here we start seeing the new value of "sb_dblocks" and hence
> the new value of "eofs":

We shouldn't see sb_dblocks change until log recovery completes the
first phase of log recovery and the in-core superblock is re-read
from disk in xlog_do_recover().

> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.606796]
> _xfs_buf_find: blkno=1 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.606804]
> _xfs_buf_find: blkno=1 eofs=204800 >m_sb.sb_dblocks=25600

looking up AGF 0.

> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.606988]
> _xfs_buf_find: blkno=2 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.606991]
> _xfs_buf_find: blkno=2 eofs=204800 >m_sb.sb_dblocks=25600

Now AGI 0.

> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607205]
> _xfs_buf_find: blkno=50177 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607210]
> _xfs_buf_find: blkno=50177 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607375]
> _xfs_buf_find: blkno=50178 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607378]
> _xfs_buf_find: blkno=50178 eofs=204800 >m_sb.sb_dblocks=25600

AGF/AGI 1.

> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607512]
> _xfs_buf_find: blkno=100353 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607515]
> _xfs_buf_find: blkno=100353 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607652]
> _xfs_buf_find: blkno=100354 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607655]
> _xfs_buf_find: blkno=100354 eofs=204800 >m_sb.sb_dblocks=25600

AGF/AGI 2.

> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607829]
> _xfs_buf_find: blkno=150529 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607832]
> _xfs_buf_find: blkno=150529 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607980]
> _xfs_buf_find: blkno=150530 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607982]
> _xfs_buf_find: blkno=150530 eofs=204800 >m_sb.sb_dblocks=25600
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.608073]

AGF/AGI 4.

> _xfs_buf_find: blkno=200705 eofs=204800 >m_sb.sb_dblocks=25600
> ===> and here we crash, but as you see, blkno is valid WRT eofs value.
> Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.608120] BUG: unable
> to handle kernel NULL pointer dereference at 0000000000000098

AGF 5 goes splat.

Which means it's through the first phase of log recovery and it's
not failing in log recovery. i.e. we are now running
xfs_initialize_perag_data() after log recovery. So, as I said a
couple of posts back up this thread:

| If log recovery succeeds, then yes, I can see that there is a
| problem here because the per-ag tree is not reinitialised after
| the superblock is re-read. That's a pretty easy fix, though (3-4
| lines of code in xlog_do_recover() to detect a change in
| filesystem block count and call xfs_initialize_perag() again..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
