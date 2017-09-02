Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:55505 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752770AbdIBWUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 18:20:35 -0400
Date: Sun, 3 Sep 2017 08:20:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Rename progname as it is provided by libc
Message-ID: <20170902222003.GD10621@dastard>
References: <20170902215451.29265-1-raj.khem@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170902215451.29265-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 02, 2017 at 02:54:51PM -0700, Khem Raj wrote:
> Rename local variable progname to avoid a clash with libc
> global symbols

What libc is causing this problem?

And why is it considered ok for that libc to pollute the global
variable namespace with it's own internal variables?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
