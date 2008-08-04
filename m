Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 07:20:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m74EKK7A002839
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 07:20:21 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B340EFE952
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 07:21:33 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id auB4GioeNUJRKnMV for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 07:21:33 -0700 (PDT)
Date: Mon, 4 Aug 2008 16:21:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/26] generic btree implementation, version 3
Message-ID: <20080804142131.GA9892@lst.de>
References: <20080804013158.GA8819@lst.de> <20080804015425.GE6119@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804015425.GE6119@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 11:54:25AM +1000, Dave Chinner wrote:
> > I'm not sure
> > what to do with move_* - these are the most ugly helpers, so maybe
> > we should just make them memmove wrappers in the style of copy_
> > and leave all addressing to the callers.
> 
> Yes, it would be nice to have them use the same interface. If
> we do that, then there's no real point for having a copy vs move
> distinction - we could just make everything use the
> memmove version and drop one of the interfaces altogether....

I've actually come up with another variant.  Since what we do in the
memmove case is to move a number of entries in a single block up or down
one position I've added the following helper:

STATIC void
xfs_btree_shift_keys(
	struct xfs_btree_cur    *cur,
	union xfs_btree_key     *key
	int                     dir,
	int                     numkeys)
{
	char			*dst_key;

	ASSERT(numkeys >= 0);
	ASSERT(dir == 1 || dir == -1);

	dst_key = (char *)key + (dir * cur->bc_ops->key_len);
	memmove(dst_key, key, numkeys * cur->bc_ops->key_len);
}

and the same for ptrs and recs.  This follows the original code in
spirit and is quite readable.
