Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50748 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfGRMdM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 08:33:12 -0400
Date: Thu, 18 Jul 2019 05:33:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] iomap: generalize IOMAP_INLINE to cover tail-packing
 case
Message-ID: <20190718123309.GB21252@infradead.org>
References: <20190703075502.79782-1-yuchao0@huawei.com>
 <CAHpGcM+s77hKMXo=66nWNF7YKa3qhLY9bZrdb4-Lkspyg2CCDw@mail.gmail.com>
 <39944e50-5888-f900-1954-91be2b12ea5b@huawei.com>
 <20190711122831.3970-1-agruenba@redhat.com>
 <cb41acf2-f222-102a-d31b-02243c77996c@huawei.com>
 <CAHc6FU5tBXeJ6xzZzfCQeaQFy-NZ5ryZ+QMGLu7yxcGXwYisNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU5tBXeJ6xzZzfCQeaQFy-NZ5ryZ+QMGLu7yxcGXwYisNw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Chao Yu <yuchao0@huawei.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Gao Xiang <gaoxiang25@huawei.com>, chao@kernel.org

On Fri, Jul 12, 2019 at 01:54:07PM +0200, Andreas Gruenbacher wrote:
> Yes, probably by returning i_blocksize(inode) after
> iomap_read_inline_data, but that alone isn't enough to make the patch
> work completely. This really needs a review from Christoph and careful
> testing of all the code paths.

Well, lets start with the testing.  Can we get a coherent series that
includes the erofs bits?
