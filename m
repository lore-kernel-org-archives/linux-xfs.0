Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07BE47CA2
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 09:56:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75101AC002
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 07:56:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id pkhbDMQGGqJ5mIeI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 Jun 2016 07:56:40 -0700 (PDT)
Date: Wed, 15 Jun 2016 07:56:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/12] NFS: Do not serialise O_DIRECT reads and writes
Message-ID: <20160615145638.GC5297@infradead.org>
References: <1465931115-30784-5-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-6-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-7-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-8-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-9-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-10-git-send-email-trond.myklebust@primarydata.com>
	<20160615071343.GC4318@infradead.org>
	<755A2A14-C6A9-4737-8335-0A6785490F6D@primarydata.com>
	<20160615144801.GB18524@infradead.org>
	<C13D01C1-4B83-442A-A0EA-D7624BE8A782@primarydata.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C13D01C1-4B83-442A-A0EA-D7624BE8A782@primarydata.com>
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

On Wed, Jun 15, 2016 at 02:52:24PM +0000, Trond Myklebust wrote:
> >But XFS allows full parallelism for direct reads and writes as long
> >as there is no more pagecache to flush.  But if you have pages in
> >the pagecache you need the exclusive lock to prevent against new
> >pagecache pages being added.
> 
> Exactly. So does this.

So let's avoid bloating the inode with another rw_semaphore, and make
everyones life easier by using the existing lock.

> We don???t use generic_file_* for O_DIRECT; we only use it for buffered I/O.

I know - this was just an answer to your reference to the generic_file_*
code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
