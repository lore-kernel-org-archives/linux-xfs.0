Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:22453 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751017AbeEQWDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 18:03:22 -0400
Date: Fri, 18 May 2018 08:02:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/5] mkfs: distinguish between struct sb_feat_args and
 struct cli_params
Message-ID: <20180517220255.GB23861@dastard>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517192700.23457-2-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 17, 2018 at 12:26:56PM -0700, Luis R. Rodriguez wrote:
> The struct sb_feat_args will actually be shared between the code which
> processes command line options and the configuration file, as such we
> need to clarify and reflect this clearly in documentation.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Sensible.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
