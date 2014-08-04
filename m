Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9F2257F76
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 18:07:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37D8AAC001
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 16:07:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2ekXUivm3HbVXq7W for <xfs@oss.sgi.com>;
	Mon, 04 Aug 2014 16:07:45 -0700 (PDT)
Date: Tue, 5 Aug 2014 09:07:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: use-after-free on log replay failure
Message-ID: <20140804230721.GA20518@dastard>
References: <A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
	<20140115014503.GQ3469@dastard>
	<CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
	<20140119231745.GF18112@dastard>
	<4B2A412C75324EE9880358513C069476@alyakaslap>
	<9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2014 at 02:00:05PM +0300, Alex Lyakas wrote:
> Greetings,
> 
> we had a log replay failure due to some errors that the underlying
> block device returned:
> [49133.801406] XFS (dm-95): metadata I/O error: block 0x270e8c180
> ("xlog_recover_iodone") error 28 numblks 16
> [49133.802495] XFS (dm-95): log mount/recovery failed: error 28
> [49133.802644] XFS (dm-95): log mount failed

#define ENOSPC          28      /* No space left on device */

You're getting an ENOSPC as a metadata IO error during log recovery?
Thin provisioning problem, perhaps, and the error is occurring on
submission rather than completion? If so:

8d6c121 xfs: fix buffer use after free on IO error

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
