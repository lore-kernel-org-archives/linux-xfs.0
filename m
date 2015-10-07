Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CBAAC7F63
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 09:18:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F69E304048
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 07:18:39 -0700 (PDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	7r3wVwaMgKQ1aHTC (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 07:18:36 -0700 (PDT)
Received: by wiclk2 with SMTP id lk2so30924375wic.1
	for <xfs@oss.sgi.com>; Wed, 07 Oct 2015 07:18:35 -0700 (PDT)
Date: Wed, 7 Oct 2015 17:18:33 +0300
From: Gleb Natapov <gleb@scylladb.com>
Subject: Question about non asynchronous aio calls.
Message-ID: <20151007141833.GB11716@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Cc: avi@scylladb.com, glauber@scylladb.com

Hello XFS developers,

We are working on scylladb[1] database which is written using seastar[2]
- highly asynchronous C++ framework. The code uses aio heavily: no
synchronous operation is allowed at all by the framework otherwise
performance drops drastically. We noticed that the only mainstream FS
in Linux that takes aio seriously is XFS. So let me start by thanking
you guys for the great work! But unfortunately we also noticed that
sometimes io_submit() is executed synchronously even on XFS.

Looking at the code I see two cases when this is happening: unaligned
IO and write past EOF. It looks like we hit both. For the first one we
make special afford to never issue unaligned IO and we use XFS_IOC_DIOINFO
to figure out what alignment should be, but it does not help. Looking at the
code though xfs_file_dio_aio_write() checks alignment against m_blockmask which
is set to be sbp->sb_blocksize - 1, so aio expects buffer to be aligned to
filesystem block size not values that DIOINFO returns. Is it intentional? How
should our code know what it should align buffers to?

Second one is harder. We do need to write past the end of a file, actually
most of our writes are like that, so it would have been great for XFS to
handle this case asynchronously. Currently we are working to work around
this by issuing truncate() (or fallocate()) on another thread and doing
aio on a main thread only after truncate() is complete. It seams to be
working, but is it guarantied that a thread issuing aio will never sleep
in this case (may be new file size value needs to hit the disk and it is
not guarantied that it will happen after truncate() returns, but before
aio call)?

[2] http://www.scylladb.com/
[1] http://www.seastar-project.org/

Thanks,

--
			Gleb.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
