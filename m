Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36484 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755221AbdDLRog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 13:44:36 -0400
Received: by mail-wm0-f67.google.com with SMTP id q125so7916016wmd.3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2017 10:44:35 -0700 (PDT)
Subject: Re: Deadlock between block allocation and block truncation
References: <800468eb-3ded-9166-20a4-047de8018582@gmail.com>
 <20170412161017.GA16590@infradead.org>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <3e0d4184-9d7a-9ca8-330c-727b183975a6@gmail.com>
Date: Wed, 12 Apr 2017 20:44:32 +0300
MIME-Version: 1.0
In-Reply-To: <20170412161017.GA16590@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com



On 12.04.2017 19:10, Christoph Hellwig wrote:
> Hi Nikolay,
> 
> I guess the culprit is that truncate can free up to two extents in
> the same transaction and thus try to lock two different AGs without
> requiring them to be in increasing order.

On the other hand Darrick suggested that the problem might be in the
allocation path due to it having a dirty buffer for AGF1 and proceeding
to lock AGF0, resulting in locking order violation. So the bli holding
AGF1 in the allocating task is:

crash> struct xfs_buf_log_item.bli_flags 0xffff8800a60b1570
  bli_flags = 2

That's XFS_BLI_DIRTY. According to Darick's opinion here is what
*should* happen:

"
djwong: either agf1 is clean and it needs to release that before going
for agf0, or agf1 is dirty and thus it cannot go for agf0
"

In this case agf1 is dirty and allocation path continues to agf0 which
is clear lock order violation?

On the truncation side the bli's flags for agf0 :

crash> struct -x xfs_buf_log_item.bli_flags 0xffff8801394ed2b8
  bli_flags = 0xa => BLI_DIRTY | BLI_LOGGED

And then it is proceeding to lock AGF1 (ascending order) correctly.


In spite of this your patch is likely to help this situation though I'm
not sure if it is modifying the right side of the violation.

Regards,
Nikolay
