Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24010 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752910AbdKORbG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 12:31:06 -0500
Date: Wed, 15 Nov 2017 09:31:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Disabling barriers on NVC-backed HDD
Message-ID: <20171115173100.GD5119@magnolia>
References: <8b91c685e344bdc5d084b11fab1d50af@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b91c685e344bdc5d084b11fab1d50af@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 15, 2017 at 06:01:17PM +0100, Gionatan Danti wrote:
> Hi list,
> I'm not sure this is the correct list to post my question; if so, feel free
> to ignore this message.
> 
> On XFS FAQs I (rightfully) read that barrier should be *always* enabled (and
> they are, by default), unless a write-loss protected writeback cache is used
> at the RAID card level. So far, so good.
> 
> Newer HDDs has themselves have a non-volatile cache (NVC) of some sort,
> basically:
> - DRAM + eMCL: in a powerloss event, the DRAM cache is immediately dumped on
> the eMLC flash;
> - DRAM + NOR flash: NOR mirrors a (small) portion of the DRAM cache, used
> for write acceleration purpose;
> - dedicated "dump" areas on the disks: they effectively mirror a portion of
> the DRAM cache.
> 
> My question is: do you think it is safe to disable barriers, both for XFS
> and in general terms, on these disks? Or they should be considered as the
> same "dumb" unprotected DRAM caches found on classical HDD?
> 
> From a side, these *are* powerloss-protected caches. Problem is that all
> these power-protection schemes are considered "secret sauce / trade secret"
> by HDD vendors and, for this reason, there are very little (if any)
> informations on their inner working.

I would evaluate these drives to find out if you really /can/ yank the
power without losing anything.

That said, if the manufacturers aren't willing to tell you how that
feature works, I'd just as soon pretend the feature didn't exist and
continue sending flushes to the drive.

FWIW if the drive really /does/ have a non-volatile WC then a flush
should have nearly zero overhead.  (Or so you'd think...)

--D

> Regards.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
