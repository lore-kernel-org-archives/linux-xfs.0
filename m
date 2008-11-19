Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJFV7ER020756 for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 09:31:07 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FA8815A1430
	for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 07:31:05 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id Qvc5FD2mf7flIDyy for <xfs@oss.sgi.com>;
	Wed, 19 Nov 2008 07:31:05 -0800 (PST)
Message-ID: <49243119.2000905@sandeen.net>
Date: Wed, 19 Nov 2008 09:30:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch 09/11] Hook up compat XFS_IOC_ATTRMULTI_BY_HANDLE ioctl
	handler
References: <20081119044401.573365619@sandeen.net>
	<20081119044910.147769242@sandeen.net>
	<20081119151628.GI13050@infradead.org>
In-Reply-To: <20081119151628.GI13050@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Nov 18, 2008 at 10:44:10PM -0600, sandeen@sandeen.net wrote:
>> +extern int
>> +xfs_attrmulti_attr_get(struct inode *, char *, char __user *,
>> +		       __uint32_t *, __uint32_t);
>> +extern int
>> +xfs_attrmulti_attr_set(struct inode *, char *, const char __user *,
>> +		      __uint32_t, __uint32_t);
>> +extern int
>> +xfs_attrmulti_attr_remove(struct inode *, char *, __uint32_t);
> 
> These should be in a header.

ah good point.

>> +	if (copy_from_user(&am_hreq, arg, sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
>> +		return -XFS_ERROR(EFAULT);
>> +
>> +	error = xfs_vget_fsop_handlereq_compat(mp, parinode, &am_hreq.hreq, &inode);
> 
> Far too long lines, please break them up after 80 chars.
> 
> Looks good even if the duplication is rather sad..
> 

yeah, I don't like it.  We could refactor stuff, but I'm also just
trying to get to something that works right now... :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
