Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from auth-3.ukservers.net ([217.10.138.152]:54288 "EHLO
        auth-3.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbeAMXEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jan 2018 18:04:45 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
 <20180111030723.GU16421@dastard> <5A58B901.7080609@youngman.org.uk>
 <20180112152538.2c4d8cd4@harpe.intellique.com>
 <5A58F5FB.7000101@youngman.org.uk>
 <09819eb5-b342-01ca-1b96-cf5395dcd2e2@hardwarefreak.org>
 <5fd3434f-0d25-7c64-fa1b-9ed33f18df9c@youngman.org.uk>
 <20180113224021.GX16421@dastard>
From: Wols Lists <antlists@youngman.org.uk>
Message-ID: <5A5A9088.102@youngman.org.uk>
Date: Sat, 13 Jan 2018 23:04:40 +0000
MIME-Version: 1.0
In-Reply-To: <20180113224021.GX16421@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Stan Hoeppner <stan@hardwarefreak.org>, Emmanuel Florac <eflorac@intellique.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On 13/01/18 22:40, Dave Chinner wrote:
> On Sat, Jan 13, 2018 at 07:29:19PM +0000, Wol's lists wrote:
>> On 13/01/18 00:20, Stan Hoeppner wrote:
>>> It's not set in stone.  If the RAID geometry changes one can
>>> specify the new geometry at mount say in fstab.  New writes to the
>>> filesystem will obey the new specified geometry.
> 
> FWIW, I've been assuming in everything I've said that an admin
> would use these mount options to ensure new data writes were
> properly aligned after a reshape.
> 
>> Does this then update the defaults, or do you need to specify the
>> new geometry every mount? Inquiring minds need to know :-)
> 
> If you're going to document it, then you should observe it's
> behaviour yourself, right? You don't even need a MD/RAID device to
> test it - just set su/sw manually on the mkfs command line, then
> see what happens when you try to change them on subsequent mounts.

I suppose I could set up a VM ...
> 
> Anyway, start by reading Documentation/filesystems/xfs.txt or 'man 5
> xfs' where the mount options are documented. That's answer most FAQs
> on this subject.
> 
> 	"Typically the only time these mount options are necessary
> 	if after an underlying RAID device has  had  it's  geometry
> 	modified, such as adding a new disk to a RAID5 lun and
> 	reshaping it."

anthony@ashdown /usr/src $ man 5 xfs
No entry for xfs in section 5 of the manual
anthony@ashdown /usr/src $

> 
> It should be pretty obvious from this that we know that people
> reshape arrays and that we've have had the means to support it all
> along. Despite this, we still don't recommend people administer
> their RAID-based XFS storage in this manner....
> 
Note I described myself as *editor* of the raid wiki. Yes I'd love to
play around with all this stuff, but I don't have the hardware, and my
nice new system I was planning to do all this sort of stuff on won't
POST. I've had that problem before, it's finding time to debug a new
system in the face of family demands... and at present I don't have an
xfs partition anywhere.

Reading xfs.txt doesn't seem to answer the question, though. It sounds
like it doesn't update the underlying defaults so it's required every
mount (which is a safe assumption to make), but it could easily be read
the other way, too.

Thanks. I'll document it to the level I understand, make a mental note
to go back and improve it (I try and do that all the time :-), and then
when my new system is up and running, I'll be playing with that to see
how things behave.

Cheers,
Wol
