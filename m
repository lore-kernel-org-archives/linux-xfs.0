Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Jun 2008 08:16:02 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m54FFw9R010400
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 08:15:59 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8E051B9E6F4
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2008 08:16:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 6LKn1d013GhRNjhY for <xfs@oss.sgi.com>; Wed, 04 Jun 2008 08:16:52 -0700 (PDT)
Date: Wed, 4 Jun 2008 11:16:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: vfs dmapi handle generation problem
Message-ID: <20080604151651.GA16376@infradead.org>
References: <8efbf9761cbff87b03e5326866cd914d.squirrel@webmailer.fh-worms.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8efbf9761cbff87b03e5326866cd914d.squirrel@webmailer.fh-worms.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim J?dicke <tim.joedicke@fh-worms.de>
Cc: xfs@oss.sgi.com

On Wed, Jun 04, 2008 at 03:55:04PM +0200, Tim J?dicke wrote:
> int
> vfs_dm_inode_to_fh(struct inode *ip, dm_fid_t *dmfid, dm_fsid_t *dmfsid)
> {
>    dmfid->dm_fid_len = sizeof(dm_fid_t) - sizeof(dmfid->dm_fid_len);
>    dmfid->dm_fid_pad = 0;
>    memcpy(&dmfid->dm_fid_ino, &ip->i_ino, sizeof(dmfid->dm_fid_ino));
>    dmfid->dm_fid_gen = ip->i_generation;
> 
>    *dmfsid = 11; // need generation system
> 
>    return 0;

i_ino in struct inode is unsigned long.  If you run the above code
on a 32bit system you'll get crap in the upper half of dm_fid_ino.

Try:

int
vfs_dm_inode_to_fh(struct inode *ip, dm_fid_t *dmfid, dm_fsid_t *dmfsid)
{
	dmfid->dm_fid_len = sizeof(dm_fid_t) - sizeof(dmfid->dm_fid_len);
	dmfid->dm_fid_pad = 0;
	dmfid->dm_fid_ino = ip->i_ino;
	dmfid->dm_fid_gen = ip->i_generation;

	*dmfsid = 11; // need generation system
	return 0;
}

instead.  If you actually want to support 64bit inode numbers on 32bit
systems you'll have to query for it with vfs_getattr, though.
