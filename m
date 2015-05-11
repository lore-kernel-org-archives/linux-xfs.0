Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 69CED7F3F
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 00:37:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EB890AC002
	for <xfs@oss.sgi.com>; Sun, 10 May 2015 22:37:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id DpSc6hwb9MNhYEBu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 10 May 2015 22:37:08 -0700 (PDT)
Date: Sun, 10 May 2015 22:37:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE, DISCUSS] xfsprogs: libxfs-4.1-update branch created
Message-ID: <20150511053708.GB29703@infradead.org>
References: <20150511000508.GD16689@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150511000508.GD16689@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, May 11, 2015 at 10:05:08AM +1000, Dave Chinner wrote:
> A good example of this is Christoph's xfs_trans_commit() patchset.
> There's 42 xfs_trans_commit() calls in userspace and it has a
> completely different implementation in userspace. To put that in
> context, there are 61 xfs_trans_commit() in the kernel code. If I
> merge that changeset into the kernel code, then Christoph walks away
> and it has become the Maintainer's problem to make userspace work
> with the API change.

I'm perfectly happy to do this work for userspace as well. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
