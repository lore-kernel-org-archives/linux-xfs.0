Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbeH3Uei (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Aug 2018 16:34:38 -0400
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
Date: Thu, 30 Aug 2018 11:31:40 -0500
MIME-Version: 1.0
In-Reply-To: <20180830162545.GA26816@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 8/30/18 11:25 AM, Christoph Hellwig wrote:
> On Thu, Aug 30, 2018 at 11:10:05AM -0500, Eric Sandeen wrote:
>> We disabled FIBMAP/bmap calls for reflinked files because swap will then
>> writes directly to the blocks, bypassing COW mechanisms, and breaking
>> copy on write.  As noted in commit db1327b, this restriction also breaks
>> bootloaders that want to use the FIBMAP ioctl.
>>
>> Rather than disabling the entire mapping interface for everyone just
>> because swapon may abuse the info, teach xfs_iomap_swapfile_activate()
>> to reject activation for reflinked files, and re-enable the FIBMAP
>> interface.
> 
> Every use of the feature is an abuse, and that includes bootloaders.
> By the time you've obtained the information it can (and often will)
> be stale.
> 

That's no reason to uniquely disallow it for reflinked files, though;
the problem is universal.  It's true for fiemap as well.  So I'm not sure
that's an argument against the patch?

-Eric
