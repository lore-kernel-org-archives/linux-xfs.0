Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9EAAC7F63
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 09:24:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10DE8AC00B
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 07:24:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id I8hfrfteL6GyQf2r for <xfs@oss.sgi.com>;
	Wed, 07 Oct 2015 07:24:16 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E967065672F8
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 09:24:15 -0500 (CDT)
Subject: Re: Question about non asynchronous aio calls.
References: <20151007141833.GB11716@scylladb.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56152B0F.2040809@sandeen.net>
Date: Wed, 7 Oct 2015 09:24:15 -0500
MIME-Version: 1.0
In-Reply-To: <20151007141833.GB11716@scylladb.com>
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
To: xfs@oss.sgi.com



On 10/7/15 9:18 AM, Gleb Natapov wrote:
> Hello XFS developers,
> 
> We are working on scylladb[1] database which is written using seastar[2]
> - highly asynchronous C++ framework. The code uses aio heavily: no
> synchronous operation is allowed at all by the framework otherwise
> performance drops drastically. We noticed that the only mainstream FS
> in Linux that takes aio seriously is XFS. So let me start by thanking
> you guys for the great work! But unfortunately we also noticed that
> sometimes io_submit() is executed synchronously even on XFS.
> 
> Looking at the code I see two cases when this is happening: unaligned
> IO and write past EOF. It looks like we hit both. For the first one we
> make special afford to never issue unaligned IO and we use XFS_IOC_DIOINFO
> to figure out what alignment should be, but it does not help. Looking at the
> code though xfs_file_dio_aio_write() checks alignment against m_blockmask which
> is set to be sbp->sb_blocksize - 1, so aio expects buffer to be aligned to
> filesystem block size not values that DIOINFO returns. Is it intentional? How
> should our code know what it should align buffers to?

        /* "unaligned" here means not aligned to a filesystem block */
        if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
                unaligned_io = 1;

It should be aligned to the filesystem block size.

> Second one is harder. We do need to write past the end of a file, actually
> most of our writes are like that, so it would have been great for XFS to
> handle this case asynchronously.

You didn't say what kernel you're on, but these:

9862f62 xfs: allow appending aio writes
7b7a866 direct-io: Implement generic deferred AIO completions

hit kernel v3.15.

However, we had a bug report about this, and Brian has sent a fix
which has not yet been merged, see:

[PATCH 1/2] xfs: always drain dio before extending aio write submission

on this list last week.

With those 3 patches, things should just work for you I think.

-Eric

> Currently we are working to work around
> this by issuing truncate() (or fallocate()) on another thread and doing
> aio on a main thread only after truncate() is complete. It seams to be
> working, but is it guarantied that a thread issuing aio will never sleep
> in this case (may be new file size value needs to hit the disk and it is
> not guarantied that it will happen after truncate() returns, but before
> aio call)?
> 
> [2] http://www.scylladb.com/
> [1] http://www.seastar-project.org/
> 
> Thanks,
> 
> --
> 			Gleb.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
