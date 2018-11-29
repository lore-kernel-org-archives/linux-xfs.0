Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35240 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbeK2NYk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 08:24:40 -0500
Received: by mail-pf1-f194.google.com with SMTP id z9so231647pfi.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 18:20:57 -0800 (PST)
Subject: Re: [PATCH V12 00/20] block: support multi-page bvec
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <7096bc4e-0617-29d0-a90d-ae7caf09a16d@kernel.dk>
 <20181129012959.GC23249@ming.t460p>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1983a2f5-07be-4102-fedc-54e2ad2e16dc@kernel.dk>
Date: Wed, 28 Nov 2018 19:20:51 -0700
MIME-Version: 1.0
In-Reply-To: <20181129012959.GC23249@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On 11/28/18 6:30 PM, Ming Lei wrote:
>> I'm going back and forth on those one a bit. Any concerns with
>> pushing this to 4.22?
> 
> My only one concern is about the warning of
> "blk_cloned_rq_check_limits: over max segments limit" on dm multipath,
> and seems Ewan and Mike is waiting for this fix.

Not familiar with this issue, can you post a link to it? I'd be fine
working around anything until 4.22, it's not going to be a new issue.

-- 
Jens Axboe
