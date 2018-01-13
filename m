Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:22695 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753022AbeAMWlG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jan 2018 17:41:06 -0500
Date: Sun, 14 Jan 2018 09:40:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Growing RAID10 with active XFS filesystem
Message-ID: <20180113224021.GX16421@dastard>
References: <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk>
 <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
 <20180111030723.GU16421@dastard>
 <5A58B901.7080609@youngman.org.uk>
 <20180112152538.2c4d8cd4@harpe.intellique.com>
 <5A58F5FB.7000101@youngman.org.uk>
 <09819eb5-b342-01ca-1b96-cf5395dcd2e2@hardwarefreak.org>
 <5fd3434f-0d25-7c64-fa1b-9ed33f18df9c@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd3434f-0d25-7c64-fa1b-9ed33f18df9c@youngman.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wol's lists <antlists@youngman.org.uk>
Cc: Stan Hoeppner <stan@hardwarefreak.org>, Emmanuel Florac <eflorac@intellique.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On Sat, Jan 13, 2018 at 07:29:19PM +0000, Wol's lists wrote:
> On 13/01/18 00:20, Stan Hoeppner wrote:
> >It's not set in stone.  If the RAID geometry changes one can
> >specify the new geometry at mount say in fstab.  New writes to the
> >filesystem will obey the new specified geometry.

FWIW, I've been assuming in everything I've said that an admin
would use these mount options to ensure new data writes were
properly aligned after a reshape.

> Does this then update the defaults, or do you need to specify the
> new geometry every mount? Inquiring minds need to know :-)

If you're going to document it, then you should observe it's
behaviour yourself, right? You don't even need a MD/RAID device to
test it - just set su/sw manually on the mkfs command line, then
see what happens when you try to change them on subsequent mounts.

Anyway, start by reading Documentation/filesystems/xfs.txt or 'man 5
xfs' where the mount options are documented. That's answer most FAQs
on this subject.

	"Typically the only time these mount options are necessary
	if after an underlying RAID device has  had  it's  geometry
	modified, such as adding a new disk to a RAID5 lun and
	reshaping it."

It should be pretty obvious from this that we know that people
reshape arrays and that we've have had the means to support it all
along. Despite this, we still don't recommend people administer
their RAID-based XFS storage in this manner....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
