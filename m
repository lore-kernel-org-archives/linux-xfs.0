Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56353 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752944AbdIHAv4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 20:51:56 -0400
Date: Fri, 8 Sep 2017 10:49:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: add online uevent for mount operation
Message-ID: <20170908004905.GE17782@dastard>
References: <1504507859-39323-1-git-send-email-houtao1@huawei.com>
 <20170906005208.GE29261@wotan.suse.de>
 <8d432f76-4973-7cdd-280b-3c6d541416fd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d432f76-4973-7cdd-280b-3c6d541416fd@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Thu, Sep 07, 2017 at 04:56:56PM +0800, Hou Tao wrote:
> > Note that kobject_uevent_env() can also fail during
> > netlink_broadcast_filtered(),  so perhaps we should consider all errors well
> > here.
> Yes, to deliver the uevent reliably we need to handle the error returned by
> kobject_uevent_evn(), and abort the filesystem mount if any error occurs.

Failing to delivery a mount uevent is not a fatal error. An
inconvenience, yes, but it does not prevent the filesystem from
operating. We do not consider errors when other user events we push to
userspace through netlink fail (e.g. quota warnings), so I don't see
why we should treat this any differently, especially as a user can
still configure the filesystem as they need without the mount
uevent...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
