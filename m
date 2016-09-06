Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 13A027CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 12:02:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA834304039
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 10:02:26 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id iFXA4B9F8Fp6CuTv (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 10:02:25 -0700 (PDT)
Date: Tue, 6 Sep 2016 10:02:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 67/71] xfs: fail ->bmap for reflink inodes
Message-ID: <20160906170222.GA22753@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216835350.867.14512964799631563964.stgit@birch.djwong.org>
	<20160906152948.GB9760@infradead.org>
	<20160906162651.GB16696@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906162651.GB16696@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 09:26:51AM -0700, Darrick J. Wong wrote:
> Yeah, at the time I thought I was going to write out a clever resolution to the
> conflict between swap and CoW by using swap_activate to punch and fallocate all
> the shared extents and turn off the inode reflink flag which would then enable
> me to drop this patch altogether, but then got busy and forgot all about it.
> Clearly I didn't fix the changelog here either. :(

I looked at that, but that code is such a mess, doing reads through
->readpage and writes using direct_IO and requiring all kinds of ropes
to jump through..

> "Have xfs_vm_bmap return zero for reflinked files because the bmap-based
> swap code requires static block mappings, which is incompatible with
> copy on write."

Sounds fine.  Might be worth addings something like: "And existing
userspace bmap users such as lilo will have the same problems".

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
