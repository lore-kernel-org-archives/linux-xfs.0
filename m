Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405627AbfFKROq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Jun 2019 13:14:46 -0400
Date: Tue, 11 Jun 2019 13:14:17 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v12 4/7] dm: enable synchronous dax
Message-ID: <20190611171416.GA1248@redhat.com>
References: <20190611163802.25352-1-pagupta@redhat.com>
 <20190611163802.25352-5-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611163802.25352-5-pagupta@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>
Cc: dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong.eric@gmail.com, pbonzini@redhat.com, yuval.shaia@oracle.com, kilobyte@angband.pl, jstaron@google.com, rdunlap@infradead.org

On Tue, Jun 11 2019 at 12:37pm -0400,
Pankaj Gupta <pagupta@redhat.com> wrote:

> This patch sets dax device 'DAXDEV_SYNC' flag if all the target
> devices of device mapper support synchrononous DAX. If device
> mapper consists of both synchronous and asynchronous dax devices,
> we don't set 'DAXDEV_SYNC' flag.
> 
> 'dm_table_supports_dax' is refactored to pass 'iterate_devices_fn'
> as argument so that the callers can pass the appropriate functions.
> 
> Suggested-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>

Thanks, and for the benefit of others, passing function pointers like
this is perfectly fine IMHO because this code is _not_ in the fast
path.  These methods are only for device creation.

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
