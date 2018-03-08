Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:63575 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934289AbeCHEOj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Mar 2018 23:14:39 -0500
Date: Thu, 8 Mar 2018 15:14:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/16] xfs_db: add a superblock info command
Message-ID: <20180308041435.GP18129@dastard>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993165958.22223.10507415725288169958.stgit@magnolia>
 <20edb4dd-80c4-76e6-d63d-09c6553b5c29@sandeen.net>
 <777384a3-90de-4715-21fc-a3f7b45387d8@sandeen.net>
 <20180306204904.GJ18989@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180306204904.GJ18989@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, sandeen@redhat.com, linux-xfs@vger.kernel.org, djwong@kernel.org

On Tue, Mar 06, 2018 at 12:49:04PM -0800, Darrick J. Wong wrote:
> On Tue, Mar 06, 2018 at 01:34:42PM -0600, Eric Sandeen wrote:
> > Sorry - of course later patches make xfs_info work offline, but still,
> > I'd like to see some rationale for why we need that capability.  I'm all
> > for the code reduction of the common printing routine but what's the big
> > picture rational for teaching all these other tools to print mkfs-like output?
> 
> Growing the filesystem falls under the umbrella of space management, so
> in the long run (like after I finish putting online repair in) I intend
> to make growfs a part of xfs_spaceman, and then the xfs_growfs command
> becomes a wrapper around that.  Looking forward towards Dave's subvolume
> thingy, I think it makes sense to be able to manage subvolumes entirely
> via spaceman commands.

Agreed with this, as this is where I've implemented all the subvol
management stuff.

Also, when we have lots of subvoils sitting around as files, it'd
bee really nice to be able to have utilities that can identify them
from accessing the backing file....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
