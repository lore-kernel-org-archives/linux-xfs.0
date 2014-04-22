Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 09D947F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 01:27:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC1CD8F804B
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 23:27:38 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id AqwKVzDrBbunZxiD (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 23:27:37 -0700 (PDT)
Date: Mon, 21 Apr 2014 23:27:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: bulletfproof xfs_qm_scall_trunc_qfiles()
Message-ID: <20140422062736.GA31337@infradead.org>
References: <53558354.5040309@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53558354.5040309@redhat.com>
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

On Mon, Apr 21, 2014 at 03:45:08PM -0500, Eric Sandeen wrote:
> Coverity noticed that if we sent junk into
> xfs_qm_scall_trunc_qfiles(), we could get back an
> uninitialized error value.  So sanitize the flags we
> will accept, and initialize error anyway for good measure.
> 
> (This bug may have been introduced via c61a9e39).
> 
> Should resolve Coverity CID 1163872.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
