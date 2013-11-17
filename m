Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D177B7F52
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 06:25:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AED98304032
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 04:25:29 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2CvAmH3ZaQjLN7WR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Nov 2013 04:25:25 -0800 (PST)
Message-ID: <5288B58D.5030609@oracle.com>
Date: Sun, 17 Nov 2013 20:24:45 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/4] xfs: introduce a new helper
	xfs_inobt_reada_chunk()
References: <5281F509.7020105@oracle.com>
	<20131115170325.GA16942@infradead.org>
In-Reply-To: <20131115170325.GA16942@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks for so much detailed comments!

On 11/16 2013 01:03 AM, Christoph Hellwig wrote:
> I like the factoring, but it could go a littler further.  Comments
> below:
> 
>>  /*
>> + * Loop over all clusters in a chunk for a given incore inode
>> + * allocation btree record.  Do a readahead if there are any
>> + * allocated inodes in that cluster.
>> + */
> 
> Try to use the full 80 lines available to you for comment.
Okay.
> 
>> +	xfs_agblock_t			agbno = XFS_AGINO_TO_AGBNO(mp,
>> +						irec->ir_startino);
>> +	int				nicluster, nbcluster;
>> +	int				chunkidx;
>> +
>> +	nicluster = mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp) ?
>> +		    mp->m_sb.sb_inopblock :
>> +		    (XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
>> +	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
> 
> I'd prefer to factor this out even further. xfs_ialloc_inode_init and
> xfs_ifree_cluster already have two pieces of code that calculate these
> two (with more readable names) and an additional nuber buffers counter
> we won't need here, it might make most sense to factor that into a
> single common helper.
Yup, I also thought this can be factored out, however, I can not figure out
a meaningful function name at that time due to my poor skill...

How about if we introduce an inline helper to xfs_ialloc.h as below?

/* Helper function to extract the # of blocks/inodes/buffers hint per cluster */
static inline void
xfs_ialloc_get_cluster_hints(
	struct xfs_mount	*mp,
	int			*nblks;
	int			*ninodes;
	int			*nbufs)
{
	....
}
> 
>> +/*
>> + * Lookup clusters in inode chunk for a given incore inobt record,
>> + * do readahead if there are any allocated inodes in that cluster.
>> + */
>> +void xfs_inobt_reada_chunk(struct xfs_mount *mp, xfs_agnumber_t agno,
>> +			   struct xfs_inobt_rec_incore *irec);
> 
> No need to duplicate the comment in the header
Ok.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
