Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7L57HNB039130 for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 00:07:17 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id FFNRGGIaiQekY4ok (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 22:07:16 -0700 (PDT)
Message-ID: <5033177A.4000202@oracle.com>
Date: Tue, 21 Aug 2012 13:07:06 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 3/4] xfs: xfs_seek_data() refinement with unwritten
	extents check up from page cache
References: <5028FC39.5060809@oracle.com> <20120820231607.GK19235@dastard>
In-Reply-To: <20120820231607.GK19235@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/21/12 07:16, Dave Chinner wrote:
> On Mon, Aug 13, 2012 at 09:08:09PM +0800, Jeff Liu wrote:
>> Improve xfs_seek_data() to search data offset from page cache for unwritten extents.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> One minor addition, otherwise
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
> ....
>> +
>> +		/*
>> +		 * map[0] is hole or its an unwritten extent but
>> +		 * without data in page cache.  Probably means that
>> +		 * we are reading after EOF if nothing in map[1].
>> +		 */
>>  		if (nmap == 1) {
>>  			error = ENXIO;
>>  			goto out_unlock;
>>  		}
>>  
>> -		offset = max_t(loff_t, start,
>> -			       XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +		/*
>> +		 * Nothing was found, proceed to the next round of search
>> +		 * if reading offset not beyond or hit EOF.
>> +		 */
> 		ASSERT(i > 1);
Will add this check up.

Thanks,
-Jeff
>
>> +		fsbno = map[i - 1].br_startoff + map[i - 1].br_blockcount;
>> +		start = XFS_FSB_TO_B(mp, fsbno);
>> +		if (start >= isize) {
>> +			error = ENXIO;
>> +			goto out_unlock;
>> +		}
>>  	}
>>  
>> +out:
>>  	if (offset != file->f_pos)
>>  		file->f_pos = offset;
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
