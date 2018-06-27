Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:39837
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752039AbeF0Ayr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 20:54:47 -0400
Date: Wed, 27 Jun 2018 10:54:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/21] xfs: don't assume a left rmap when allocating a
 new rmap
Message-ID: <20180627005426.GB19934@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986821631.3155.13981921703707802906.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152986821631.3155.13981921703707802906.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 24, 2018 at 12:23:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The original rmap code assumed that there would always be at least one
> rmap in the rmapbt (the AG sb/agf/agi) and so errored out if it didn't
> find one.  This assumption isn't true for the rmapbt repair function
> (and it won't be true for realtime rmap either), so remove the check and
> just deal with the situation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks reasonable.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
