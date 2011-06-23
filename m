Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NArKeu177648 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 05:53:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB52C28308
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 03:53:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	yLEHyMSCC6a26ggY for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2011 03:53:19 -0700 (PDT)
Date: Thu, 23 Jun 2011 06:53:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: duplicate code in dir2
Message-ID: <20110623105318.GA11195@infradead.org>
References: <4E020912.9020106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E020912.9020106@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

> /src/git/linux-2.6/fs/xfs/xfs_dir2_node.c(251)
> /src/git/linux-2.6/fs/xfs/xfs_dir2_leaf.c(440)
>                 if (index < be16_to_cpu(leaf->hdr.count))
>                         memmove(lep + 1, lep,
>                                 (be16_to_cpu(leaf->hdr.count) - index) * sizeof(*lep));
>                 lfloglow = index;
>                 lfloghigh = be16_to_cpu(leaf->hdr.count);
>                 be16_add_cpu(&leaf->hdr.count, 1);
>         else {

This one and the the chunks following it are easily factorable, and I've
created a patch. It's 100 lines of common code, just with the order of
asssers switched, and one of them reusing the lep pointer on entry, and
the other one recalculating it.  With the function header and lots of
parameters we don't actually remove a whole lot of code, but having this
relatively complex piece of code only once sounds like a good idea.

> /src/git/linux-2.6/fs/xfs/xfs_dir2_node.c(582)
> /src/git/linux-2.6/fs/xfs/xfs_dir2_leaf.c(1349)
>         for (lep = &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
>                                 be32_to_cpu(lep->hashval) == args->hashval;
>                                 lep++, index++) {
>                 if (be32_to_cpu(lep->address) == XFS_DIR2_NULL_DATAPTR)
>                         continue;
>                 newdb = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
>                 if (newdb != curdb) {
> 
> /src/git/linux-2.6/fs/xfs/xfs_dir2_node.c(442)
> /src/git/linux-2.6/fs/xfs/xfs_dir2_leaf.c(1349)
>         for (lep = &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
>                                 be32_to_cpu(lep->hashval) == args->hashval;
>                                 lep++, index++) {
>                 if (be32_to_cpu(lep->address) == XFS_DIR2_NULL_DATAPTR)
>                         continue;
>                 newdb = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
>                 if (newdb != curdb) {

This seems like a relatively common patter, which has even more
occurances with minimal variations, but I'm not sure there's an easy way
to factor it.

I'd prefer to rewrite the loops to something more readable like:

	for (; index < be16_to_cpu(leaf->hdr.count); index++) {
		lep = &leaf->ents[index];

		if (be32_to_cpu(lep->hashval) != args->hashval)
			break;
		if (be32_to_cpu(lep->address) == XFS_DIR2_NULL_DATAPTR)
			continue;

		...
	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
