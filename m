Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:51158 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbeEMOa3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 May 2018 10:30:29 -0400
Date: Sun, 13 May 2018 16:30:20 +0200
From: Adam Borowski <kilobyte@angband.pl>
Subject: Re: [PATCH 2/2] vfs: dedupe should return EPERM if permission is not
 granted
Message-ID: <20180513143020.6lp7eg6pg5ckl4nn@angband.pl>
References: <20180511192651.21324-1-mfasheh@suse.de>
 <20180511192651.21324-3-mfasheh@suse.de>
 <20180512000634.GG9510@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180512000634.GG9510@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 05:06:34PM -0700, Darrick J. Wong wrote:
> On Fri, May 11, 2018 at 12:26:51PM -0700, Mark Fasheh wrote:
> > Right now we return EINVAL if a process does not have permission to dedupe a
> > file. This was an oversight on my part. EPERM gives a true description of
> > the nature of our error, and EINVAL is already used for the case that the
> > filesystem does not support dedupe.

> > -			info->status = -EINVAL;
> > +			info->status = -EPERM;
> 
> Hmm, are we allowed to change this aspect of the kabi after the fact?
> 
> Granted, we're only trading one error code for another, but will the
> existing users of this care?  xfs_io won't and I assume duperemove won't
> either, but what about bees? :)

There's more:
https://codesearch.debian.net/search?q=FILE_EXTENT_SAME

This includes only software that has been packaged for Debian (notably, not
bees), but that gives enough interesting coverage.  And none of these cases
discriminate between error codes -- they merely report them to the user.

Thus, I can't think of a downside of making the error code more accurate.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ 
⢿⡄⠘⠷⠚⠋⠀ Certified airhead; got the CT scan to prove that!
⠈⠳⣄⠀⠀⠀⠀ 
