Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CIqUaU076457 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 12:52:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA4F019239C5
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 10:51:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id C1WbnZ9eEooyxSA6 for
	<xfs@oss.sgi.com>; Thu, 12 Feb 2009 10:51:55 -0800 (PST)
Date: Thu, 12 Feb 2009 13:51:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/13] xfs: add version 3 inode format with CRCs
Message-ID: <20090212185154.GA18280@infradead.org>
References: <20090210202241.546501000@bombadil.infradead.org>
	<20090210202941.455393000@bombadil.infradead.org>
	<20090212063836.GB824@josefsipek.net>
	<49946D7A.6070806@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49946D7A.6070806@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs@oss.sgi.com

On Thu, Feb 12, 2009 at 12:42:02PM -0600, Eric Sandeen wrote:
> Josef 'Jeff' Sipek wrote:
> > On Tue, Feb 10, 2009 at 03:22:53PM -0500, Christoph Hellwig wrote:
> > ...
> >> Index: xfs/fs/xfs/xfs_dinode.h
> >> ===================================================================
> >> --- xfs.orig/fs/xfs/xfs_dinode.h	2009-02-10 19:45:51.939069576 +0100
> >> +++ xfs/fs/xfs/xfs_dinode.h	2009-02-10 19:45:59.195068745 +0100
> >> @@ -69,11 +69,32 @@ typedef struct xfs_dinode {
> >>  
> >>  	/* di_next_unlinked is the only non-core field in the old dinode */
> >>  	__be32		di_next_unlinked;/* agi unlinked list ptr */
> >> -} __attribute__((packed)) xfs_dinode_t;
> >> +
> >> +	/* start of the extended dinode, writable fields */
> >> +	__be32		di_crc;		/* CRC of the inode */
> >> +	__be64		di_changecount;	/* number of attribute changes */
> >> +	__u8		di_pad2[16];	/* more padding for future expansion */
> >> +
> >> +	/* fields only written to during inode creation */
> >> +	xfs_timestamp_t	di_crtime;	/* time created */
> >> +	__be64		di_ino;		/* inode number */
> >> +	uuid_t		di_uuid;	/* UUID of the filesystem */
> >> +} xfs_dinode_t;
> > 
> > Hrm...removing the packed attribute... Eric, do you remember the ARM ABI
> > alignment rules? Regardless of ARM, are those fields aligned nicely? (From a
> > quick glance at the code looks ok.)
> 
> I'll just have to just test it again I suppose.  Removing packed is
> good, as long as the padding makes it all come out right.

The reason why the current dinode needs the packed attribute is that
it's end on an un-even 32bit word, and thus the last field might be
wrongly aligned on 64-bit big-endian platforms (same issue as the
bad features2 one).  With the CRC patchset we now have a dinode
that's properly aligned on a even 32bit word.

> 
> -=Eric
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
