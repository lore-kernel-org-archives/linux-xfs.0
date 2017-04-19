Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55039 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1762098AbdDSKaa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 06:30:30 -0400
Subject: Re: [PATCH 2/8] nowait aio: Introduce RWF_NOWAIT
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-3-rgoldwyn@suse.de>
 <20170419063930.GB20053@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <2d816e3e-3625-7ebd-8550-68a7cc9c1a2e@suse.de>
Date: Wed, 19 Apr 2017 05:30:24 -0500
MIME-Version: 1.0
In-Reply-To: <20170419063930.GB20053@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com



On 04/19/2017 01:39 AM, Christoph Hellwig wrote:
> 
>> @@ -1593,6 +1593,11 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>>  	}
>>  
>>  	req->common.ki_flags |= iocb_rw_flags(iocb->aio_rw_flags);
>> +	if ((req->common.ki_flags & IOCB_NOWAIT) &&
>> +	    !(req->common.ki_flags & IOCB_DIRECT)) {
>> +			ret = -EINVAL;
>> +			goto out_put_req;
>> +		}
> 
> Wrong indentation.  Also I think this should be EOPNOTSUPP here.
> 

Do we plan to add support for nowait in buffered I/O in the future? It
is just too complicated. EINVAL suits best in this case.

-- 
Goldwyn
