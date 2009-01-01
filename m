Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01N4f01002245 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 17:04:42 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D5B51BF8588
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 15:04:40 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id YyPtXvnOavZtUE7a for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 15:04:40 -0800 (PST)
Message-ID: <495D4C07.5050903@sandeen.net>
Date: Thu, 01 Jan 2009 17:04:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] remove flags param from xfs_free_eofblocks
References: <495D478B.9080702@sandeen.net>
	<20090101225717.GE7510@infradead.org>
	<20090101230354.GF7510@infradead.org>
In-Reply-To: <20090101230354.GF7510@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Jan 01, 2009 at 05:57:17PM -0500, Christoph Hellwig wrote:
>> On Thu, Jan 01, 2009 at 04:45:31PM -0600, Eric Sandeen wrote:
>>> Remove unused XFS_FREE_EOF_NOLOCK and make XFS_FREE_EOF_LOCK default.
>>>
>>> XFS_FREE_EOF_NOLOCK is never used, so remove it, make
>>> XFS_FREE_EOF_LOCK the only behavior, and remove the
>>> flags parameters.
>> Looks good to me.  
> 
> Actually it's used by dmapi, so we have to keep it.  Would be nice if
> we actually had some uptodate tree with dmapi, though..
> 

yep I had the wrong tree :(  sorry for the noise.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
