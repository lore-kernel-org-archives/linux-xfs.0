Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387937AbeGWNdk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 09:33:40 -0400
Date: Mon, 23 Jul 2018 08:32:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Query about the handling of a bug reported before
Message-ID: <20180723123239.GA46987@bfoster>
References: <21AA8603-85D9-429A-A713-8B86F341FFC4@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21AA8603-85D9-429A-A713-8B86F341FFC4@gatech.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sun, Jul 22, 2018 at 06:30:03AM +0000, Xu, Wen wrote:
> Hi XFS developers,
> 
> I wonder if this bug
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=200127
> 
> has already been resolved by any patch.
> 

It looks like you're on a kernel that already has the agfl reset
mechanism. I'm not aware of anything else in that area off the top of my
head, but FWIW, I don't see the KASAN error with a quick check on a
KASAN-enabled latest for-next (4.18.0-rc4) kernel. Have you given that a
try?

Brian

> Thanks,
> Wen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
