Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51554 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752031AbeBEG7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 01:59:44 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w156x2Ug004382
        for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2018 01:59:44 -0500
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fxcyshtmv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2018 01:59:44 -0500
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 5 Feb 2018 06:59:41 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [LSF/MM TOPIC] File system memory management topics
Date: Mon, 05 Feb 2018 12:31:04 +0530
In-Reply-To: <20180201143422.phir5f2wwv6udnqe@destiny>
References: <20180201143422.phir5f2wwv6udnqe@destiny>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <9098480.msMr5zvJja@dhcp-9-109-247-41>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org

On Thursday, February 1, 2018 8:04:22 PM IST Josef Bacik wrote:
> Hello,
> 
> I've been lazily working through various mm related issues with file systems for
> the last couple of years and would like to talk about current progress and work
> thats left to be done.  Some of the topics I want to cover are
> 
> * Metadata tracking, writeback, and reclaim
> * Smarter fs cache shrinking
> * Non-page size block size handling
> 

The above list of items mentioned by Josef is very important (especially w.r.t
Btrfs' subpage-blocksize support) for getting 4k blocksized filesystems to
work well for architectures like PPC64 and AARCH64 which [can] have 64k page
size. Hence I would request that these topics gets discussed during this
year's LSF/MM summit.

> Dave please tell me you are going to be there this year?  It's going to be
> completely useless for me to talk about this stuff if you aren't in the room.
> These are all big topics in and of themselves so if we just need to get you, me,
> Jan, and some poor MM guy locked in a room with a couple of bottles of liquor
> until we figure it out then that's fine.
> 
> I'm hoping to have the metadata tracking stuff fixed up and at least mergable by
> LSF, but there's still stuff to be added to that infrastructure later on, and
> the other topics we need to agree on a direction.  Thanks,
> 

-- 
chandan

