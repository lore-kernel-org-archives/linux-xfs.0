Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from auth-3.ukservers.net ([217.10.138.152]:55634 "EHLO
        auth-3.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752347AbeAJGRO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 01:17:14 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
From: Wols Lists <antlists@youngman.org.uk>
Message-ID: <5A55AFE7.3080500@youngman.org.uk>
Date: Wed, 10 Jan 2018 06:17:11 +0000
MIME-Version: 1.0
In-Reply-To: <20180109222523.GJ16421@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On 09/01/18 22:25, Dave Chinner wrote:
> On Tue, Jan 09, 2018 at 09:36:49AM +0000, Wols Lists wrote:
>> On 08/01/18 22:01, Dave Chinner wrote:
>>> Yup, 21 devices in a RAID 10. That's a really nasty config for
>>> RAID10 which requires an even number of disks to mirror correctly.
>>> Why does MD even allow this sort of whacky, sub-optimal
>>> configuration?
>>
>> Just to point out - if this is raid-10 (and not raid-1+0 which is a
>> completely different beast) this is actually a normal linux config. I'm
>> planning to set up a raid-10 across 3 devices. What happens is that is
>> that raid-10 writes X copies across Y devices. If X = Y then it's a
>> normal mirror config, if X > Y it makes good use of space (and if X < Y
>> it doesn't make sense :-)
>>
>> SDA: 1, 2, 4, 5
>>
>> SDB: 1, 3, 4, 6
>>
>> SDC: 2, 3, 5, 6
> 
> It's nice to know that MD has redefined RAID-10 to be different to
> the industry standard definition that has been used for 20 years and
> optimised filesystem layouts for.  Rotoring data across odd numbers
> of disks like this is going to really, really suck on filesystems
> that are stripe layout aware..

Actually, I thought that the industry standard definition referred to
Raid-1+0. It's just colloquially referred to as raid-10.
> 
> For example, XFS has hot-spot prevention algorithms in it's
> internal physical layout for striped devices. It aligns AGs across
> different stripe units so that metadata and data doesn't all get
> aligned to the one disk in a RAID0/5/6 stripe. If the stripes are
> rotoring across disks themselves, then we're going to end up back in
> the same position we started with - multiple AGs aligned to the
> same disk.

Are you telling me that xfs is aware of the internal structure of an
md-raid array? Given that md-raid is an abstraction layer, this seems
rather dangerous to me - you're breaking the abstraction and this could
explain the OP's problem. Md-raid changed underneath the filesystem, on
the assumption that the filesystem wouldn't notice, and the filesystem
*did*. BANG!
> 
> The result is that many XFS workloads are going to hotspot disks and
> result in unbalanced load when there are an odd number of disks in a
> RAID-10 array.  Actually, it's probably worse than having no
> alignment, because it makes hotspot occurrence and behaviour very
> unpredictable.
> 
> Worse is the fact that there's absolutely nothing we can do to
> optimise allocation alignment or IO behaviour at the filesystem
> level. We'll have to make mkfs.xfs aware of this clusterfuck and
> turn off stripe alignment when we detect such a layout, but that
> doesn't help all the existing user installations out there right
> now.

So you're telling me that mkfs.xfs *IS* aware of the underlying raid
structure. OOPS! What happens when that structure changes for instance a
raid-5 is converted to raid-6, or another disk is added? If you have to
have special code to deal with md-raid and changes in said raid, where's
the problem with more code for raid-10?
> 
> IMO, odd-numbered disks in RAID-10 should be considered harmful and
> never used....
> 
What about when you have an odd number of mirrors? :-)

Seriously, can't you just make sure that xfs rotates the stripe units
using a number that is relatively prime to the number of disks? If you
have to notice and adjust for changes in the underlying raid structure
anyway, surely that's no greater hardship?

(Just so's you know who I am, I've taken over editorship of the raid
wiki. This is exactly the stuff that belongs on there, so as soon as I
understand what's going on I'll write it up, and I'm happy to be
educated :-) But I do like to really grasp what's going on, so expect
lots of naive questions ... There's not a lot of information on how raid
and filesystems interact, and I haven't really got to grips wioth any of
that at the moment, and I don't use xfs. I use ext4 on gentoo, and the
default btrfs on SUSE.)

Cheers,
Wol
