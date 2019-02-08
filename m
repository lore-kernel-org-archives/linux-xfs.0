Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbfBHJCs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Feb 2019 04:02:48 -0500
Date: Fri, 8 Feb 2019 10:02:45 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC] The end of the DAX experiment
Message-ID: <20190208090245.GA8038@linux-x5ow.site>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <d7790ae27161db2fcf0b10a7d5d67de833f2d3fe.camel@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d7790ae27161db2fcf0b10a7d5d67de833f2d3fe.camel@hpe.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>

On 07/02/2019 22:51, Kani, Toshi wrote:
> I've also had multiple users complained about 'mount -o dax' succeeded
> by falling back to non-dax despite of their intent.  Such users wasted
> many hours without knowing their setup error / current restrictions.
> The next think they always ask is how to check if dax is enabled in such
> case, and they are not happy about limited interfaces (ex. look for
> mount entry in /proc/mounts), either.

Exactly, there's a need for admins and user-space applications to check if they
can use DAX or not. See also [1] for reference.

> Same as above.  Such enhancement should be possible after EXPERIMENTAL
> is removed from 'mount -o dax'.  IOW, a separate EXPERIMENTAL message
> can be shown when user requests per-directory dax.

Just as a data point here, in our Kernels we've removed the EXPERIMENTAL
warning for DAX on XFS (but not EXT4) and we are supporting it for some limited
use-cases.

[1] https://lore.kernel.org/linux-fsdevel/20181002100531.GC4135@quack2.suse.cz/

Byte,
        Johannes
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
