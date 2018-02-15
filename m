Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:30855 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1163332AbeBOVfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Feb 2018 16:35:07 -0500
Date: Fri, 16 Feb 2018 08:33:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] debian: add build-depends on pkg-config
Message-ID: <20180215213330.GP7000@dastard>
References: <20180215065134.GP5217@magnolia>
 <268bfeb5-f7bf-b2b2-74c3-2c6c74d8b427@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <268bfeb5-f7bf-b2b2-74c3-2c6c74d8b427@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Nathan Scott <nathans@redhat.com>

On Thu, Feb 15, 2018 at 11:02:12AM -0600, Eric Sandeen wrote:
> On 2/15/18 12:51 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since the configure scripts now depend on pkg-config to autodetect where
> > systemd service files go, we need to list pkg-config as a build
> > dependency.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I'd love to have a Debian-savvy person look over these things.

I hit this a couple of days ago doing a normal build and having
config fail due to a missing pkg-config package. The build-dep
update looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
