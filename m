Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3S1xjeW194111 for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 20:59:45 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1099D126EE8B
	for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 19:01:44 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id 74VyvlWEJF8erYLN for
	<xfs@oss.sgi.com>; Tue, 27 Apr 2010 19:01:44 -0700 (PDT)
Message-ID: <4BD796A1.7050505@oracle.com>
Date: Wed, 28 Apr 2010 10:00:01 +0800
From: Tao Ma <tao.ma@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: Let the broken fiemap work in query mode.
References: <1272349065-16383-1-git-send-email-tao.ma@oracle.com>
	<20100428015035.GC9783@dastard>
In-Reply-To: <20100428015035.GC9783@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Dave,

Dave Chinner wrote:
> On Tue, Apr 27, 2010 at 02:17:45PM +0800, Tao Ma wrote:
>> According to Documentation/filesystems/fiemap.txt, If fm_extent_count
>> is zero, then the fm_extents[] array is ignored (no extents will be
>> returned), and the fm_mapped_extents count will hold the number of
>> extents needed.
>>
>> But as the commit 97db39a1f6f69e906e98118392400de5217aa33a has changed
>> bmv_count to the caller's input buffer, this number query function can't
>> work any more. As this commit is written to change bmv_count from
>> MAXEXTNUM because of ENOMEM, we can't find a really suitable number to
>> set bmv_count now in xfs_vn_fiemap. Since we really have no idea of how
>> much extents the file has, a big number may cause ENOMEM, while a small
>> one will mask the real extent no.
>>
>> So this patch try to resolve this problem by adding a temporary getbmapx
>> in xfs_getbmap. If the caller didn't give bmv_count, we don't allocate
>> the "out" either. Instead, every time we want to use 'out', use '&tmp'
>> instead.
>>
>> I know this solution is a bit ugly, but I can't find a way to resolve
>> this issue while not changing the codes too much. So any good suggestion
>> is welcomed.
> 
> I don't see a need to change xfs_getbmap() to fix this. We can limit
> the maximum allocation size to something realistic just by setting
> bm.bmv.count to something sane. e.g, in xfs_vn_fiemap:
> 
> -	bm.bmv_count = fieinfo->fi_extents_max + 1;
> +	bm.bmv.count = !fieinfo->fi_extents_max ? MAXEXTNUM :
> +					fieinfo->fi_extents_max - 1;
> +	bm.bmv_count = MIN(bm.bmv_count,
> 				(PAGE_SIZE * 16 / sizeof(struct getbmapx)));
> 
> Unless I'm missing something, that should also prevent the case of
> an application providing a really large fi_extents_max from
> triggering ENOMEM in most cases as well.
I just worry about one thing: What if the real extent number is larger 
than the PAGE_SIZE * 16 / sizeof(struct getbmapx)? In this case, we will
give up the wrong extent number to the user space.
> 
> FWIW, how did you find this? Is it possible for you to add a test
> for this regression into xfstests so that we don't break it again
> in future?
Sure, I will check and see whether I can add it in xfstests.

Regards,
Tao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
