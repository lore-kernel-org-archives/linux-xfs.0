Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35609 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S976106AbdDXSSn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2017 14:18:43 -0400
Received: by mail-wm0-f43.google.com with SMTP id w64so3972125wma.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2017 11:18:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170424152348.GE9112@infradead.org>
References: <20170424132259.8680-1-jlayton@redhat.com> <20170424132259.8680-6-jlayton@redhat.com>
 <20170424152348.GE9112@infradead.org>
From: Mike Marshall <hubcap@omnibond.com>
Date: Mon, 24 Apr 2017 14:18:41 -0400
Message-ID: <CAOg9mSQPqSVLXqovLiezKycWJ+U2J1UZJ0tO2p8TeKh8WP2S2g@mail.gmail.com>
Subject: Re: [PATCH v3 05/20] orangefs: don't call filemap_write_and_wait from fsync
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-cifs@vger.kernel.org, linux-mm <linux-mm@kvack.org>, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, jack@suse.com, Al Viro <viro@zeniv.linux.org.uk>, corbet@lwn.net, neilb@suse.de, Chris Mason <clm@fb.com>, Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>

I've been running it here...

Acked-by: Mike Marshall <hubcap@omnibond.com>

On Mon, Apr 24, 2017 at 11:23 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Looks fine,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
