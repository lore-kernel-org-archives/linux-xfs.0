Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39555 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751526AbdHNIaP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Aug 2017 04:30:15 -0400
Date: Mon, 14 Aug 2017 10:30:12 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170814083012.GB16353@quack2.suse.cz>
References: <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz>
 <20170801110241.GE6742@infradead.org>
 <20170801112603.GG4215@quack2.suse.cz>
 <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
 <20170811100327.GD7064@infradead.org>
 <CAPcyv4hgqh8tHeWDNRnJnvwDh7hiFU8+3O0VWAHFQOEvPna11Q@mail.gmail.com>
 <20170813092556.GA19019@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170813092556.GA19019@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Sun 13-08-17 02:25:56, Christoph Hellwig wrote:
> On Sat, Aug 12, 2017 at 07:44:14PM -0700, Dan Williams wrote:
> > How about MAP_SYNC == (MAP_SHARED|MAP_PRIVATE)? On older kernels that
> > should get -EINVAL, and on new kernels it means SYNC+SHARED.
> 
> Cute trick, but I'd hate to waster it just for our little flag.
> 
> How about:
> 
> #define __MAP_VALIDATE		MAP_SHARED|MAP_PRIVATE
> #define MAP_SYNC		0x??? | __MAP_VALIDATE
> 
> so that we can reuse that trick for any new flag?

Heh, that's such an ugly hack that it is cute ;)... I'll use this
definition of MAP_SYNC in my patches and send new version of the series
(probably today in the afternoon if the testing goes fine).

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
