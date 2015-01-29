Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3AC57F47
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 04:40:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A13A18F8052
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 02:40:25 -0800 (PST)
Received: from smtpbg334.qq.com (smtpbg334.qq.com [14.17.43.229]) by
	cuda.sgi.com with ESMTP id N9vxGkW7D9RpZDAW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 02:40:22 -0800 (PST)
From: "=?ISO-8859-1?B?V2FuZyBTaGVuZy1IdWk=?=" <shhuiw@foxmail.com>
Subject: question about one example in section 3.2.3 of "XFS Filesystem
	Structure"
Mime-Version: 1.0
Date: Thu, 29 Jan 2015 18:39:51 +0800
Message-ID: <tencent_42169E2221E1D724084C7345@qq.com>
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
To: =?ISO-8859-1?B?eGZz?= <xfs@oss.sgi.com>

Dear,

I'm reading "XFS Filesystem Structure" from the link 
             http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html
and confused by one example in section 3.2.3:
             http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/AG_Free_List.html
---------------------------------------------------------------------------
xfs_db> fsblock 7
xfs_db> type bnobt
xfs_db> p
magic = 0x41425442
level = 1
numrecs = 4
leftsib = null
rightsib = null
keys[1-4] = [startblock,blockcount]
           1:[12,16] 2:[184586,3] 3:[225579,1] 4:[511629,1]
ptrs[1-4] = 1:2 2:83347 3:6 4:4

Blocks 2, 83347, 6 and 4 contain the leaves for the free space B+tree by starting block. Block 2 would contain offsets 16 up to but not including 184586 while block 4 would have all offsets from 511629 to the end of the AG. 
---------------------------------------------------------------------------

I have thought block 2 contains offsets start from 12, and it will cover 16 free blocks.
I wonder why block 2 contains offsets start at 16, instead of 12 here?

Anyone help give out some explanation, please?

Regards,
Wang Sheng-Hui
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
