Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atl.turmel.org ([74.117.157.138]:36256 "EHLO atl.turmel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754838AbeAJO1e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jan 2018 09:27:34 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
From: Phil Turmel <philip@turmel.org>
Message-ID: <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
Date: Wed, 10 Jan 2018 09:10:55 -0500
MIME-Version: 1.0
In-Reply-To: <20180109222523.GJ16421@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On 01/09/2018 05:25 PM, Dave Chinner wrote:

> It's nice to know that MD has redefined RAID-10 to be different to
> the industry standard definition that has been used for 20 years and
> optimised filesystem layouts for.  Rotoring data across odd numbers
> of disks like this is going to really, really suck on filesystems
> that are stripe layout aware..

You're a bit late to this party, Dave.  MD has implemented raid10 like
this as far back as I can remember, and it is especially valuable when
running more than two copies.  Running raid10,n3 across four or five
devices is a nice capacity boost without giving up triple copies (when
multiples of three aren't available) or giving up the performance of
mirrored raid.

> For example, XFS has hot-spot prevention algorithms in it's
> internal physical layout for striped devices. It aligns AGs across
> different stripe units so that metadata and data doesn't all get
> aligned to the one disk in a RAID0/5/6 stripe. If the stripes are
> rotoring across disks themselves, then we're going to end up back in
> the same position we started with - multiple AGs aligned to the
> same disk.

All of MD's default raid5 and raid6 layouts rotate stripes, too, so that
parity and syndrome are distributed uniformly.

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
> 
> IMO, odd-numbered disks in RAID-10 should be considered harmful and
> never used....

Users are perfectly able to layer raid1+0 or raid0+1 if they don't want
the features of raid10.  Given the advantages of MD's raid10, a pedant
could say XFS's lack of support for it should be considered harmful and
XFS never used.  (-:

FWIW, while I'm sometimes a pendant, I'm not in this case.  I use both
MD raid10 and xfs.

Phil
