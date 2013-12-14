Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C7347F52
	for <xfs@oss.sgi.com>; Sat, 14 Dec 2013 05:20:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87743304039
	for <xfs@oss.sgi.com>; Sat, 14 Dec 2013 03:20:52 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id L85MHRoESlQMT6As (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 14 Dec 2013 03:20:51 -0800 (PST)
Message-ID: <52AC3EF1.6090106@oracle.com>
Date: Sat, 14 Dec 2013 19:20:17 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfs: factor prid related codes into
	xfs_get_initial_prid()
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-2-git-send-email-zwu.kernel@gmail.com>
	<20131213163211.GD20803@infradead.org>
In-Reply-To: <20131213163211.GD20803@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 12/14 2013 00:32 AM, Christoph Hellwig wrote:
>> +static inline prid_t xfs_get_initial_prid(struct xfs_inode *dp)
>> +{
>> +	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
>> +		return xfs_get_projid(dp);
>> +	else
>> +		return XFS_PROJID_DEFAULT;
>> +}
> 
> You could skip the else here.
Except that, I'd suggest we move this helper to proper header file with
further refactoring in xfs_symlink(), and it could be a separate patch.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
