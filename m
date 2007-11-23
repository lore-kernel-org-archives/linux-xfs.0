Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Nov 2007 10:34:01 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de [85.214.69.204])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lANIXsjh006596
	for <xfs@oss.sgi.com>; Fri, 23 Nov 2007 10:33:56 -0800
Date: Fri, 23 Nov 2007 19:16:08 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 9/9] Clean up open coded inode dirty checks
In-Reply-To: <20071123180239.GA13229@infradead.org>
Message-ID: <Pine.LNX.4.64.0711231914300.12552@fbirervta.pbzchgretzou.qr>
References: <20071122004422.GO114266761@sgi.com> <20071123180239.GA13229@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>


On Nov 23 2007 18:02, Christoph Hellwig wrote:
>
>> +STATIC_INLINE int xfs_inode_clean(xfs_inode_t *ip)
>> +{
>> +	return (((ip->i_itemp == NULL) ||
>> +		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
>> +		(ip->i_update_core == 0));
>> +}
>
>Can we please get rid of this useless STATIC_INLINE junk?  It's really
>hurting my eyes.
>
>As does to a lesser extent the verbose style of this
>function.

I have to disagree, but whatever.

>static inline int xfs_inode_clean(struct xfs_inode *ip)
               ^                   ^
could be bool - and const
>{
>	return (!ip->i_itemp ||
>	        !(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
>	       !ip->i_update_core;
>}

Perhaps for greater readability:

static inline bool xfs_inode_clean(const struct xfs_inode *ip)
{
	if (ip->i_itemp == NULL)
		return true;
	if (!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL) &&
	    ip->i_update_core == NULL)
		return true;
	return false;
}
