Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751016AbdISO6z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 10:58:55 -0400
Date: Tue, 19 Sep 2017 10:58:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] test race when checking i_size on direct i/o read
Message-ID: <20170919145851.GD3487@bfoster.bfoster>
References: <799f63d9-de03-eab3-1e6e-cd747aa04c36@redhat.com>
 <20170919073616.GP8034@eguan.usersys.redhat.com>
 <20170919141351.GB3487@bfoster.bfoster>
 <20170919143406.GA7437@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919143406.GA7437@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eryu Guan <eguan@redhat.com>, Eric Sandeen <sandeen@redhat.com>, fstests <fstests@vger.kernel.org>, Zheng Liu <wenqing.lz@taobao.com>, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 07:34:06AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 19, 2017 at 10:13:52AM -0400, Brian Foster wrote:
> > Can we pass a boolean or flag to xfs_iomap_write_unwritten() to have it
> > update the incore i_size after unwritten extent conversion? Then move
> > (or remove) the associated update from xfs_dio_write_end_io().
> 
> I don't think we even need a flag - all three callers of
> xfs_iomap_write_unwritten want to update the file size.

Sounds reasonable to me. I wasn't sure if there was anything special
about the pnfs case. isize should probably already be stable in the
writeback case, so perhaps this would be fine as long as we ensure the
in-core size only increases (as we currently do for di_size).

Brian
