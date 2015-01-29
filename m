Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 479CE7F54
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:20:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D59FAAC003
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:20:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SLa6GB6OgHCyat3q (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 05:20:33 -0800 (PST)
Date: Thu, 29 Jan 2015 08:20:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: question about one example in section 3.2.3 of "XFS Filesystem
	Structure"
Message-ID: <20150129132023.GA44129@bfoster.bfoster>
References: <tencent_42169E2221E1D724084C7345@qq.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <tencent_42169E2221E1D724084C7345@qq.com>
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
To: Wang Sheng-Hui <shhuiw@foxmail.com>
Cc: xfs <xfs@oss.sgi.com>

On Thu, Jan 29, 2015 at 06:39:51PM +0800, Wang Sheng-Hui wrote:
> Dear,
> 
> I'm reading "XFS Filesystem Structure" from the link 
>              http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html
> and confused by one example in section 3.2.3:
>              http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/AG_Free_List.html
> ---------------------------------------------------------------------------
> xfs_db> fsblock 7
> xfs_db> type bnobt
> xfs_db> p
> magic = 0x41425442
> level = 1
> numrecs = 4
> leftsib = null
> rightsib = null
> keys[1-4] = [startblock,blockcount]
>            1:[12,16] 2:[184586,3] 3:[225579,1] 4:[511629,1]
> ptrs[1-4] = 1:2 2:83347 3:6 4:4
> 
> Blocks 2, 83347, 6 and 4 contain the leaves for the free space B+tree by starting block. Block 2 would contain offsets 16 up to but not including 184586 while block 4 would have all offsets from 511629 to the end of the AG. 
> ---------------------------------------------------------------------------
> 
> I have thought block 2 contains offsets start from 12, and it will cover 16 free blocks.
> I wonder why block 2 contains offsets start at 16, instead of 12 here?
> 

The text above looks like a typo to me. I believe the
[startblock,blockcount] shown in each higher level block of the btree
(e.g., level > 0) represents the first record available in the
associated block pointed at by 'ptr' (the next level down).

The above should say that block 2 contains offsets "12 up to but not
including 184586 ..." and so on. I'm not really sure what the process is
with these docs and where the source lies vs. what content is generated.
I thought Dave had done something a while back with intent to try and
organize docs but the details escape me... perhaps he can chime in on
if/how this can be edited, if you're willing to post a fix. ;)

Brian

> Anyone help give out some explanation, please?
> 
> Regards,
> Wang Sheng-Hui
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
