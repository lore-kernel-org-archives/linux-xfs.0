Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751329AbeE3KCN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 May 2018 06:02:13 -0400
Subject: Re: [Cluster-devel] [PATCH 11/34] iomap: move IOMAP_F_BOUNDARY to
 gfs2
References: <20180523144357.18985-1-hch@lst.de>
 <20180523144357.18985-12-hch@lst.de> <20180530055033.GZ30110@magnolia>
 <bc621d7c-f1a6-14c2-663f-57ded16811fa@redhat.com>
 <20180530095911.GB31068@lst.de>
From: Steven Whitehouse <swhiteho@redhat.com>
Message-ID: <e14b3cfb-73ca-e712-e1e9-4ceabc8c7b6d@redhat.com>
Date: Wed, 30 May 2018 11:02:08 +0100
MIME-Version: 1.0
In-Reply-To: <20180530095911.GB31068@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org, =?UTF-8?Q?Andreas_Gr=c3=bcnbacher?= <agruenba@redhat.com>

Hi,


On 30/05/18 10:59, Christoph Hellwig wrote:
> On Wed, May 30, 2018 at 10:30:32AM +0100, Steven Whitehouse wrote:
>> I may have missed the context here, but I thought that the boundary was a
>> generic thing meaning "there will have to be a metadata read before more
>> blocks can be mapped" so I'm not sure why that would now be GFS2 specific?
> It was always a hack.  But with iomap it doesn't make any sensee to start
> with, all metadata I/O happens in iomap_begin, so there is no point in
> marking an iomap with flags like this for the actual iomap interface.

In that case,  maybe it would be simpler to drop it for GFS2. Unless we 
are getting a lot of benefit from it, then we should probably just 
follow the generic pattern here. Eventually we'll move everything to 
iomap, so that the bh mapping interface will be gone. That implies that 
we might be able to drop it now, to avoid this complication during the 
conversion.

Andreas, do you see any issues with that?

Steve.


