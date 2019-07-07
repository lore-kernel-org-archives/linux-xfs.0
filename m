Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:54495 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725901AbfGGQgY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Jul 2019 12:36:24 -0400
Date: Sun, 7 Jul 2019 12:34:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v15 6/7] ext4: disable map_sync for async flush
Message-ID: <20190707163415.GA19775@mit.edu>
References: <20190705140328.20190-1-pagupta@redhat.com>
 <20190705140328.20190-7-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705140328.20190-7-pagupta@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>
Cc: dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, adilger.kernel@dilger.ca, darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong.eric@gmail.com, pbonzini@redhat.com, yuval.shaia@oracle.com, kilobyte@angband.pl, jstaron@google.com, rdunlap@infradead.org, snitzer@redhat.com

On Fri, Jul 05, 2019 at 07:33:27PM +0530, Pankaj Gupta wrote:
> Dont support 'MAP_SYNC' with non-DAX files and DAX files
> with asynchronous dax_device. Virtio pmem provides
> asynchronous host page cache flush mechanism. We don't
> support 'MAP_SYNC' with virtio pmem and ext4.
> 
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Acked-by: Theodore Ts'o <tytso@mit.edu>
