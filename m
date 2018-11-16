Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42779 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390040AbeKQCxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 21:53:37 -0500
Received: by mail-pf1-f195.google.com with SMTP id 64so7181757pfr.9
        for <linux-xfs@vger.kernel.org>; Fri, 16 Nov 2018 08:40:31 -0800 (PST)
Date: Fri, 16 Nov 2018 08:40:28 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V10 18/19] block: kill QUEUE_FLAG_NO_SG_MERGE
Message-ID: <20181116164028.GW23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-19-ming.lei@redhat.com>
 <20181116021811.GM23828@vader>
 <20181116135922.GO3165@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116135922.GO3165@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Fri, Nov 16, 2018 at 02:59:22PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 15, 2018 at 06:18:11PM -0800, Omar Sandoval wrote:
> > This commit message wasn't very clear. Is it the case that
> > QUEUE_FLAG_NO_SG_MERGE is no longer set by any drivers?
> 
> I think he wants to say that not doing S/G merging is rather pointless
> with the current setup of the I/O path, as it isn't going to save
> you a significant amount of cycles.

Okay, that makes sense. Ming, you can add

Reviewed-by: Omar Sandoval <osandov@fb.com>
