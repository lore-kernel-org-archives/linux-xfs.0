Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935995AbdDSWI3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 18:08:29 -0400
Date: Wed, 19 Apr 2017 17:08:26 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH v2] xfsprogs: ensure growfs rejects non-existent mount
 point
Message-ID: <20170419220826.GA14334@redhat.com>
References: <20170407175809.8540-1-billodo@redhat.com>
 <20170411172235.9361-1-billodo@redhat.com>
 <74fc8191-443b-394a-0dc8-47e947f4e9b7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74fc8191-443b-394a-0dc8-47e947f4e9b7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2017 at 05:05:36PM -0500, Eric Sandeen wrote:
> On 4/11/17 12:22 PM, Bill O'Donnell wrote:
> > xfs_growfs manpage clearly states that the filesystem must
> > be mounted to be grown. Current behavior allows xfs_growfs
> > to proceed if the filesystem /containing/ the path
> > of the desired target is mounted. This is not the specified
> > behavior. Instead, also check the targeted fs argument against
> > the entry found in the fstable lookup. Unless the targeted
> > fs is actually mounted, reject the command.
> > 
> > In order to cover bind-mounts, create a new lookup function
> > based on the mountpoints instead of just the device name.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> > 
> > v2: in order to properly handle relative pathnames, symlinks,
> > and bind-mounts, use realpath to establish canonical path name.
> > This also requires the introduction of a lookup function based
> > on the target mountpoint.
> 
> I still need to review this one carefully, but have you made any
> progress towards an xfstest for this behavior?

xfstest is still a work in progress. Hopefully will have one
by end of this week.
Thanks-
Bill


> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
