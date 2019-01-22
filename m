Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:63725 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726225AbfAVVw5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 16:52:57 -0500
Date: Wed, 23 Jan 2019 08:52:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202127] cannot mount or create xfs on a  597T device
Message-ID: <20190122215254.GM6173@dastard>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
 <bug-202127-201763-jc6cMFk2so@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202127-201763-jc6cMFk2so@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 22, 2019 at 12:49:31PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202127
> 
> --- Comment #22 from daimh@umich.edu ---
> An update is that Broadcom engineer cannot reproduce the issue with Arch Linux
> kernel 4.20.3-arch1-1-ARCH and mkfs.xfs version 4.19.0. The difference is his
> raid-60 is 7T and 2T, while mine is 556T. 

IOWs, they didn't actually test your configuration, and so they
didn't see the problem you are seeing. Which implies they've got a
problem in their firmware where something overflows at a larger size
than 7TB.  If that were my raid card, I'd be tearing strips off the
support engineer's manager by now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
