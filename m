Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdJXTOf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 15:14:35 -0400
Date: Tue, 24 Oct 2017 15:14:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm log writes: Add support for inline data buffers
Message-ID: <20171024191431.GA22902@redhat.com>
References: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fb.com>, Alasdair Kergon <agk@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Fri, Oct 20 2017 at  1:24am -0400,
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> Currently dm-log-writes supports writing filesystem data via BIOs, and
> writing internal metadata from a flat buffer via write_metadata().
> 
> For DAX writes, though, we won't have a BIO, but will instead have an
> iterator that we'll want to use to fill a flat data buffer.
> 
> So, create write_inline_data() which allows us to write filesystem data
> using a flat buffer as a source, and wire it up in log_one_block().
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Hi,

I picked this up but tweaked some whitespace and couple style nits, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-4.15/dm&id=6a697d036324c7fbe63fb49599027269006161e7

Thanks,
Mike
