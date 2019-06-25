Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45898 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfFYNHw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 09:07:52 -0400
Subject: Re: [PATCH] xfs: remove unused header files
References: <22d173bc-2d33-384c-7d79-f6dc0133c282@redhat.com>
 <20190625110206.GC9601@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3e244c25-e49a-3576-185c-8f47dca9efe9@sandeen.net>
Date: Tue, 25 Jun 2019 08:07:50 -0500
MIME-Version: 1.0
In-Reply-To: <20190625110206.GC9601@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 6/25/19 6:02 AM, Christoph Hellwig wrote:
> On Thu, Jun 20, 2019 at 08:46:26PM -0500, Eric Sandeen wrote:
>> There are many, many xfs header files which are included but
>> unneeded (or included twice) in the xfs code, so remove them.
>>
>> nb: xfs_linux.h includes about 9 headers for everyone, so those
>> explicit includes get removed by this.  I'm not sure what the
>> preference is, but if we wanted explicit includes everywhere,
>> a followup patch could remove those xfs_*.h includes from
>> xfs_linux.h and move them into the files that need them.
>> Or it could be left as-is.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Do you have a script testing what includes are needed?

I used a hacked up version of ESR's "deheader" tool
(hacked up to invoke a kernel build, with -Werror turned on
so warnings from dropped header files would make them look
"needed")

-Eric

> Either way, this looks good to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
