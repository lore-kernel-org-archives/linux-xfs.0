Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60978 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbeBYSJ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Feb 2018 13:09:26 -0500
Date: Sun, 25 Feb 2018 10:09:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix potential memory leak in mount option parsing
Message-ID: <20180225180916.GB19312@magnolia>
References: <1519468406-67354-1-git-send-email-cgxu519@icloud.com>
 <5d92aa93-cec4-2495-70fa-61d082e1cb6b@sandeen.net>
 <326CF29E-FC88-493B-B16E-7EA318169E9A@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <326CF29E-FC88-493B-B16E-7EA318169E9A@icloud.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Sun, Feb 25, 2018 at 12:11:23PM +0800, Chengguang Xu wrote:
> > 
> > 在 2018年2月25日，上午1:58，Eric Sandeen <sandeen@sandeen.net> 写道：
> > 
> > On 2/24/18 4:33 AM, Chengguang Xu wrote:
> >> When specifying string type mount option (e.g., logdev)
> >> several times in a mount, current option parsing may
> >> cause memory leak. Hence, call kfree for previous one
> >> in this case.
> >> 
> >> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> > 
> > IMHO multiple specifications of logdev or rtdev should not
> > be allowed; only one may be chosen, and specifying twice
> > should probably be considered and administrative error.
> > 
> > I'd rather see something that fails and cleans up properly
> > if either option is respecified.
> 
> Hi Eric,
> 
> Thanks for quick reply. I think your suggestion makes sense,
> but considering of the consistency with other options, 
> we should check multiple specifications for all options. 
> 
> So I think this patch is the cheapest way to fix the issue.
> What do you think?

I think the all the mount options should be cleaned up to allow one
specification only.

--D

> 
> 
> Thanks,
> Chengguang.--
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
