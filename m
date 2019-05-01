Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59693 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfEAXtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 May 2019 19:49:43 -0400
Date: Thu, 2 May 2019 09:49:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: change some error-less functions to void types
Message-ID: <20190501234939.GK29573@dread.disaster.area>
References: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
 <2a52ea5e-e056-244b-4d9b-04ed15d996fd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a52ea5e-e056-244b-4d9b-04ed15d996fd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, May 01, 2019 at 05:20:52PM -0500, Eric Sandeen wrote:
> There are several functions which have no opportunity to retun
							   return

> an error, and don't contain any ASSERTs which could be argued
> to be better constructed as error cases.  So, make them voids
> to simplify the callers.

Does it make the code smaller? :)

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
