Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43734 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750898AbdE2Cid (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 28 May 2017 22:38:33 -0400
Subject: Re: [PATCH 0/10 v9] No wait AIO
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170528092728.GA14519@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <acb0fc57-5005-4422-9c42-3345e892ecb2@suse.de>
Date: Sun, 28 May 2017 21:38:27 -0500
MIME-Version: 1.0
In-Reply-To: <20170528092728.GA14519@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk



On 05/28/2017 04:27 AM, Christoph Hellwig wrote:
>>  Changes since v8:
>>  + Err out AIO reads with -EINVAL flagged as RWF_NOWAIT
> 
> Ugg, why?  Reads aren't really treated any different than writes in
> the direct I/O code.

This effort focused on writes only.

>From the point of view of the application/user, reads are usually
required to complete with success. I don't see a scenario where reads()
would need the nowait feature. If there is a use case, I'd be happy to
add and support it.

-- 
Goldwyn
