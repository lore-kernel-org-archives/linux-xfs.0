Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F32C87CA2
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 04:12:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C65BD8F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 02:12:47 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Tg1wNV6NITmBzMue (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 02:12:44 -0700 (PDT)
Date: Thu, 16 Jun 2016 02:12:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/12] NFS: Do not serialise O_DIRECT reads and writes
Message-ID: <20160616091241.GA15953@infradead.org>
References: <1465931115-30784-9-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-10-git-send-email-trond.myklebust@primarydata.com>
	<20160615071343.GC4318@infradead.org>
	<755A2A14-C6A9-4737-8335-0A6785490F6D@primarydata.com>
	<20160615144801.GB18524@infradead.org>
	<C13D01C1-4B83-442A-A0EA-D7624BE8A782@primarydata.com>
	<20160615145638.GC5297@infradead.org>
	<02DCF6B5-AFDF-4E33-A8F2-DBFE67A87E91@primarydata.com>
	<20160615151422.GA28557@infradead.org>
	<E6003989-FB5F-4FE8-A161-C6E52E031091@primarydata.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E6003989-FB5F-4FE8-A161-C6E52E031091@primarydata.com>
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
To: Trond Myklebust <trondmy@primarydata.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jun 15, 2016 at 03:45:37PM +0000, Trond Myklebust wrote:
> Serialisation is not mandatory in POSIX:
> 
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html
> 
> ???Writes can be serialized with respect to other reads and writes. If a read() of file data can be proven (by any means) to occur after a write() of the data, it must reflect that write(), even if the calls are made by different processes. A similar requirement applies to multiple write operations to the same file position. This is needed to guarantee the propagation of data from write() calls to subsequent read() calls. This requirement is particularly significant for networked file systems, where some caching schemes violate these semantics.???

That is the basic defintion, but once O_DSYNC and friends come into
play it gets more complicated:

>From http://pubs.opengroup.org/onlinepubs/9699919799/functions/read.html:

    [SIO] [Option Start] If the O_DSYNC and O_RSYNC bits have been set,
    read I/O operations on the file descriptor shall complete as defined
    by synchronized I/O data integrity completion. If the O_SYNC and
    O_RSYNC bits have been set, read I/O operations on the file descriptor
    shall complete as defined by synchronized I/O file integrity completion.
    [Option End]

Which directs to:
http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html:

     3.378 Synchronized I/O Data Integrity Completion

     For read, when the operation has been completed or diagnosed if
     unsuccessful. The read is complete only when an image of the data
     has been successfully transferred to the requesting process. If
     there were any pending write requests affecting the data to be read
     at the time that the synchronized read operation was requested,
     these write requests are successfully transferred prior to reading
     the data.

     For write, when the operation has been completed or diagnosed if
     unsuccessful. The write is complete only when the data specified in
     the write request is successfully transferred and all file system
     information required to retrieve the data is successfully
     transferred.

     File attributes that are not necessary for data retrieval (access
     time, modification time, status change time) need not be
     successfully transferred prior to returning to the calling process.

While we'll never see O_RSYNC in the kernel glibc treats it as just
O_SYNC.  Either way - I'd be much happier if we could come up with
less different ways to do read/write exclusion rather than more..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
