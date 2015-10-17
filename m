Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1DDB97FBD
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 19:08:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D66D8F8052
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 17:08:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3Dhdk215jssvwoH9 for <xfs@oss.sgi.com>;
	Fri, 16 Oct 2015 17:08:02 -0700 (PDT)
Received: from Liberator.local (unknown [72.25.20.206])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C759363BCF80
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 19:08:01 -0500 (CDT)
Subject: Re: [PATCH] xfs: fix build without xfsstats
References: <5578984.gxbqPUmtuT@wuerfel>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56219161.8020408@sandeen.net>
Date: Fri, 16 Oct 2015 19:08:01 -0500
MIME-Version: 1.0
In-Reply-To: <5578984.gxbqPUmtuT@wuerfel>
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
To: xfs@oss.sgi.com



On 10/16/15 4:47 PM, Arnd Bergmann wrote:
> A recent rework of the xfsstats interface introduced a compile error
> for the procfs-disabled case:
> 
> fs/built-in.o: In function `xfs_free_ag_extent':
> fs/xfs/libxfs/xfs_alloc.c:1725: undefined reference to `xfsstats'
> fs/built-in.o: In function `xfs_alloc_ag_vextent':
> fs/xfs/libxfs/xfs_alloc.c:645: undefined reference to `xfsstats'
> fs/built-in.o: In function `xfs_attr_set':
> fs/xfs/libxfs/xfs_attr.c:353: undefined reference to `xfsstats'
> fs/built-in.o: In function `xfs_attr_remove':
> fs/xfs/libxfs/xfs_attr.c:483: undefined reference to `xfsstats'
> fs/built-in.o: In function `xfs_attr_get':
> fs/xfs/libxfs/xfs_attr.c:131: undefined reference to `xfsstats'
> fs/built-in.o:fs/xfs/libxfs/xfs_bmap.c:1461: more undefined references to `xfsstats' follow
> 
> This adds conditional compilation to each reference of the xfsstats
> global variable to get it to link again.
> 
> An alternative approach would be to always build the statistics
> implementation even when CONFIG_PROC_FS is disabled.

Yep, they live for realz in sysfs now, not procfs.

Reported a couple times already ;)  Dave has a patch at:

https://marc.info/?l=linux-xfs&m=144476889031721&w=2

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
