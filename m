Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B02767F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 13:53:26 -0600 (CST)
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E3AD304043
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 11:53:17 -0800 (PST)
Date: Fri, 13 Dec 2013 13:52:46 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: xattr atomicy
Message-ID: <20131213195246.GK1935@sgi.com>
References: <20131213115644.GA28551@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213115644.GA28551@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hey Christoph,

On Fri, Dec 13, 2013 at 03:56:44AM -0800, Christoph Hellwig wrote:
> On the nfsv4 list it was recently discussed how atomic / transaction
> xattr updates are.  It turns out none of that seems documented on the
> syscall level, but for XFS we have an odd inconsistancy in that attr
> updates generally are atomic and logged, except when we go out to
> remote attributes in xfs_attr_rmtval_set, in which case attr updates
> are no logged, and we do synchronous writes instead.
> 
> Besides the weird semantic difference that is impossible to explain to
> users performance will also generally be bad with a synchronous buffer
> write.  Is there any good reason to not log the buffer for the remote
> attributes? Given that attribute are limited to 64kB it's not like
> the value is larger than large directory blocks that we already
> support.

Looks like it's just because we're concerned about the size of the transaction:

1221 STATIC int
1222 xfs_attr_node_addname(xfs_da_args_t *args)
1223 {
...
1359         /*
1360          * If there was an out-of-line value, allocate the blocks we
1361          * identified for its storage and copy the value.  This is done
1362          * after we create the attribute so that we don't overflow the
1363          * maximum size of a transaction and/or hit a deadlock.
1364          */
1365         if (args->rmtblkno > 0) {
1366                 error = xfs_attr_rmtval_set(args);
1367                 if (error)
1368                         return(error);
1369         }

I'm not clear on what the deadlock might have been.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
