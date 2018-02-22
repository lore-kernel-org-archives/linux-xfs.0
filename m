Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932316AbeBVPbm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Feb 2018 10:31:42 -0500
Subject: Re: [PATCH] misc: enable retpolines across all xfsprogs utilities
References: <20180222021625.GA9827@magnolia>
 <20180222150922.GA26282@infradead.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <4d78832f-4148-d0d9-e2f2-ee8e02a44e97@redhat.com>
Date: Thu, 22 Feb 2018 09:31:41 -0600
MIME-Version: 1.0
In-Reply-To: <20180222150922.GA26282@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 2/22/18 9:09 AM, Christoph Hellwig wrote:
> On Wed, Feb 21, 2018 at 06:16:25PM -0800, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Detect and enable retpolines for all code, to mitigate Spectre v2
>> (branch target injection) on x86.
> 
> The mechanics look ok, but why do we really care for xfsprogs?
> fs utilities seem like a lesser target and should just be covered
> by hopefully sane compiler defaults, shouldn't they?
> 

That's my feeling as well - does manually fixing one utility out of
hundreds on the system help anything? Shouldn't this be done via toolchain
or distro-package-build defaults?

-Eric
