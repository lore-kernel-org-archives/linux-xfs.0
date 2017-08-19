Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30905 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdHSQUa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 12:20:30 -0400
Date: Sat, 19 Aug 2017 09:20:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Estimate xfs_repair run time
Message-ID: <20170819162025.GT4796@magnolia>
References: <22ed5cf73260ae39bf59779b302d8ad3@assyoma.it>
 <d80ca25cd28ec433c39a7d7d22c4e371@assyoma.it>
 <20170819154804.GS4796@magnolia>
 <3fcdaa5ea4365a1ddb7c76070236e6b3@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fcdaa5ea4365a1ddb7c76070236e6b3@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Sat, Aug 19, 2017 at 06:15:28PM +0200, Gionatan Danti wrote:
> Il 19-08-2017 17:48 Darrick J. Wong ha scritto:
> >Should work fine; be sure to set the extent size hint to reduce
> >fragmentation.
> 
> Hi, do you mean tuning the "allocsize" mount option? If I remember
> correctly, this parameter should be auto-tuned by XFS during normal
> operation, right?

I meant the per-inode extent size hint.  See 'extsize' in the xfs_io manpage.

> Any thoughts on the xfs_repair matter?

{yes, yes, depends on which spindle(s) metadata end up on and how many
files cross AGs} in that order. :)

--D

> Thanks.
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
