Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52392 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfBVDBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Feb 2019 22:01:43 -0500
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async discard?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
        <20190217210948.GB14116@dastard>
        <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
        <20190220234723.GA5999@localhost.localdomain>
        <45c27fea-6d74-2adc-fe9d-e314ce4f3672@suse.com>
Date: Thu, 21 Feb 2019 22:01:24 -0500
In-Reply-To: <45c27fea-6d74-2adc-fe9d-e314ce4f3672@suse.com> (Jeff Mahoney's
        message of "Thu, 21 Feb 2019 18:55:05 -0500")
Message-ID: <yq17edsil17.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: Keith Busch <keith.busch@intel.com>, Ric Wheeler <ricwheeler@gmail.com>, Dave Chinner <david@fromorbit.com>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org


Jeff,

> We've always been told "don't worry about what the internal block size
> is, that only matters to the FTL."  That's obviously not true, but
> when devices only report a 512 byte granularity, we believe them and
> will issue discard for the smallest size that makes sense for the file
> system regardless of whether it makes sense (internally) for the SSD.
> That means 4k for pretty much anything except btrfs metadata nodes,
> which are 16k.

The devices are free to report a bigger discard granularity. We already
support and honor that (for SCSI, anyway). It's completely orthogonal to
reported the logical block size, although it obviously needs to be a
multiple.

The real problem is that vendors have zero interest in optimizing for
discard. They are so confident in their FTL and overprovisioning that
they don't view it as an important feature. At all.

Consequently, many of the modern devices that claim to support discard
to make us software folks happy (or to satisfy a purchase order
requirements) complete the commands without doing anything at all.
We're simply wasting queue slots.

Personally, I think discard is dead on anything but the cheapest
devices.  And on those it is probably going to be
performance-prohibitive to use it in any other way than a weekly fstrim.

-- 
Martin K. Petersen	Oracle Linux Engineering
