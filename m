Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Nov 2008 14:56:43 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mABMuXD0024543
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 14:56:33 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13DD71546E10
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 14:56:32 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id yBqhzyPemVFeHpqK for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 14:56:32 -0800 (PST)
Date: Wed, 12 Nov 2008 09:38:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: review: xfstests/192 atime test
Message-ID: <20081111223810.GK2373@disturbed>
References: <49192204.3040300@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49192204.3040300@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Nov 11, 2008 at 05:11:16PM +1100, Timothy Shimmin wrote:
> Attached simple atime test.
> 192.out and group file would be added appropriately.
> Thanks.
> --Tim

> _supported_fs xfs udf nfs
> _supported_os Linux
> delay=150

150s sleep? It only needs a few seconds for this test.

> time3=`_access_time $testfile | tee -a $seq.full`
> 
> delta1=`expr $time2 - $time1`
> delta2=`expr $time3 - $time1`
> 
> echo "delta1 - access time after sleep in-core: $delta1"
> echo "delta2 - access time after sleep on-disk: $delta2"

Why bother with deltas? if the numbers are the same, just output
"same", if they are different, output "different"....

FWIW, is there a patch being proposed that fixes this problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
