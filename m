Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0186629DFB
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 23:46:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D35E9304032
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 21:46:43 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id TgPIAMrDAcpdGs9F (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 22 Sep 2013 21:46:41 -0700 (PDT)
Message-ID: <523FC7DB.20204@oracle.com>
Date: Mon, 23 Sep 2013 12:47:23 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix the wrong new_size/rnew_size at
	xfs_iext_realloc_direct()
References: <523EA96B.3040904@oracle.com> <20130923005657.GN12541@dastard>
In-Reply-To: <20130923005657.GN12541@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,

On 09/23/2013 08:56 AM, Dave Chinner wrote:

> On Sun, Sep 22, 2013 at 04:25:15PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> At xfs_iext_realloc_direct(), the new_size is changed by adding
>> if_bytes if originally the extent records are stored at the inline
>> extent buffer, and we have to switch from it to a direct extent
>> list for those new allocated extents, this is wrong. e.g,
>>
>> Create a file with three extents which was showing as following,
>>
>> xfs_io -f -c "truncate 100m" /xfs/testme
>>
>> for i in $(seq 0 5 10); do
>> 	offset=$(($i * $((1 << 20))))
>> 	xfs_io -c "pwrite $offset 1m" /xfs/testme
>> done
>>
>> Inline
>> ------
>> irec:	if_bytes	bytes_diff	new_size
>> 1st	0		16		16
>> 2nd	16		16		32
>>
>> Switching
>> ---------						rnew_size
>> 3rd	32		16		48 + 32 = 80	roundup=128
>>
>> In this case, the desired value of new_size should be 48, and then
>> it will be roundup to 64 and be assigned to rnew_size.
> 
> Ok, so it allocates 128 bytes instead of 64 bytes. It tracks that
> allocation size correctly ifp->if_real_bytes, and all it means is
> that there are 4 empty extra slots in the extent array. The code
> already handles having empty slots in the direct extent array, so
> what impact is there as a result of the oversized initial allocation
> that is currently happening?
> 
> i.e. if fixing the oversized results in more memory allocations due
> to resizing more regularly, then is there a benefit to changing this
> code given that the rewrite of the ifp->if_bytes value in the case
> where we do inline->direct conversion prevents this over-allocation
> from being a problem...

I guess my current patch subject/description mislead you.  The result
of the oversized can be ignored since this can be handled in the direct
extent array as empty slots.

Actually, what I want to say is that we don't need to perform "new_size += ifp->if_bytes;"
again at xfs_iext_realloc_direct() because the new_size at xfs_iext_add()
already be the size of extents after adding, just as the variable comments
is mentioned.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
