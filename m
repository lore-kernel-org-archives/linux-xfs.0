Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750977AbdCOLyb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 07:54:31 -0400
Date: Wed, 15 Mar 2017 07:54:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Request for including dbd5c8c9a288 ("xfs: pass total block res.
 as total xfs_bmapi_write() parameter") into stable
Message-ID: <20170315115429.GB23221@bfoster.bfoster>
References: <153397e1-ba41-20b3-455e-d622c234bc3a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153397e1-ba41-20b3-455e-d622c234bc3a@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: stable@vger.kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, david@fromorbit.com

On Wed, Mar 15, 2017 at 12:41:02PM +0200, Nikolay Borisov wrote:
> Hello,
> 
> I'd like to request the commit from the subject to be included into
> stable kernels, starting with 3.12. Without generic/299 would deadlock
> almost always, whereas with the commit applied I can get it to run 20
> consecutive times without a hitch.
> 

Seems reasonable to me. Care to post a backport(s)? (Unless Greg
suggests otherwise, but I think that's how stable works...).

Brian

> 
> Regards,
> Nikolay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
