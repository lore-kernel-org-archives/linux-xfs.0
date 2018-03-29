Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45572 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752082AbeC2Pkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Mar 2018 11:40:47 -0400
Date: Thu, 29 Mar 2018 08:40:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/10] xfsprogs: remove old cruft
Message-ID: <20180329154043.GA29748@magnolia>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 29, 2018 at 10:34:12AM -0500, Eric Sandeen wrote:
> This is mostly removing old hardcoded "feature" flags which were
> settable via the commandline long, long ago but have been lingering
> as hardcoded globals since.  Just get rid of them and all the
> associated code.
> 
> The last 3 remove an option for 20-year-old irix filesystems,
> a weirdly triplicated test, and finally adds some #warnings
> followed by #error to get the attention of anyone building on
> platforms we want to deprecate.
> 
> Thanks,
> -Eric

Yay cruft dumping!  For the whole series,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
