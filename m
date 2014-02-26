Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14C3F7F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 20:07:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A48C3AC002
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 18:07:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id mjaD0gWDAldqGpBW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 18:07:37 -0800 (PST)
Date: Tue, 25 Feb 2014 18:07:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_copy: accept XFS_ABTB_CRC_MAGIC
Message-ID: <20140226020737.GA21877@infradead.org>
References: <530D4B68.9090905@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530D4B68.9090905@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 25, 2014 at 08:03:20PM -0600, Eric Sandeen wrote:
> xfs_copy needs a fair bit of work for CRCs because it rewrites
> UUIDs by default, but this change will get it working properly
> with the "-d" (duplicate) option which keeps the same UUID.

I don't think ASSERTs for user supplied data are a good idea, this
should be some real error handling.

> However, I wonder if we should fail CRC filesystems outright
> for now if -d isn't specified, because it will invalidate every
> CRC and generally make a mess of things...

Yeah, for now it probably should be rejected.

It would also be useful to have a list of such issues in an README.v5
or TODO.v5 file in the xfsprogs tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
