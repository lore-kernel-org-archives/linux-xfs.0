Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 37A097F6B
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 01:36:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1140130404E
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:36:30 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id RMzBkWVQtELj0LK3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 23:36:28 -0700 (PDT)
Date: Tue, 15 Apr 2014 23:36:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Message-ID: <20140416063618.GA12498@infradead.org>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com, Michael Kerrisk <mtk.manpages@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Mon, Feb 17, 2014 at 04:08:17PM +0100, Lukas Czerner wrote:
> Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> functionality as xfs ioctl XFS_IOC_ZERO_RANGE.

Lukas, can you please also send a man page update for
FALLOC_FL_ZERO_RANGE now that is has been merged?

> 
> It can be used to convert a range of file to zeros preferably without
> issuing data IO. Blocks should be preallocated for the regions that span
> holes in the file, and the entire range is preferable converted to
> unwritten extents - even though file system may choose to zero out the
> extent or do whatever which will result in reading zeros from the range
> while the range remains allocated for the file.
> 
> This can be also used to preallocate blocks past EOF in the same way as
> with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> size to remain the same.
> 
> You can test this feature yourself using xfstests, of fallocate(1) however
> you'll need patches for util_linux, xfsprogs and xfstests which you
> can find here:
> 
> http://people.redhat.com/lczerner/zero_range/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
