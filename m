Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0TLiPbb235241 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 15:44:26 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E805FCC780
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 13:43:43 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id Y8rRgbC1WVZUWCdZ for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2009 13:43:43 -0800 (PST)
Message-ID: <4982230A.7000405@sandeen.net>
Date: Thu, 29 Jan 2009 16:43:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_admin: exit gracefully for non-XFS fileststems
References: <20090125050342.GA30091@lst.de>
In-Reply-To: <20090125050342.GA30091@lst.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Exit gracefully if the magic number doesn't match xfs in xfs_admin
> and xfs_ncheck.  This is implemented by a new -C option to xfs_db
> which makes it exit with a useful error message in case the filesystem
> doesn't match the XFS superblock magic number.
> 
> 
> Reported-by: Dick Middleton <dick@lingbrae.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I guess I'd rather see this the reverse, and require a flag to allow
xfs_db to work on something that doesn't look like xfs - err on the side
of safety (hm but I suppose db is usually in read-only mode...)

Addresses jeffpc's criticism too, to some degree; you can use -F to mean
"force" or "foreign" :)  before xfs_db will touch the fs.

So I think I personally like it better with the inverse, where it always
exits on bad magic unless you explicitly tell it otherwise.  Making the
error message reference the option might be nice ("Use -F to ignore this
error" or somesuch)


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
