Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754269AbdLNTPu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Dec 2017 14:15:50 -0500
Subject: Re: Detecting RWF_NOWAIT support
References: <b45afd09-5fa8-74ac-4ba4-9dc9074e30cf@scylladb.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <4ae3426d-8104-c243-72e4-671e89401b23@suse.de>
Date: Thu, 14 Dec 2017 13:15:45 -0600
MIME-Version: 1.0
In-Reply-To: <b45afd09-5fa8-74ac-4ba4-9dc9074e30cf@scylladb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org



On 12/14/2017 11:38 AM, Avi Kivity wrote:
> I'm looking to add support for RWF_NOWAIT within a linux-aio iocb.
> Naturally, I need to detect at runtime whether the kernel support
> RWF_NOWAIT or not.
> 
> 
> The only method I could find was to issue an I/O with RWF_NOWAIT set,
> and look for errors. This is somewhat less than perfect:
> 
>  - from the error, I can't tell whether RWF_NOWAIT was the problem, or
> something else. If I enable a number of new features, I have to run
> through all combinations to figure out which ones are supported and
> which are not.

Here is the return codes for RWF_NOWAIT
EINVAL - not supported (older kernel)
EOPNOTSUPP - not supported
EAGAIN - supported but could not complete because I/O will be delayed
0 - supported and I/O completed (success).

> 
>  - RWF_NOWAIT support is per-filesystem, so I can't just remember not to
> enable RWF_NOWAIT globally, I have to track it per file.

Yes, the support is per filesystem. So, the application must know if the
filesystem supports it, possibly by performing a small I/O.

-- 
Goldwyn
