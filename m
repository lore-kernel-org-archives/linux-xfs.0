Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53982 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S940031AbdDSWFe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 18:05:34 -0400
Subject: Re: [PATCH v2] xfsprogs: ensure growfs rejects non-existent mount
 point
References: <20170407175809.8540-1-billodo@redhat.com>
 <20170411172235.9361-1-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <74fc8191-443b-394a-0dc8-47e947f4e9b7@sandeen.net>
Date: Wed, 19 Apr 2017 17:05:36 -0500
MIME-Version: 1.0
In-Reply-To: <20170411172235.9361-1-billodo@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org

On 4/11/17 12:22 PM, Bill O'Donnell wrote:
> xfs_growfs manpage clearly states that the filesystem must
> be mounted to be grown. Current behavior allows xfs_growfs
> to proceed if the filesystem /containing/ the path
> of the desired target is mounted. This is not the specified
> behavior. Instead, also check the targeted fs argument against
> the entry found in the fstable lookup. Unless the targeted
> fs is actually mounted, reject the command.
> 
> In order to cover bind-mounts, create a new lookup function
> based on the mountpoints instead of just the device name.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
> 
> v2: in order to properly handle relative pathnames, symlinks,
> and bind-mounts, use realpath to establish canonical path name.
> This also requires the introduction of a lookup function based
> on the target mountpoint.

I still need to review this one carefully, but have you made any
progress towards an xfstest for this behavior?

Thanks,
-Eric
