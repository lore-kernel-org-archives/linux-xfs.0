Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:17448 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S968393AbeE3BgX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 May 2018 21:36:23 -0400
Date: Wed, 30 May 2018 11:28:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 2/4] mkfs: move shared config structs and into their
 own headers
Message-ID: <20180530012846.GT10363@dastard>
References: <20180529220603.29420-1-mcgrof@kernel.org>
 <20180529220603.29420-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529220603.29420-3-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Tue, May 29, 2018 at 03:06:01PM -0700, Luis R. Rodriguez wrote:
> Both struct sb_feat_args and struct mkfs_default_params will be shared
> between CLI processing and the configuration file processing added later,
> so move these to their own header.
> 
> This will help ensure we split things neatly later and also will help
> ensure the configuration file processing code from the CLI code are kept
> separate and cannot touch each other's data structures. This also makes
> it clear what is actually shared between both.
> 
> There are no introduced functional changes in this commit and no
> documentation changes, this is just code shuffling.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
