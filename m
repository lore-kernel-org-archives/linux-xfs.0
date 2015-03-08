Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C21387F59
	for <xfs@oss.sgi.com>; Sun,  8 Mar 2015 04:41:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 931A6304043
	for <xfs@oss.sgi.com>; Sun,  8 Mar 2015 01:41:38 -0800 (PST)
Received: from mail-we0-f180.google.com (mail-we0-f180.google.com
	[74.125.82.180]) by cuda.sgi.com with ESMTP id 2oDj6cpAy9RYxcXO
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Mar 2015 01:41:36 -0800 (PST)
Received: by wesu56 with SMTP id u56so896154wes.12
	for <xfs@oss.sgi.com>; Sun, 08 Mar 2015 01:41:35 -0800 (PST)
Date: Sun, 8 Mar 2015 10:41:29 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
Message-ID: <20150308094128.GA15487@gmail.com>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-5-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1425741651-29152-5-git-send-email-mgorman@suse.de>
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
To: Mel Gorman <mgorman@suse.de>
Cc: linuxppc-dev@lists.ozlabs.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>


* Mel Gorman <mgorman@suse.de> wrote:

> xfsrepair
>                                     4.0.0-rc1             4.0.0-rc1                3.19.0
>                                       vanilla           slowscan-v2               vanilla
> Min      real-fsmark        1157.41 (  0.00%)     1150.38 (  0.61%)     1164.44 ( -0.61%)
> Min      syst-fsmark        3998.06 (  0.00%)     3988.42 (  0.24%)     4016.12 ( -0.45%)
> Min      real-xfsrepair      497.64 (  0.00%)      456.87 (  8.19%)      442.64 ( 11.05%)
> Min      syst-xfsrepair      500.61 (  0.00%)      263.41 ( 47.38%)      194.97 ( 61.05%)
> Amean    real-fsmark        1166.63 (  0.00%)     1155.97 (  0.91%)     1166.28 (  0.03%)
> Amean    syst-fsmark        4020.94 (  0.00%)     4004.19 (  0.42%)     4025.87 ( -0.12%)
> Amean    real-xfsrepair      507.85 (  0.00%)      459.58 (  9.50%)      447.66 ( 11.85%)
> Amean    syst-xfsrepair      519.88 (  0.00%)      281.63 ( 45.83%)      202.93 ( 60.97%)
> Stddev   real-fsmark           6.55 (  0.00%)        3.97 ( 39.30%)        1.44 ( 77.98%)
> Stddev   syst-fsmark          16.22 (  0.00%)       15.09 (  6.96%)        9.76 ( 39.86%)
> Stddev   real-xfsrepair       11.17 (  0.00%)        3.41 ( 69.43%)        5.57 ( 50.17%)
> Stddev   syst-xfsrepair       13.98 (  0.00%)       19.94 (-42.60%)        5.69 ( 59.31%)
> CoeffVar real-fsmark           0.56 (  0.00%)        0.34 ( 38.74%)        0.12 ( 77.97%)
> CoeffVar syst-fsmark           0.40 (  0.00%)        0.38 (  6.57%)        0.24 ( 39.93%)
> CoeffVar real-xfsrepair        2.20 (  0.00%)        0.74 ( 66.22%)        1.24 ( 43.47%)
> CoeffVar syst-xfsrepair        2.69 (  0.00%)        7.08 (-163.23%)        2.80 ( -4.23%)
> Max      real-fsmark        1171.98 (  0.00%)     1159.25 (  1.09%)     1167.96 (  0.34%)
> Max      syst-fsmark        4033.84 (  0.00%)     4024.53 (  0.23%)     4039.20 ( -0.13%)
> Max      real-xfsrepair      523.40 (  0.00%)      464.40 ( 11.27%)      455.42 ( 12.99%)
> Max      syst-xfsrepair      533.37 (  0.00%)      309.38 ( 42.00%)      207.94 ( 61.01%)

Btw., I think it would be nice if these numbers listed v3.19 
performance in the first column, to make it clear at a glance
how much regression we still have?

Thanks,

	Ingo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
