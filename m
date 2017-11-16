Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:32198 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932780AbdKPVbu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 16:31:50 -0500
Date: Thu, 16 Nov 2017 14:31:47 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH v3] generic: add test for DAX MAP_SYNC support
Message-ID: <20171116213147.GB27448@linux.intel.com>
References: <CAOQ4uxh25JmAv3DjCp11fAfpHVP=d2sp+=Gk4SxYfBtmOgaUPw@mail.gmail.com>
 <20171025204704.3382-1-ross.zwisler@linux.intel.com>
 <20171025215638.GA30335@dastard>
 <20171116212815.GA27448@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171116212815.GA27448@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Amir Goldstein <amir73il@gmail.com>, Josef Bacik <jbacik@fb.com>, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Thu, Nov 16, 2017 at 02:28:15PM -0700, Ross Zwisler wrote:
> On Thu, Oct 26, 2017 at 08:56:38AM +1100, Dave Chinner wrote:
> > Perhaps stat -c %b $SCRATCH_MNT/test ?
> 
> Maybe, but doesn't the output of 'stat -c %b' depend on the block size the
> filesystem is using?  I think to use stat I'd have to check both %b and %B,
> and account for different block sizes, or do some shell math.  I think it may
> be easier to just use du.

Ah, never mind, I think you meant 'stat -c %s' - that's cleaner, will switch.
