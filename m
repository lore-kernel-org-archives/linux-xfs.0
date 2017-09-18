Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25081 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754342AbdIRSAb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 14:00:31 -0400
Date: Mon, 18 Sep 2017 11:00:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] xfs: add online uevent for mount operation
Message-ID: <20170918180021.GH6540@magnolia>
References: <1504507859-39323-1-git-send-email-houtao1@huawei.com>
 <20170906005208.GE29261@wotan.suse.de>
 <8d432f76-4973-7cdd-280b-3c6d541416fd@huawei.com>
 <20170908004905.GE17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908004905.GE17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Hou Tao <houtao1@huawei.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Fri, Sep 08, 2017 at 10:49:05AM +1000, Dave Chinner wrote:
> On Thu, Sep 07, 2017 at 04:56:56PM +0800, Hou Tao wrote:
> > > Note that kobject_uevent_env() can also fail during
> > > netlink_broadcast_filtered(),  so perhaps we should consider all errors well
> > > here.
> > Yes, to deliver the uevent reliably we need to handle the error returned by
> > kobject_uevent_evn(), and abort the filesystem mount if any error occurs.
> 
> Failing to delivery a mount uevent is not a fatal error. An
> inconvenience, yes, but it does not prevent the filesystem from
> operating. We do not consider errors when other user events we push to
> userspace through netlink fail (e.g. quota warnings), so I don't see
> why we should treat this any differently, especially as a user can
> still configure the filesystem as they need without the mount
> uevent...

I agree with Dave that it seems excessive to fail the mount just because
the uevent transmission failed.  I don't see any use case where it's
absolutely critical that a configuration knob gets turned.

I would also reiterate that I want to see at least an RFC of the
userland side of this because I'd rather not have to maintain a kernel
feature that is totally unused by upstream userspace.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
