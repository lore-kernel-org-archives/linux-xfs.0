Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33052 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752483AbeDEVoH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 17:44:07 -0400
Date: Fri, 6 Apr 2018 07:44:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use hardlimit as sub-fs size if both hard/soft
 limits are set
Message-ID: <20180405214404.GF23861@dastard>
References: <1521954996-203628-1-git-send-email-cgxu519@gmx.com>
 <20180326192259.GU4818@magnolia>
 <66BA750A-5A49-4B81-BC99-40DC89216856@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66BA750A-5A49-4B81-BC99-40DC89216856@gmx.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "cgxu519@gmx.com" <cgxu519@gmx.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

On Thu, Apr 05, 2018 at 09:40:03AM +0800, cgxu519@gmx.com wrote:
> Hi Dave, Christoph
> 
> Any objection for this?

Silence generally means "I don't really care".

Rule of thumb: if it's user visible and likely to be used in
scripts, then we have to be really careful about changing behaviour
as it can break user scripts. This ticks both boxes, so I'd be
wanting more justification than "I noticed this" as a reason for
changing it.

Darrick seems to be covering that concern just fine :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
