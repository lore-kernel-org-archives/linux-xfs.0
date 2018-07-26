Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46032 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbeGZCdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 22:33:37 -0400
Date: Wed, 25 Jul 2018 18:19:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/10] xfs_scrub: only retry non-permanent repair failures
Message-ID: <20180726011909.GC30972@magnolia>
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <153006772140.20121.17551661183487526760.stgit@magnolia>
 <c2b7af0b-8f6e-b7d0-8972-0aec156f5707@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2b7af0b-8f6e-b7d0-8972-0aec156f5707@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jul 25, 2018 at 06:16:15PM -0700, Eric Sandeen wrote:
> On 6/26/18 7:48 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If a repair fails, we want to retry the repair if the error was a
> > transient one, such as ENOMEM.  For "permanent" ones (shutdown fs,
> > repair not supported by kernel, readonly fs) there's no point to
> > retrying them so just error out immediately.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Is there something that stops infinite retries?
> (I need to get this all applied for context I guess)

If scrub notices the set of unrepaired things stops shrinking it'll try
them all again single-threaded and complain about anything that didn't
get fixed.

--D

> But anyway,
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
