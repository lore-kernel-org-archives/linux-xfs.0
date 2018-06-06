Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:36831 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbeFFLJL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jun 2018 07:09:11 -0400
MIME-Version: 1.0
In-Reply-To: <20180606105906.GA11821@lst.de>
References: <20180606104033.4947-1-hch@lst.de> <20180606104033.4947-2-hch@lst.de>
 <20180606105906.GA11821@lst.de>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Wed, 6 Jun 2018 13:09:09 +0200
Message-ID: <CAHpGcMJ86WjtBx__CJMGvErSFM_dpWuTAikWHDqoq2gXR9cbKQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] fs: factor out a __generic_write_end helper
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-ext4@vger.kernel.org

2018-06-06 12:59 GMT+02:00 Christoph Hellwig <hch@lst.de>:
> On Wed, Jun 06, 2018 at 12:40:28PM +0200, Christoph Hellwig wrote:
>> Bits of the buffer.c based write_end implementations that don't know
>> about buffer_heads and can be reused by other implementations.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> This actually already had two reviews:
>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> That got lost through the detour via gfs2.

And one by me which has been dropped this time around, but I suppose
it doesn't matter.

Andreas
