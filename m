Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:35478 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbeA2SuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 13:50:13 -0500
Received: by mail-it0-f46.google.com with SMTP id e1so10491633ita.0
        for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2018 10:50:12 -0800 (PST)
Subject: Re: [PATCH 2/2] xfs: remove assert to check bytes returned
References: <20180129145741.29486-1-rgoldwyn@suse.de>
 <20180129145741.29486-2-rgoldwyn@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4f2acf1e-6c73-05b9-d9fc-1a07fa0627a7@kernel.dk>
Date: Mon, 29 Jan 2018 11:50:09 -0700
MIME-Version: 1.0
In-Reply-To: <20180129145741.29486-2-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, ak@linux.intel.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On 1/29/18 7:57 AM, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Since we can return less than count in case of partial direct
> writes, remove the ASSERT.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Acked-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Minot nit - you should probably reorder this patch before the other one,
otherwise you'll have a point in the tree where it can knowingly
trigger.

-- 
Jens Axboe

