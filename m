Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB70E7CA0
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 01:27:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 432F2AC005
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 23:27:21 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id t7nSX7ppsuETHQFI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 23:27:19 -0700 (PDT)
Date: Mon, 6 Jun 2016 23:27:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: crash in xfs in current
Message-ID: <20160607062717.GA30022@infradead.org>
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, reinoudkoornstra@gmail.com
Cc: wagi@monom.org, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Mon, Jun 06, 2016 at 11:39:59PM -0500, Eric Sandeen wrote:
> xfs_dir2_leaf_lookup_int() only hits that ASSERT if it was given
> a name to rename, and failed to find the original.  i.e. that should
> not happen.
> 
>         /*
>          * Loop over all the entries with the right hash value
>          * looking to match the name.
>          */
> 
> <do that loop>
> <fail to find the hash value for the name>
> <then:>
> 
>         ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
>         /*
>          * Here, we can only be doing a lookup (not a rename or remove).
>          * If a case-insensitive match was found earlier, re-read the
>          * appropriate data block if required and return it.
>          */
> 
> A rename should never fail to find the original name.

FYI, this looks very much the same like the Bug Daniel reported, which
I tried to help debugging in person over the weekend.  His backtrace
points to cancelling a dirty transaction after xfs_dir_replace failed,
which most likely comes from the failing lookup, except that he probably
doen't have XFS_DEBUG enabled.

Given that 4.7-rc1 comes with the new shared locks for lookups, and
there are very little other changes I wonder if there is any relation
It would be good if Reinoud and/or Daniel can confirm that Linux 4.6
is ok.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
