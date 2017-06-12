Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37349 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752383AbdFLWiU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 18:38:20 -0400
Subject: Re: [PATCH 0/10 v11] No wait AIO
References: <20170606111939.27272-1-rgoldwyn@suse.de>
 <20170608073910.GB9292@infradead.org>
 <20170610053441.GD6365@ZenIV.linux.org.uk>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <58bbe95e-5a4a-4387-3a00-16ed2e861bd3@suse.de>
Date: Mon, 12 Jun 2017 17:38:13 -0500
MIME-Version: 1.0
In-Reply-To: <20170610053441.GD6365@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com



On 06/10/2017 12:34 AM, Al Viro wrote:
> On Thu, Jun 08, 2017 at 12:39:10AM -0700, Christoph Hellwig wrote:
>> As already indicated this whole series looks fine to me.
>>
>> Al: are you going to pick this up?  Or Andrew?
> 
> The main issue here is "let's bail out from ->write_iter() instances"
> patch.  It very obviously has holes in coverage.
> 
> Could we have FMODE_AIO_NOWAIT and make those who claim to support it
> set that in ->open()?  And make aio check that and bail out if asked
> for nowait on a file without that flag...
> 

Yes, I would agree.

We had FS_NOWAIT in filesystem type flags (in v3), but retracted it
later in v4.

Another option could be to keep the feature against FS_REQUIRES_DEV to
rule out filesystems which are not local, but it again has the problem
of holes in coverage.

I will work on adding FMODE_AIO_NOWAIT in the meantime.

Thanks,

-- 
Goldwyn
