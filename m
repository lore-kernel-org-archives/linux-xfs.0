Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QMLJh6103710 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 17:21:19 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5J6CHTmaTLiyBUP2 for
	<xfs@oss.sgi.com>; Mon, 26 Mar 2012 15:21:17 -0700 (PDT)
Message-ID: <4F70EBD8.9030006@redhat.com>
Date: Mon, 26 Mar 2012 17:21:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 235: do smaller test IO
References: <4F70C3D9.80708@redhat.com> <20120326220926.GO5091@dastard>
In-Reply-To: <20120326220926.GO5091@dastard>
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
Cc: Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 3/26/12 5:09 PM, Dave Chinner wrote:
> On Mon, Mar 26, 2012 at 02:30:33PM -0500, Eric Sandeen wrote:
>> Test 235 fails on ext2/ext3 with 1024 fs block size because a
>> 16k write uses an extra metadata block.  If we do a smaller write
>> this won't happen.
> .....
>>  
>> -$XFS_IO_PROG -F -c 'pwrite 0 16k' -c 'fsync' \
>> +$XFS_IO_PROG -F -c 'pwrite 0 8k' -c 'fsync' \
> 
> So now it fails only on 512 byte block size filesystems?

ext[23] don't do 512 byte block filesystems, so no.  ;)

> Perhaps rather than an exact match, a "within_tolerance" match could
> be done on the relevant fields?
> 
> i.e something like:
> 
> blksused=`{requota cmd} | awk '/fsgqa/ { print $3 }'`
> _within_tolerance "blocks used" $blksused 16 1
> 
> If you wanted to get really fancy, the tolerance could be set
> depending on filesystem type and block size, but I don't think that
> is really necessary....

But I don't want to get really fancy, I spend enough time in xfstests
already.  ;)


TBH even the _within_tolerance will take more munging around to get right,
it doesn't seem worth it, but if it's required for a review, ok...

-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
