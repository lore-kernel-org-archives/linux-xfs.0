Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from wombat.san-francisco.ca.us ([75.101.60.140]:51705 "EHLO
        wombat.san-francisco.ca.us" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751098AbdJLFVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 01:21:33 -0400
Date: Wed, 11 Oct 2017 22:13:04 -0700
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Questions about backups with XFS
Message-ID: <20171012051304.GA29977@wombat.san-francisco.ca.us>
References: <20171007114343.3bd42f98@lubh.lubhome> <20171009084451.yj7fvv6wqra27vuo@hades.localdomain> <20171011215830.34959f4d@lubh.lubhome>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011215830.34959f4d@lubh.lubhome>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 09:58:30PM -0300, Luciano ES wrote:
> On Mon, 9 Oct 2017 10:44:51 +0200, Carlos Maiolino wrote:
> > 
> > xfs_copy must only be used an unmounted filesystem (or read-only,
> > frozen, etc), so, unless you want to freeze/unmount your FS everytime
> > you do a xfs_copy, then xfs_copy is not what you are looking for
> 
> You say that as if it were a bad thing. What is the problem with 
> freezing the file system every time I do an xfs_copy? I would likely 
> do that once a month, perhaps once a week at most, so why not? What 
> is inherently bad about freezing the file system for a few minutes?

On some systems it would not be desirable to freeze a filesystem for
even a few minutes.  An active database server might be one example.
Your use case may be totally fine with freezing.

--keith

-- 
kkeller@wombat.san-francisco.ca.us

