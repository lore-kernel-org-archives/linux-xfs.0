Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C76C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 06:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF36A2070A
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 06:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ydBof4xn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgESGcJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 02:32:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39044 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgESGcJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 02:32:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J6R5qc112175;
        Tue, 19 May 2020 06:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KrMBj7/Ahlgwu/rS7WMgv8+ZKxNto8qcIeBlnK5XiuE=;
 b=ydBof4xn7nqBzTdG35lM2gPEmYHqiUBl3BtM2iJIbYBh+elguiYzwTnH4zYtOtngxGKv
 yQCvXhNon9XL8FeIcw7eVQKB/nUF1Upjxzg1ktY3rOFqfnQ/zkxKHdYjAaD5UFGg2119
 QxBGIkxFhyvhFaVwyyqqpsXQaiBR39PNPBfeol2eo0CPYh1yURMc9tzz77/iZh+8neRp
 Mz8bSY92j2/ov9NxFBhBLe23vCTDqxm7MCSiHidlh0toyhsNcZ8+Ico6FpZfo/YygvcC
 +smdKRVKNHrZ603VgBM7mijoMbT/xtAg4fv6iAX/RAonRf+PuKVLw6cZfMMRXGkRvSgO YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127kr36uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 06:32:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J6SX1P167309;
        Tue, 19 May 2020 06:32:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 313gj15e2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 06:32:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04J6W5IK023224;
        Tue, 19 May 2020 06:32:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 23:32:05 -0700
Date:   Mon, 18 May 2020 23:32:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] SSD optimised allocation policy
Message-ID: <20200519063204.GI17627@magnolia>
References: <20200514103454.GL2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514103454.GL2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=5 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190057
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=5 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190057
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 08:34:54PM +1000, Dave Chinner wrote:
> 
> Topic:	SSD Optimised allocation policies
> 
> Scope:
> 	Performance
> 	Storage efficiency
> 
> Proposal:
> 
> Non-rotational storage is typically very fast. Our allocation
> policies are all, fundamentally, based on very slow storage which
> has extremely high latency between IO to different LBA regions. We
> burn CPU to optimise for minimal seeks to minimise the expensive
> physical movement of disk heads and platter rotation.
> 
> We know when the underlying storage is solid state - there's a
> "non-rotational" field in the block device config that tells us the
> storage doesn't need physical seek optimisation. We should make use
> of that.
> 
> My proposal is that we look towards arranging the filesystem
> allocation policies into CPU-optimised silos. We start by making
> filesystems on SSDs with AG counts that are multiples of the CPU
> count in the system (e.g. 4x the number of CPUs) to drive

I guess you and I have been doing this for years with seemingly few ill
effects. ;)

That said, I did encounter a wackass system with 104 CPUs, a 1.4T RAID
array of spinning disks, 229 AGs sized ~6.5GB each, and a 50M log.  The
~900 io writers were sinking thesystem, so clearly some people are still
getting it wrong even with traditional storage. :(

> parallelism at the allocation level, and then associate allocation
> groups with specific CPUs in the system. Hence each CPU has a set of
> allocation groups is selects between for the operations that are run
> on it. Hence allocation is typically local to a specific CPU.
> Optimisation proceeds from the basis of CPU locality optimisation,
> not storage locality optimisation.

I wonder how hard it would be to compile a locality map for storage and
CPUs from whatever numa and bus topology information the kernel already
knows about?

> What this allows is processes on different CPUs to never contend for
> allocation resources. Locality of objects just doesn't matter for
> solid state storage, so we gain nothing by trying to group inodes,
> directories, their metadata and data physically close together. We
> want writes that happen at the same time to be physically close
> together so we aggregate them into larger IOs, but we really
> don't care about optimising write locality for best read performance
> (i.e. must be contiguous for sequential access) for this storage.
> 
> Further, we can look at faster allocation strategies - we don't need
> to find the "nearest" if we don't have a contiguous free extent to
> allocate into, we just want the one that costs the least CPU to
> find. This is because solid state storage is so fast that filesystem
> performance is CPU limited, not storage limited. Hence we need to
> think about allocation policies differently and start optimising
> them for minimum CPU expenditure rather than best layout.
> 
> Other things to discuss include:
> 	- how do we convert metadata structures to write-once style
> 	  behaviour rather than overwrite in place?

(Hm?)

> 	- extremely large block sizes for metadata (e.g. 4MB) to
> 	  align better with SSD erase block sizes

If we had metadata blocks that size, I'd advocate for studying how we
could restructure the btree to log updates in the slack space and only
checkpoint lower in the tree when necessary.

> 	- what parts of the allocation algorithms don't we need

Brian reworked part of the allocator a couple of cycles ago to reduce
the long tail latency of chasing through one free space btree when the
other one would have given it a quick answer; how beneficial has that
been?  Could it be more aggressive?

(Will have to ponder allocation issues in more depth when I'm more
awake..)

> 	- are we better off with huge numbers of small AGs rather
> 	  than fewer large AGs?

There's probably some point of dimininishing returns, but this seems
likely.  Has anyone studied this recently?

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
