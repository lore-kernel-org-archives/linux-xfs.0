Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 21F7629DFE
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 10:47:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 010C8304059
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 08:47:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cxCIewGF8sR5Qdvf for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 08:47:11 -0700 (PDT)
Message-ID: <55D747FE.4070401@sandeen.net>
Date: Fri, 21 Aug 2015 10:47:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfsdump: fix problems in cb_add_inogrp
References: <20150821193047.661578219@gulag1.americas.sgi.com>
In-Reply-To: <20150821193047.661578219@gulag1.americas.sgi.com>
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
To: rjohnston@sgi.com, xfs@oss.sgi.com

On 8/21/15 9:01 AM, rjohnston@sgi.com wrote:
> The memset in cb_add_inogrp will segfault when the index oldsize
> overflows. In cb_add_inogrp(), the temp variables used in
> calculating the new i2gmap segment offset should be int64 instead
> of intgen_t (int32).
> 
> A second bug also occurs because we already compensate for the
> length of each item in oldsize so are 32bit wrap becomes a 40bit
> wrap.

Hi -

Are there any testcases for these?  xfsdump is alien code, I swear;
I'm not quite sure offhand how to tickle any of these bugs.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
