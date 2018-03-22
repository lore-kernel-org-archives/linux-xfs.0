Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbeCVXEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 19:04:44 -0400
Date: Thu, 22 Mar 2018 16:04:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] workqueue: add missing pthreads header
Message-ID: <20180322230433.GE4818@magnolia>
References: <c05fc32d43b3870b63539c57428e1c52e3e7c3cd.1521177696.git.baruch@tkos.co.il>
 <20180316053016.GB1757@magnolia>
 <20180316060846.imxc42urbsb222sn@tarshish>
 <f0d6ee15-70d8-57c1-2b68-1d6b69f309ff@sandeen.net>
 <ab844cf6-6a77-1703-4a9b-8411bfd6acfa@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab844cf6-6a77-1703-4a9b-8411bfd6acfa@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Baruch Siach <baruch@tkos.co.il>, linux-xfs@vger.kernel.org

On Thu, Mar 22, 2018 at 05:58:29PM -0500, Eric Sandeen wrote:
> On 3/22/18 5:05 PM, Eric Sandeen wrote:
> > On 3/16/18 1:08 AM, Baruch Siach wrote:
> 
> ...
> 
> >>> Our convention within xfsprogs sources (I think) is for most header
> >>> files to avoid having headers include other headers.  Would you mind
> >>> adding this include to read_verify.c instead?
> >>
> >> I don't mind. But requiring every user of workqueue.h to remember to have 
> >> pthread.h before, is error prone IMO.
> >>
> >>> (That said, you probably ought to wait for the maintainer (Eric) to
> >>> weigh in on this before you do any more work.)
> > 
> > Sorry for the late reply.
> > 
> > Eh, I think I'm inclined to just take this as-is, I don't see a downside to it.
> 
> Actually now I'm on the fence, half of scrub already includes pthread.h directly :/
> 
> How many C files would need to include pthread.h to get the build going?

AFAICT vfs.c read_verify.c phase[65432].c fscounters.c need to include
it directly?  Though some might get away with it because they include
one of the other header files that ... eh why don't we just apply this
patch and move on?  Nuts to this convention. :)

--D

> And, um, how can we get ourselves out of this "break musl, rinse, repeat" cycle?
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
