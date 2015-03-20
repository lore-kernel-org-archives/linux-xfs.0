Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 808697F3F
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 21:27:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5FFA08F8066
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 19:27:39 -0700 (PDT)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id xyWA4HWtqcK60uPo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 19:27:34 -0700 (PDT)
Message-ID: <550B858D.4030003@tlinx.org>
Date: Thu, 19 Mar 2015 19:27:25 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: default to CRC enabled filesystems
References: <1426720967-8215-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1426720967-8215-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's time to change the mkfs defaults to enable CRCs for all new
> filesystems. 
---
	"Sounds good", but what exactly is CRC'ed?

I.e. all data? Or how much data/second would I expect
to 'need' CRC'ing?

Some quick timing stuff:

> time  dd if=/dev/zero of=1G bs=1M count=1024 oflag=direct    
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 1.76947 s, 607 MB/s
1.77sec 0.00usr 0.50sys (28.38% cpu)

> dropcaches
76.34sec 0.00usr 69.22sys (90.69% cpu)

Ishtar:law/bin> time crc32 1G		## no cache
5B64C2B0
6.67sec 3.85usr 0.94sys (71.82% cpu)

> time crc32 1G				## in cache
5B64C2B0
4.00sec 3.57usr 0.42sys (100.00% cpu)
(using Xeon X5660 @ 2.80GHz)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
