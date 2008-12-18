Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBI9tIOM012569 for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 03:55:19 -0600
Received: from qb-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCC8B2F0CA
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 01:55:17 -0800 (PST)
Received: from qb-out-1314.google.com (qb-out-1314.google.com [72.14.204.168])
	by cuda.sgi.com with ESMTP id S1fMMNPUBQBOTdJT for
	<xfs@oss.sgi.com>; Thu, 18 Dec 2008 01:55:17 -0800 (PST)
Received: by qb-out-1314.google.com with SMTP id e19so187810qba.8
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 01:55:17 -0800 (PST)
Message-ID: <494A1DE3.5090203@ankitjain.org>
Date: Thu, 18 Dec 2008 15:24:43 +0530
From: Ankit Jain <me@ankitjain.org>
MIME-Version: 1.0
Subject: Re: [PATCH][RFC] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
References: <49460F88.2080408@ankitjain.org>
	<9D2593C9-08EB-486C-AAF5-E83A1EAEE9B9@sgi.com>
In-Reply-To: <9D2593C9-08EB-486C-AAF5-E83A1EAEE9B9@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Felix Blyakher wrote:
> 
>> This patch adds ioctls to vfs for compatibility with legacy XFS
>> pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
>> effectively invokes sys_fallocate for the new ioctls.
> 
> I don't think we can use sys_fallocate for XFS_IOC_UNRESVSP*
> commands, which suppose to release currently allocated file
> blocks.
> See more comments below.

My bad :( I'll drop the *UNRESV* completely from the new ioctl and
post an updated patch.

-Ankit

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
