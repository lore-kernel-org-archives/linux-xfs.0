Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53785 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbdKWI2l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 03:28:41 -0500
Subject: Re: [PATCH] xfs: Don't trim extents for fiemap
References: <1511424369-28740-1-git-send-email-nborisov@suse.com>
 <20171123081504.GB24556@infradead.org>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <480e7347-fac1-12c0-f64b-f95d40f49366@suse.com>
Date: Thu, 23 Nov 2017 10:28:39 +0200
MIME-Version: 1.0
In-Reply-To: <20171123081504.GB24556@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, sandeen@redhat.com, darrick.wong@oracle.com



On 23.11.2017 10:15, Christoph Hellwig wrote:
> On Thu, Nov 23, 2017 at 10:06:09AM +0200, Nikolay Borisov wrote:
>> For file extents xfs currently always calls xfs_bmapi_read with not flags,
>> meaning extents are going to be truncated to the requested range. This is
>> differs than what other filesystems do (ext4/btrfs don't trim extents). So
>> harmonize the behavior across the filesystem by explicitly not trimming
>> extents when we are called from fiemap code.
> 
> Given that the iomap code generally trims extents, can you just try
> to always enable XFS_BMAPI_ENTIRE?

What you are saying is that iomap currently always trims the returned
range from the underlying filesystem so doing trimming in the fs is
redundant and I can just pass XFS_BMAPI_ENTIRE indiscriminately ?

> 
