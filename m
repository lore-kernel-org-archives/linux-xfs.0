Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38130 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932732AbeEaQ6x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 12:58:53 -0400
Subject: Re: [PATCH 0/4 V2] Remove a few macros
References: <20180307090506.30199-1-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b5e4681b-8198-82fc-e4da-bfbad08cf32d@sandeen.net>
Date: Thu, 31 May 2018 11:58:51 -0500
MIME-Version: 1.0
In-Reply-To: <20180307090506.30199-1-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On 3/7/18 3:05 AM, Carlos Maiolino wrote:
> Hi,
> 
> this is a second version of the patchset aimed to clean up some old macros from
> xfsprogs, as the objective to bring xfs_buf handling code closer to kernel code.
> 
> It fixes some pointer castings Dave mentioned on the V1 patch, also, it removes
> a few unneeded castings I spotted while reviewing the ones Dave mentioned.
> 
> Cheers
> 
> Carlos Maiolino (4):
>    Get rid of XFS_BUF_PTR() macro
>    Get rid of XFS_BUF_TARGET() macro
>    get rid of XFS_BUF_COUNT() macro
>    Get rid of XFS_BUF_SET_COUNT() macro

Sorry, I'd still like to merge these but they need a rebase now.
And did the casting-wars between dchinner & hch ever get resolved?

Thanks,
-Eric
