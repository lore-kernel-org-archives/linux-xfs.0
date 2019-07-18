Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:33156 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfGRN1z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jul 2019 09:27:55 -0400
Subject: Re: [RFC PATCH] iomap: generalize IOMAP_INLINE to cover tail-packing
 case
References: <20190703075502.79782-1-yuchao0@huawei.com>
 <CAHpGcM+s77hKMXo=66nWNF7YKa3qhLY9bZrdb4-Lkspyg2CCDw@mail.gmail.com>
 <39944e50-5888-f900-1954-91be2b12ea5b@huawei.com>
 <20190711122831.3970-1-agruenba@redhat.com>
 <20190718123155.GA21252@infradead.org>
From: Gao Xiang <gaoxiang25@huawei.com>
Message-ID: <cb859e68-1f7f-48a6-593b-4047963086ba@huawei.com>
Date: Thu, 18 Jul 2019 21:27:41 +0800
MIME-Version: 1.0
In-Reply-To: <20190718123155.GA21252@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Chao Yu <yuchao0@huawei.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, chao@kernel.org



On 2019/7/18 20:31, Christoph Hellwig wrote:
> That being said until the tail packing fs (erofs?) actually uses
> buffer_heads we should not need this hunk, and I don't think erofs
> should have any reason to use buffer_heads.

Yes, erofs will not use buffer_head to support sub-page blocksize
in the long term. too heavy and no need...

Thanks,
Gao Xiang
