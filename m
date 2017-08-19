Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22875 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbdHSPsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 11:48:10 -0400
Date: Sat, 19 Aug 2017 08:48:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Estimate xfs_repair run time
Message-ID: <20170819154804.GS4796@magnolia>
References: <22ed5cf73260ae39bf59779b302d8ad3@assyoma.it>
 <d80ca25cd28ec433c39a7d7d22c4e371@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d80ca25cd28ec433c39a7d7d22c4e371@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Sat, Aug 19, 2017 at 02:14:23PM +0200, Gionatan Danti wrote:
> Sorry, reposting to CC me...
> 
> Il 19-08-2017 12:05 Gionatan Danti ha scritto:
> >Hi list,
> >using XFS on relatively big filesystems (> 8TB) I was wondering if it
> >is possible to estimate how much time an emergency "xfs_repair" would
> >take.
> >
> >Some specific questions:
> >- will total time depend on how much the filesystem is filled (I think
> >so...)?
> >- will total time depend on how data are layed on the physical disks
> >(ie: fragmented vs sequential)?
> >- will total time scale down with increasing spindle count (ie: single
> >disk vs 4-way RAID10)?
> >
> >On a related question: I generally use LVM to segregate/isolate my
> >virtual machine images. In this manner, even a completely blowed up
> >filesystem on one LV can not affect other LV.
> >
> >How do you feel using a single big LV + XFS + preallocated RAW disk
> >images? Can a problem on the main XFS filesystem be contained on only
> >some VM files, or it really risks to destroy the entire filesystem?

Should work fine; be sure to set the extent size hint to reduce fragmentation.

--D

> >
> >Thank you all.
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
