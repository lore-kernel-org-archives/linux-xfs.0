Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64329 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725955AbeKAHm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Nov 2018 03:42:56 -0400
Date: Thu, 1 Nov 2018 09:42:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 201577] New: [xfstests generic/070]: XFS corruption and
 Oops when setxattr on 64k blocksize XFS
Message-ID: <20181031224247.GW19305@dastard>
References: <bug-201577-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-201577-201763@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 31, 2018 at 07:34:49AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=201577
> 
>             Bug ID: 201577
>            Summary: [xfstests generic/070]: XFS corruption and Oops when
>                     setxattr on 64k blocksize XFS
......
> How reproducible:
> nearly 100% on 64k blocksize XFS on ppc64le
> 
> Additional info:
> Can't reproduce this bug on 4k blocksize XFS

I saw both these (the corruption and the assert on shutdown) a few
days ago on a 4k block size filesystem. Not reproducable, though,
but it doesn't have anything specifically to do with 64k block size.

What kernel are you running, exactly? A plain 4.19 release kernel?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
