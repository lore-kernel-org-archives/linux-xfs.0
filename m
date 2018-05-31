Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:52401 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755556AbeEaRTN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 13:19:13 -0400
Received: by mail-wm0-f67.google.com with SMTP id 18-v6so49802161wml.2
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 10:19:12 -0700 (PDT)
Date: Thu, 31 May 2018 19:19:09 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/4 V2] Remove a few macros
Message-ID: <20180531171909.cedwobpqlaf2h5ly@odin.usersys.redhat.com>
References: <20180307090506.30199-1-cmaiolino@redhat.com>
 <b5e4681b-8198-82fc-e4da-bfbad08cf32d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5e4681b-8198-82fc-e4da-bfbad08cf32d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, May 31, 2018 at 11:58:51AM -0500, Eric Sandeen wrote:
> On 3/7/18 3:05 AM, Carlos Maiolino wrote:
> > Hi,
> > 
> > this is a second version of the patchset aimed to clean up some old macros from
> > xfsprogs, as the objective to bring xfs_buf handling code closer to kernel code.
> > 
> > It fixes some pointer castings Dave mentioned on the V1 patch, also, it removes
> > a few unneeded castings I spotted while reviewing the ones Dave mentioned.
> > 
> > Cheers
> > 
> > Carlos Maiolino (4):
> >    Get rid of XFS_BUF_PTR() macro
> >    Get rid of XFS_BUF_TARGET() macro
> >    get rid of XFS_BUF_COUNT() macro
> >    Get rid of XFS_BUF_SET_COUNT() macro
> 
> Sorry, I'd still like to merge these but they need a rebase now.
> And did the casting-wars between dchinner & hch ever get resolved?
> 


I don't know actually, I don't remember seeing Dave replying agreeing or not
with hch

> Thanks,
> -Eric

-- 
Carlos
