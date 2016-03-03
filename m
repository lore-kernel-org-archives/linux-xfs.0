Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A43167CA1
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 15:32:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5665C8F8035
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 13:32:49 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aryGV49sPH6zFEHL for <xfs@oss.sgi.com>;
	Thu, 03 Mar 2016 13:32:43 -0800 (PST)
Date: Fri, 4 Mar 2016 08:31:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs resize: primary superblock is not updated immediately
Message-ID: <20160303213108.GQ30721@dastard>
References: <3685DFAD20214109878873CF81232704@alyakaslap>
	<20160222212019.GI25832@dastard>
	<CAOcd+r1XY2kcp+qJ=mPOAQSmb90QUnLfmT3-FkMjQN_+Ejmt8A@mail.gmail.com>
	<20160222235628.GK25832@dastard>
	<D5578D3E98EE48B88EA9A1126B671155@alyakaslap>
	<20160223225926.GN25832@dastard>
	<BC0CC25E00CE4CEDA1FFDFC0A2F38742@alyakaslap>
	<20160229211628.GK29057@dastard> <20160301072011.GF30721@dastard>
	<E965894DE8D542788CCE98F72C218C05@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E965894DE8D542788CCE98F72C218C05@alyakaslap>
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

On Thu, Mar 03, 2016 at 11:18:43AM +0200, Alex Lyakas wrote:
> Hello Dave,
> Thanks for the patch! I confirm that it fixes the scenario.
> 
> At [1] please find all the blknos that are being used during the log
> recovery (if that's of any interest).
....
> Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.129739]
> _xfs_buf_find: blkno=200705 eofs=204800 >m_sb.sb_dblocks=25600
> Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.129746]
> _xfs_buf_find: blkno=200705 eofs=204800 >m_sb.sb_dblocks=25600

Where is the warning that this block is out of range?

And why didn't recovery fail at this point because the block
requested is out of range and so the buffer lookup should have
failed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
