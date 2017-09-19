Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58368 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdISOeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 10:34:08 -0400
Date: Tue, 19 Sep 2017 07:34:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] test race when checking i_size on direct i/o read
Message-ID: <20170919143406.GA7437@infradead.org>
References: <799f63d9-de03-eab3-1e6e-cd747aa04c36@redhat.com>
 <20170919073616.GP8034@eguan.usersys.redhat.com>
 <20170919141351.GB3487@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919141351.GB3487@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, Eric Sandeen <sandeen@redhat.com>, fstests <fstests@vger.kernel.org>, Zheng Liu <wenqing.lz@taobao.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 10:13:52AM -0400, Brian Foster wrote:
> Can we pass a boolean or flag to xfs_iomap_write_unwritten() to have it
> update the incore i_size after unwritten extent conversion? Then move
> (or remove) the associated update from xfs_dio_write_end_io().

I don't think we even need a flag - all three callers of
xfs_iomap_write_unwritten want to update the file size.
