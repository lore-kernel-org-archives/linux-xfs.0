Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:49019 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751317AbdIMJtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 05:49:03 -0400
Date: Wed, 13 Sep 2017 19:49:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs-quota reports used space incorrectly
Message-ID: <20170913094900.GW17782@dastard>
References: <CAF5xGhqsh9XDGS3hiQrxJ0fdH1tPTKp5B1GR4hvDDzGGLUkH4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF5xGhqsh9XDGS3hiQrxJ0fdH1tPTKp5B1GR4hvDDzGGLUkH4Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: peykasa Admin <peykasa.xfs@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 13, 2017 at 01:43:13PM +0430, peykasa Admin wrote:
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

Not a lot to go on here. Please show the exact commands (and their
output) that demonstrate the problem, as well as provide information
about kernel, xfs_quota version, etc, as mentioned here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
