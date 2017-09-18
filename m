Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23626 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdIRSyH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 14:54:07 -0400
Date: Mon, 18 Sep 2017 11:54:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs-quota reports used space incorrectly
Message-ID: <20170918185402.GN6540@magnolia>
References: <CAF5xGhpC_k6eexQ_DQU1g5-bF5sdYmdw4EOPtKxW9UrqFJtVWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF5xGhpC_k6eexQ_DQU1g5-bF5sdYmdw4EOPtKxW9UrqFJtVWA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: peykasa Admin <peykasa.xfs@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2017 at 04:30:33PM +0430, peykasa Admin wrote:
> Hi
> 
> We face a problem with xfs quota
> 
> SENARIO
> we have a file sharing for some users. Each user has a sharing folder.
> Each user has a 1G limitation for his folder. the limitation is created via
> xfs quota.
> 
> PROBLEM
> For some users, the used space reported by xfs quota is not equal to the
> real used space.
> xfs quota reports the space is full (1024 M) and nothing can be moved there
> but the real used space is less than that value.
> 
> 
> We tested many solution and also the xfs_repair, but it didn't resolve.

Would be helpful to know the kernel/xfsprogs versions, how you
determined 'real used space', and by how much it's off from whatever
xfs_quota reports.

--D

> 
> Sincerely yours
> Arian Rmz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
