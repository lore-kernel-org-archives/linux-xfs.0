Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8AC1B7CA2
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 09:48:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16AC0AC002
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 07:48:05 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id J8S95Gu914820GTo (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 Jun 2016 07:48:03 -0700 (PDT)
Date: Wed, 15 Jun 2016 07:48:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/12] NFS: Do not serialise O_DIRECT reads and writes
Message-ID: <20160615144801.GB18524@infradead.org>
References: <1465931115-30784-3-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-4-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-5-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-6-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-7-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-8-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-9-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-10-git-send-email-trond.myklebust@primarydata.com>
	<20160615071343.GC4318@infradead.org>
	<755A2A14-C6A9-4737-8335-0A6785490F6D@primarydata.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <755A2A14-C6A9-4737-8335-0A6785490F6D@primarydata.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Jun 15, 2016 at 02:29:42PM +0000, Trond Myklebust wrote:
> The locking is actually simpler than XFS.

It looks way more complicated.  And totally undocumented.

> We have 2 I/O modes: buffered I/O and direct I/O. The write lock is there to ensure safe transitions between those 2 modes, but once the mode is set,
> we _only_ use shared locks in order to allow parallelism.

>From reading the patch that's not what actually happens - I think you're
still taking i_rwsem exclusive for buffered writes, aren't you?

Doing that is absolutely mandatory for Posix atomicy requirements, or
you'll break tons of of applications.

But XFS allows full parallelism for direct reads and writes as long
as there is no more pagecache to flush.  But if you have pages in
the pagecache you need the exclusive lock to prevent against new
pagecache pages being added.

> >The nice thing is than in 4.7-rc i_mutex has been replaced with a
> >rw_mutex so you can just use that in shared mode for direct I/O
> >as-is without needing any new lock.
> 
> We would end up serialising reads and writes, since the latter grab an
> exclusive lock in generic_file_write(). Why do that if we don???t have to?

Looks at the XFS code - no serialization between direct reads and writes
as long as no buffered I/O came in inbetween.

And don't use generic_file_{read,write}_iter if you want to do direct I/O,
unfortunately locking in mm/filemap.c is totally screwed for direct I/O,
take a look at XFS which is where direct I/O came from and where we get
the locking right.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
