Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57477 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751458AbeERWID (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 May 2018 18:08:03 -0400
Date: Sat, 19 May 2018 00:08:02 +0200
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH v2 2/2] vfs: dedupe should return EPERM if permission is
 not granted
Message-ID: <20180518220802.GD28045@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20180518215727.26418-1-mfasheh@suse.de>
 <20180518215727.26418-3-mfasheh@suse.de>
 <20180518220413.GB31250@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518220413.GB31250@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>

On Fri, May 18, 2018 at 03:04:13PM -0700, Darrick J. Wong wrote:
> On Fri, May 18, 2018 at 02:57:27PM -0700, Mark Fasheh wrote:
> > Right now we return EINVAL if a process does not have permission to dedupe a
> > file. This was an oversight on my part. EPERM gives a true description of
> > the nature of our error, and EINVAL is already used for the case that the
> > filesystem does not support dedupe.
> > 
> > Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> 
> Looks ok what with all the okays after I squawked last time,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Awesome, I'll put that in the patch. Thanks Darrick.
	--Mark
