Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5974 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750755AbdHQIfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 04:35:41 -0400
Date: Thu, 17 Aug 2017 18:35:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: add sectsize/sectlog to the man page
Message-ID: <20170817083538.GQ21024@dastard>
References: <20170817073844.1351-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817073844.1351-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Thu, Aug 17, 2017 at 09:38:44AM +0200, Jan Tulak wrote:
> The man page is missing description of these options.
> Add it.

Just remove the options. They are redundant as they cannot be
different from the values set by the "-s" sector size options.
They aren't documented, so just remove them from mkfs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
