Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33536 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751093AbeACGoI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 01:44:08 -0500
Date: Wed, 3 Jan 2018 17:43:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Quota performance hit?
Message-ID: <20180103064342.GE30682@dastard>
References: <3DED9052-77EA-4405-BE33-89807AEE23EC@jabberwocky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3DED9052-77EA-4405-BE33-89807AEE23EC@jabberwocky.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Shaw <dshaw@jabberwocky.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 03, 2018 at 12:02:13AM -0500, David Shaw wrote:
> Hello,
> 
> I wonder if anyone could point me towards any numbers on how much
> of a performance penalty project quotas incur on a write-heavy
> filesystem.  The idea being discussed here is putting a project
> quota on the /var/log directory (so pretty write-heavy)

/var/log is definitely a "mostly write" directory, but I wouldn't
ever classify it as "write heavy".

Unless you are trying to perform thousands of concurrent writes
and/or log file creation/removal operations every second to
/var/log, then putting a project quota on that directory is not
going to cause you any sort of noticable problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
