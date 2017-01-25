Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49433 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdAYF2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 00:28:13 -0500
Date: Tue, 24 Jan 2017 21:28:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] tools/find-api-violations: fix fs -> fsr in the
 directory list
Message-ID: <20170125052805.GJ9134@birch.djwong.org>
References: <20170124172210.GC9134@birch.djwong.org>
 <1560023.HPyvzjyxDL@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560023.HPyvzjyxDL@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jan 25, 2017 at 10:31:07AM +0530, Chandan Rajendra wrote:
> On Tuesday, January 24, 2017 09:22:10 AM Darrick J. Wong wrote:
> > Fix a stupid typo in the original commit.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tools/find-api-violations.sh |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/find-api-violations.sh b/tools/find-api-violations.sh
> > index 7937749..b4b8de5 100755
> > --- a/tools/find-api-violations.sh
> > +++ b/tools/find-api-violations.sh
> > @@ -6,7 +6,7 @@
> > 
> >  # NOTE: This script doesn't look for API violations in function parameters.
> > 
> > -tool_dirs="copy db estimate fs fsck fsr growfs io mdrestore mkfs quota repair rtcp"
> > +tool_dirs="copy db estimate fsr fsck fsr growfs io mdrestore mkfs quota repair rtcp"
> >
>                                
> fsr is already part of the list. With this patch, we now have a duplicate
> entry. Or, Am I missing something very obvious?

Pah, it's missing logprint too.

Ok, respin....

--D

> 
> -- 
> chandan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
