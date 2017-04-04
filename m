Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38289 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753289AbdDDSlR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 14:41:17 -0400
Subject: Re: [PATCH 6/8] nowait aio: ext4
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-7-rgoldwyn@suse.de>
 <20170404075853.GB28522@quack2.suse.cz>
 <20170404084122.GA10252@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <d6dac6ec-c71c-0082-972f-61e7299ed418@suse.de>
Date: Tue, 4 Apr 2017 13:41:09 -0500
MIME-Version: 1.0
In-Reply-To: <20170404084122.GA10252@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 04/04/2017 03:41 AM, Christoph Hellwig wrote:
> On Tue, Apr 04, 2017 at 09:58:53AM +0200, Jan Kara wrote:
>> FS_NOWAIT looks a bit too generic given these are filesystem feature flags.
>> Can we call it FS_NOWAIT_IO?
> 
> It's way to generic as it's a feature of the particular file_operations
> instance.  But once we switch to using RWF_* we can just the existing
> per-op feature checks for thos and the per-fs flag should just go away.
> 

I am working on incorporating RWF_* flags. However, I am not sure how
RWF_* flags would get rid of FS_NOWAIT/FS_NOWAIT_IO. Since most of
"blocking" information is with the filesystem, it is a per-filesystem
flag to block out (EOPNOTSUPP) the filesystems which do not support it.

-- 
Goldwyn
