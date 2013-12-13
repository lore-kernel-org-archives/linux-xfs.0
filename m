Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E4B67F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 15:51:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 553728F8033
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 13:51:44 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NKITxbpxwNDyoiCX for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 13:51:21 -0800 (PST)
Date: Sat, 14 Dec 2013 08:51:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xattr atomicy
Message-ID: <20131213215117.GV10988@dastard>
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

On Fri, Dec 13, 2013 at 03:56:44AM -0800, Christoph Hellwig wrote:
> On the nfsv4 list it was recently discussed how atomic / transaction
> xattr updates are.  It turns out none of that seems documented on the
> syscall level, but for XFS we have an odd inconsistancy in that attr
> updates generally are atomic and logged, except when we go out to
> remote attributes in xfs_attr_rmtval_set, in which case attr updates
> are no logged, and we do synchronous writes instead.

Yes, but they are still atomic from a user and crash recovery
point of view....

I'd been wondering a while back if we could make remote xattrs use
an ordered buffer so we don't need to log it back can leave it for
async write but still have it pin the log tail. However, I don't
think we can do that as we can't recover the attr data that is lost
if we crash. Hence I think our only option is to log it if we want
ot make it an async write.

> Besides the weird semantic difference that is impossible to explain to
> users performance will also generally be bad with a synchronous buffer
> write.  Is there any good reason to not log the buffer for the remote
> attributes? Given that attribute are limited to 64kB it's not like
> the value is larger than large directory blocks that we already
> support.

Well, I think it's a bit different to the directory block case - the
directory blocks are filesystem metadata, while xattrs contain user
data. Hence if we log user xattrs a user can consume all of the log
bandwidth writing xattrs and degrade the metadata modification
performance of the rest of the filesystem.

One issue that we'll need to deal with is that it may change the
minimum log size calculations if we add 64k of data to the attribute
transaction reservations. We currently calculate the remote attr
reservation in xfs_log_calc_max_attrsetm_res() and that will need to
change. If it pushes the remote attr reservation to be the largest
transaction reservation, we could have log size issues on existing
filesystems and that would lead to only enabling logging of remote
xattrs if the log is physically big enough.

The thing is, it's really only user data that ever ends up in a
remote attr block - system xattrs like ACLs and selinux contexts,
application xattrs from DMF, gluster, swift, Samba, etc rarely
consume enough bytes to push the xattr out of line.

So, IMO, the first question we need to answer is whether the current
behaviour is actually a problem for anyone....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
