Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39835 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbdCPNqi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 09:46:38 -0400
Subject: Re: [PATCH 3/8] nowait aio: return if direct write will trigger
 writeback
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-4-rgoldwyn@suse.de>
 <20170316132052.GG4033@bombadil.infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <8a799ad5-6481-66d3-7f21-6eaeb33eaa7b@suse.de>
Date: Thu, 16 Mar 2017 08:46:31 -0500
MIME-Version: 1.0
In-Reply-To: <20170316132052.GG4033@bombadil.infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 03/16/2017 08:20 AM, Matthew Wilcox wrote:
> On Wed, Mar 15, 2017 at 04:51:02PM -0500, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> Find out if the write will trigger a wait due to writeback. If yes,
>> return -EAGAIN.
>>
>> This introduces a new function filemap_range_has_page() which
>> returns true if the file's mapping has a page within the range
>> mentioned.
>>
>> Return -EINVAL for buffered AIO: there are multiple causes of
>> delay such as page locks, dirty throttling logic, page loading
>> from disk etc. which cannot be taken care of.
> 
> Also, this patch only touches the write path; we have a similar call to
> write_and_wait_range() in generic_file_read_iter().
> 

This patch series is concerned with direct-write AIO paths only.

-- 
Goldwyn
