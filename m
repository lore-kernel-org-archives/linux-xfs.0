Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD8AE7F3F
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 14:07:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6806BAC001
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 12:07:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id R8QWLrACNPcZQsrG for <xfs@oss.sgi.com>;
	Tue, 19 Aug 2014 12:07:38 -0700 (PDT)
Message-ID: <53F3A07B.9040402@sandeen.net>
Date: Tue, 19 Aug 2014 14:07:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: add a few more verifier tests
References: <53F2C103.8030607@redhat.com>
	<20140819181542.GA31177@infradead.org>
In-Reply-To: <20140819181542.GA31177@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/19/14, 1:15 PM, Christoph Hellwig wrote:
>> Anyway - bounds checking when we read from disk is a good thing!
> 
> Absolutelt!
> 
> Looks good modulo a few nitpicks below.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index 4bffffe..a4a9e0e 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -2209,6 +2209,10 @@ xfs_agf_verify(
>>  	      be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp)))
>>  		return false;
>>  
>> +	if (!(be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) <= XFS_BTREE_MAXLEVELS &&
>> +	      be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) <= XFS_BTREE_MAXLEVELS))
>> +		return false;
> 
> Maybe it's just me, but negated numeric comparisms always confuse the
> hell out of me, why not simply:
> 
> 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS)
> 		return false;
> 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
> 		return false;
> 
>> --- a/fs/xfs/libxfs/xfs_ialloc.c
>> +++ b/fs/xfs/libxfs/xfs_ialloc.c
>> @@ -2051,6 +2051,8 @@ xfs_agi_verify(
>>  	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
>>  		return false;
>>  
>> +	if (!(be32_to_cpu(agi->agi_level) <= XFS_BTREE_MAXLEVELS))
>> +		return false;
> 
> Same here.

yeah; just following the style of the functions as they exist today...

        if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
              XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
              be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
...

dunno. Don't care too much either way, but consistency and all that...

Maybe the "AGF_GOOD_VERSION" required the negation, and it all got lumped
together?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
