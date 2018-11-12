Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:57608 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725928AbeKLMz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Nov 2018 07:55:27 -0500
Message-ID: <9b618d0aa0e7c0db78e3dcaf4d3ffe2e22b92a12.camel@perches.com>
Subject: Re: [PATCH] Fix coding style issue in xfs_acl.c and xfs_aops.c
From: Joe Perches <joe@perches.com>
Date: Sun, 11 Nov 2018 19:04:17 -0800
In-Reply-To: <20181111233305.GL19305@dastard>
References: <20181111003603.7598-1-weizhefix@gmail.com>
         <20181111233305.GL19305@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, hmsjwzb <weizhefix@gmail.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kerticrnel@vger.kernel.org

On Mon, 2018-11-12 at 10:33 +1100, Dave Chinner wrote:
> On Sun, Nov 11, 2018 at 08:36:03AM +0800, hmsjwzb wrote:
> > Possible unwrapped commit description (prefer a maximum 75 chars per line)
> 
> NACK. Our preference is (and always has been) for comments to fill
> the entire 80 columns, just like the rest of the kernel. I have no
> idea who told you "75 columns is preferred" but they are wrong.

75 column is the preferred commit description length
as the general 'git log' style is indented a few chars.

This particular commit description is odd because the
comments in the code is being wrapped, not the commit
description.

Wei Zhe, can you please resubmit this with a better
commit description?  Something like:

	Wrap comments to 80 columns where appropriate.
