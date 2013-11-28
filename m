Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D7EA7F53
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 04:44:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64A9E8F8065
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 02:44:33 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9dcdWrIbw9j7qHhJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 02:44:32 -0800 (PST)
Date: Thu, 28 Nov 2013 02:44:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/3] xfs: fix false assertion at
	xfs_qm_vop_create_dqattach
Message-ID: <20131128104432.GF26927@infradead.org>
References: <5294A46E.1070303@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5294A46E.1070303@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Nov 26, 2013 at 09:38:54PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> After the previous fix, there still has another ASSERT failure if turning
> off any type of quota while fsstress is running at the same time.
> 
> Backtrace in this case:
> 
> [   50.867897] XFS: Assertion failed: XFS_IS_GQUOTA_ON(mp), file: fs/xfs/xfs_qm.c, line: 2118
> [   50.867924] ------------[ cut here ]------------
> ... <snip>
> [   50.867957] Kernel BUG at ffffffffa0b55a32 [verbose debug info unavailable]
> [   50.867999] invalid opcode: 0000 [#1] SMP
> [   50.869407] Call Trace:
> [   50.869446]  [<ffffffffa0bc408a>] xfs_qm_vop_create_dqattach+0x19a/0x2d0 [xfs]
> [   50.869512]  [<ffffffffa0b9cc45>] xfs_create+0x5c5/0x6a0 [xfs]
> [   50.869564]  [<ffffffffa0b5307c>] xfs_vn_mknod+0xac/0x1d0 [xfs]
> [   50.869615]  [<ffffffffa0b531d6>] xfs_vn_mkdir+0x16/0x20 [xfs]
> [   50.869655]  [<ffffffff811becd5>] vfs_mkdir+0x95/0x130
> [   50.869689]  [<ffffffff811bf63a>] SyS_mkdirat+0xaa/0xe0
> [   50.869723]  [<ffffffff811bf689>] SyS_mkdir+0x19/0x20
> [   50.869757]  [<ffffffff8170f7dd>] system_call_fastpath+0x1a/0x1f
> [   50.869793] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 <snip>
> [   50.870003] RIP  [<ffffffffa0b55a32>] assfail+0x22/0x30 [xfs]
> [   50.870050]  RSP <ffff88002941fd60>
> [   50.879251] ---[ end trace c93a2b342341c65b ]---
> 
> We're hitting the ASSERT(XFS_IS_*QUOTA_ON(mp)) in xfs_qm_vop_create_dqattach(),
> however the assertion itself is not right IMHO.  While performing quota off, we
> firstly clear the XFS_*QUOTA_ACTIVE bit(s) from struct xfs_mount without taking
> any special locks, see xfs_qm_scall_quotaoff().  Hence there is no guarantee
> that the desired quota is still active.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
