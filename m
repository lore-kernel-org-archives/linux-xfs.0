Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16913 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdKBFX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 01:23:26 -0400
Date: Wed, 1 Nov 2017 22:23:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: clear extra file attributes on symlinks
Message-ID: <20171102052306.GQ4911@magnolia>
References: <20171031215156.12544-1-mcgrof@kernel.org>
 <20171031221253.GV4911@magnolia>
 <CAB=NE6WusGvGYVBokMOup9snofncCm9gXopM7BaUukp9N3zbRQ@mail.gmail.com>
 <20171031224320.GB4911@magnolia>
 <20171102003948.GG22894@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102003948.GG22894@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, David Howells <dhowells@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Tso Ted <tytso@mit.edu>, Nikolay Borisov <nborisov@suse.com>, Flex Liu <fliu@suse.com>, Jake Norris <jake.norris@suse.com>, Jan Kara <jack@suse.cz>

On Thu, Nov 02, 2017 at 01:39:48AM +0100, Luis R. Rodriguez wrote:
> On Tue, Oct 31, 2017 at 03:43:20PM -0700, Darrick J. Wong wrote:
> > you shouldn't be able to set any DIFLAG/DIFLAG2 flags on special files.
> 
> Do we know for certain *all* DIFLAG/DIFLAG2 flags can *only* be set via
> an ioctl()?

I'm fairly sure that inode flags get set via ioctl, via inheritance at
creation time with only two exceptions*, but could you please take a look
at all the places we set inode di_flags/di_flags2 and report back?

--D

* The DAX flag can get set (I think?) via the mount option; and the
  REFLINK flag can be set on files via copy_file_range().

>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
