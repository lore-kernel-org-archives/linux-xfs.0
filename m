Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 097737CA6
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 10:14:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D023F30404E
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 08:14:25 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id yS5Y8cqSRosJBcxs (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 Jun 2016 08:14:24 -0700 (PDT)
Date: Wed, 15 Jun 2016 08:14:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/12] NFS: Do not serialise O_DIRECT reads and writes
Message-ID: <20160615151422.GA28557@infradead.org>
References: <1465931115-30784-7-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-8-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-9-git-send-email-trond.myklebust@primarydata.com>
	<1465931115-30784-10-git-send-email-trond.myklebust@primarydata.com>
	<20160615071343.GC4318@infradead.org>
	<755A2A14-C6A9-4737-8335-0A6785490F6D@primarydata.com>
	<20160615144801.GB18524@infradead.org>
	<C13D01C1-4B83-442A-A0EA-D7624BE8A782@primarydata.com>
	<20160615145638.GC5297@infradead.org>
	<02DCF6B5-AFDF-4E33-A8F2-DBFE67A87E91@primarydata.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <02DCF6B5-AFDF-4E33-A8F2-DBFE67A87E91@primarydata.com>
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

On Wed, Jun 15, 2016 at 03:09:23PM +0000, Trond Myklebust wrote:
> As I said earlier, the problem with that is you end up artificially serialising buffered reads and buffered writes.

If you actually want to be Posix compiant you need to serialize buffered
reads against buffererd writes - it's just that most Linux file systems
happen to get this wrong.

> ??? The reads only need a shared lock in order to protect the I/O mode from flipping to O_DIRECT (and relying on page locks to protect against buffered writes).

Which strictly speaking is not enough, although as said above most
Linux filesystems get this wrong.  If you indeed want to keep that
(incorrect) behavior you need another lock.  It's defintively not
"simpler", though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
