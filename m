Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5EBE67F3F
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 07:33:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E0B48F804B
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 05:33:19 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Wpea8UmFk9oNE59s (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 05:33:17 -0700 (PDT)
Message-ID: <5366336D.5000401@oracle.com>
Date: Sun, 04 May 2014 20:32:45 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 03/10] xfs: consolidate xfs_inumbers
References: <535078B2.8010601@oracle.com> <20140423153639.GB3326@infradead.org>
In-Reply-To: <20140423153639.GB3326@infradead.org>
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

Hi Christoph,

Sorry for my too late response! I missed your response somehow.

On 04/23 2014 23:36 PM, Christoph Hellwig wrote:
> On Fri, Apr 18, 2014 at 08:58:26AM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> To fetch the file system number tables, we currently just ignore the
>> errors and proceed to loop over the next AG or bump agino to the next
>> chunk in case of btree operations failed, that is not properly because
>> those errors might hint us potential file system problems.
>>
>> This patch rework xfs_inumbers() to handle the btree operation errors
>> as well as the loop conditions.  Also, add pre-checkups for the given
>> inode, we can save alloc/free the format buffer once against an invalid
>> inode number.
> 
> The patch looks mostly good to me, but I really think it should be
> split into two patches: one to do the formatting changes and code
> consolidation, and then one that does the actual logic changes for
> better error handling.  It's not easy to understand and verify with
> these two different changes combined.
> 
>>  xfs_inumbers_fmt(
>>  	void			__user *ubuffer, /* buffer to write to */
>> -	const xfs_inogrp_t	*buffer,	/* buffer to read from */
>> +	const struct xfs_inogrp	*buffer,	/* buffer to read from */
>>  	long			count,		/* # of elements to read */
>>  	long			*written)	/* # of bytes written */
>>  {
>>  	if (copy_to_user(ubuffer, buffer, count * sizeof(*buffer)))
>> -		return -EFAULT;
>> +		return XFS_ERROR(EFAULT);
> 
> xfs_inumbers_fmt_compat will need the same treatment.

Yup.

> 
>>  	*count = 0;
>> +	if (agno >= mp->m_sb.sb_agcount ||
>> +	    *lastino != XFS_AGINO_TO_INO(mp, agno, agino))
>> +		return 0;
> 
> Where is the lastino check coming from?

Originally, I copied this check up from xfs_bulkstat(), it seems that it
is a redundant check as agno >= mp->m_sb.sb_agcount can handle an invalid
lastino input?  At least, I can not think out a case to make it happen for
now.

> 
>>  	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
>> +	bufidx = error = 0;
> 
> Why not initialize bufidx and error at declaration time?

So they should be initialized there.

> 
>> +		error = xfs_inobt_get_rec(cur, &r, &stat);
>> +		if (error || !stat)
>> +			break;
> 
> The old code moved on to the next AG here, why has this changed?

Ah, it should be the old way.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
