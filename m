Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from walrus.jabberwocky.com ([173.9.29.57]:45925 "EHLO
        mail.jabberwocky.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbeACNct (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 08:32:49 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: Quota performance hit?
From: David Shaw <dshaw@jabberwocky.com>
In-Reply-To: <20180103064342.GE30682@dastard>
Date: Wed, 3 Jan 2018 08:32:47 -0500
Content-Transfer-Encoding: 7bit
Message-Id: <613B3DDF-A3FB-4645-9923-E0E3B4DF8F3F@jabberwocky.com>
References: <3DED9052-77EA-4405-BE33-89807AEE23EC@jabberwocky.com>
 <20180103064342.GE30682@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Jan 3, 2018, at 1:43 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
> On Wed, Jan 03, 2018 at 12:02:13AM -0500, David Shaw wrote:
>> Hello,
>> 
>> I wonder if anyone could point me towards any numbers on how much
>> of a performance penalty project quotas incur on a write-heavy
>> filesystem.  The idea being discussed here is putting a project
>> quota on the /var/log directory (so pretty write-heavy)
> 
> /var/log is definitely a "mostly write" directory, but I wouldn't
> ever classify it as "write heavy".
> 
> Unless you are trying to perform thousands of concurrent writes
> and/or log file creation/removal operations every second to
> /var/log, then putting a project quota on that directory is not
> going to cause you any sort of noticable problem.

Excellent.  Sounds like I have nothing to worry about.

Thanks,

David

