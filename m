Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0IJSaCX020763 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 13:28:36 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF61C9AC9D
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 11:28:34 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id D6r1gMTjaVzUSTH4 for
	<xfs@oss.sgi.com>; Sun, 18 Jan 2009 11:28:34 -0800 (PST)
Message-ID: <497382C0.5050406@sandeen.net>
Date: Sun, 18 Jan 2009 13:28:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: allow xfs_freeze to work on non-xfs filesystems
References: <496E6FB4.8070300@sandeen.net>
	<20090118175842.GA15675@infradead.org>
In-Reply-To: <20090118175842.GA15675@infradead.org>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Jan 14, 2009 at 05:05:24PM -0600, Eric Sandeen wrote:
>> allow xfs_freeze to freeze "foreign" filesystems
>>
>> Now that the freeze ioctl has been elevated to the VFS,
>> let's let xfs_io and xfs_freeze freeze other filesystems
>> as well - add the CMD_FOREIGN_OK flag to freeze & thaw.
>>
>> I think the worst that will happen on older kernels is that
>> the command will fail with ENOSYS or EINVAL....
> 
> Looks good to me, but I thikn you should also update the
> xfs_freeze manpage to mention that it works for non-XFS filesystems
> on 2.6.29 or newer kernels.

Ok, will do - thanks.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
