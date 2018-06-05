Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32939 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbeFEBNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 21:13:45 -0400
MIME-Version: 1.0
In-Reply-To: <20180605005904.GY10363@dastard>
References: <20180605103403.3e5b2c91@canb.auug.org.au> <20180605005904.GY10363@dastard>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Tue, 5 Jun 2018 03:13:43 +0200
Message-ID: <CAHpGcMJJPedQhrkkZDpauAFr-9YfoY9oeTYBWHKe8dr7k6gUWw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the xfs tree with Linus' tree
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Bob Peterson <rpeterso@redhat.com>, Christoph Hellwig <hch@lst.de>

2018-06-05 2:59 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> On Tue, Jun 05, 2018 at 10:34:03AM +1000, Stephen Rothwell wrote:
>> Hi all,
>>
>> Today's linux-next merge of the xfs tree got a conflict in:
>>
>>   fs/gfs2/bmap.c
>>
>> between commit:
>>
>>   628e366df11c ("gfs2: Iomap cleanups and improvements")
>>
>> from Linus' tree and commit:
>>
>>   7ee66c03e40a ("iomap: move IOMAP_F_BOUNDARY to gfs2")
>>
>> from the xfs tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary. This
>> is now fixed as far as linux-next is concerned, but any non trivial
>> conflicts should be mentioned to your upstream maintainer when your tree
>> is submitted for merging.  You may also want to consider cooperating
>> with the maintainer of the conflicting tree to minimise any particularly
>> complex conflicts.
>
> We should have seen this before the gfs2 tree was merged into Linus'
> tree. Does that mean the gfs2 tree is not being pulled into the
> linux-next tree?

That's probably our fault, the gfs2 for-next branch was slightly
outdated. That patch would have been better in the gfs2 tree. How
would you like to proceed?

Thanks,
Andreas
