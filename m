Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56443 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S978020AbdDXVLB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 17:11:01 -0400
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-6-rgoldwyn@suse.de>
 <20170419064505.GD20053@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <3485e23c-3a4d-23a5-50d5-69c824353d1a@suse.de>
Date: Mon, 24 Apr 2017 16:10:55 -0500
MIME-Version: 1.0
In-Reply-To: <20170419064505.GD20053@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 04/19/2017 01:45 AM, Christoph Hellwig wrote:
> On Fri, Apr 14, 2017 at 07:02:54AM -0500, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
> 
>> +	/* Request queue supports BIO_NOWAIT */
>> +	queue_flag_set_unlocked(QUEUE_FLAG_NOWAIT, q);
> 
> BIO_NOWAIT is gone.  And the comment would not be needed if the
> flag had a more descriptive name, e.g. QUEUE_FLAG_NOWAIT_SUPPORT.
> 
> And I think all request based drivers should set the flag implicitly
> as ->queuecommand can't sleep, and ->queue_rq only when it's always
> offloaded to a workqueue when the BLK_MQ_F_BLOCKING flag is set.
> 

We introduced QUEUE_FLAG_NOWAIT for devices which would not wait for
request completions. The ones which wait are MD devices because of sync
or suspend operations.

The only user of BLK_MQ_F_NONBLOCKING seems to be nbd. As you mentioned,
it uses the flag to offload it to a workqueue.

The other way to do it implicitly is to change the flag to
BLK_MAY_BLOCK_REQS and use it for devices which do wait such as md/dm.
Is that what you are hinting at? Or do you have something else in mind?


-- 
Goldwyn
