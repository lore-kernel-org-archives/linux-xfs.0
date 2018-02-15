Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:5400 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756371AbeBOWou (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Feb 2018 17:44:50 -0500
Subject: Re: [PATCH v5 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
References: <151873070632.53899.3320294279108510082.stgit@djiang5-desk3.ch.intel.com>
 <151873085471.53899.4916392112937742603.stgit@djiang5-desk3.ch.intel.com>
 <20180215214708.GA10446@infradead.org>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <7657c80b-412b-e280-f126-a7d735a0a730@intel.com>
Date: Thu, 15 Feb 2018 15:44:48 -0700
MIME-Version: 1.0
In-Reply-To: <20180215214708.GA10446@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: darrick.wong@oracle.com, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, dan.j.williams@intel.com



On 02/15/2018 02:47 PM, Christoph Hellwig wrote:
>> +	if ((XFS_IS_REALTIME_INODE(ip)) &&
> 
> No need for the inner braces.

Ok I'll fix

> 
> Except for that the whole series looks fine to me.
> 

Can I add your reviewed-by? Thanks for reviewing.
