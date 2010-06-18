Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5I2QC2Z201775 for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 21:26:13 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E353DB19EEF
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 19:32:37 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id nmbZTZsCU0On2GO4 for
	<xfs@oss.sgi.com>; Thu, 17 Jun 2010 19:32:37 -0700 (PDT)
Message-ID: <4C1AD9A5.8010600@oracle.com>
Date: Fri, 18 Jun 2010 10:27:49 +0800
From: Tao Ma <tao.ma@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
References: <20100614122912.GD6590@dastard>
	<1276764799-4837-1-git-send-email-tao.ma@oracle.com>
	<20100618004708.GZ6590@dastard>
In-Reply-To: <20100618004708.GZ6590@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, "tao.ma" <tao.ma@oracle.com>

Hi Dave,

On 06/18/2010 08:47 AM, Dave Chinner wrote:
> On Thu, Jun 17, 2010 at 04:53:19PM +0800, Tao Ma wrote:
>> Hi Dave,
>> On 06/14/2010 08:29 PM, Dave Chinner wrote:
>>> I just had a thought - if you want to avoid holes being reported to
>>> fiemap, then add a BMV_IF_NO_HOLES flag to xfs_getbmap() and skip
>>> holes in the mappin gloop when this flag is set. That will make
>>> fiemap fill in the full number of extents without hacking the
>>> extent count...
>> Here is the updated one. I have used BVM_IF_NO_HOLES in xfs_getbmap
>> to skip increasing index 'cur_ext'. It is a bit ugly, see my commit
>> log. I guess maybe we can add another flag in xfs_bmapi so that it
>> don't even give us the holes?
>
> No need...
I am fine with it.
>
>>
>> Regards,
>> Tao
>>
>>  From cee1765ffd3e2b003b837666b4620b5107ed9ddd Mon Sep 17 00:00:00 2001
>> From: Tao Ma<tao.ma@oracle.com>
>> Date: Thu, 17 Jun 2010 16:14:22 +0800
>> Subject: [PATCH v3] xfs: Make fiemap works with sparse file.
>>
>> In xfs_vn_fiemap, we set bvm_count to fi_extent_max + 1 and want
>> to return fi_extent_max extents, but actually it won't work for
>> a sparse file. The reason is that in xfs_getbmap we will
>> calculate holes and set it in 'out', while out is malloced by
>> bmv_count(fi_extent_max+1) which didn't consider holes. So in the
>> worst case, if 'out' vector looks like
>> [hole, extent, hole, extent, hole, ... hole, extent, hole],
>> we will only return half of fi_extent_max extents.
>>
>> This patch add a new parameter BMV_IF_NO_HOLES for bvm_iflags.
>> So with this flags, we don't use our 'out' in xfs_getbmap for
>> a hole. The solution is a bit ugly by just don't increasing
>> index of 'out' vector. I felt that it is not easy to skip it
>> at the very beginning since we have the complicated check and
>> some function like xfs_getbmapx_fix_eof_hole to adjust 'out'.
>
> ... because I think we can safely skip xfs_getbmapx_fix_eof_hole()
> it only modifies the hole. Hence  just adding a check after the
> attribute fork end check (which needs to detect a hole to terminate)
> should be fine: e.g something like:
>
> 			if (map[i].br_startblock == HOLESTARTBLOCK&&
> 			whichfork == XFS_ATTR_FORK) {
> 				/* came to the end of attribute fork */
> 				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
> 				goto out_free_map;
> 			}
> +			if (map[i].br_startblock == HOLESTARTBLOCK&&
> +				 (iflags&  BMV_IF_NO_HOLES)) {
> +				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
> +				continue;
> +			}
>
> Should work and avoid the worst of the ugliness.
I am afraid it doesn't work, at least from my test. It enters a dead loop.
I think the root cause is that your change doesn't update bmv_offset and 
bmv_length for a hole. So in the large loop,
do {
                 nmap = (nexleft > subnex) ? subnex : nexleft;
		error = xfs_bmapi(NULL, ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
                                   XFS_BB_TO_FSB(mp, bmv->bmv_length),
                                   bmapi_flags, NULL, 0, map, &nmap,
                                   NULL, NULL);
                 if (error)
                         goto out_free_map;
...
} while (nmap && nexleft && bmv->bmv_length);

We will dead loop there and we need xfs_getbmapx_fix_eof_hole to go out 
directly.

Regards,
Tao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
