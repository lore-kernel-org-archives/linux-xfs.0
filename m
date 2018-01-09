Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from auth-4.ukservers.net ([217.10.138.158]:47319 "EHLO
        auth-4.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbeAIJo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 04:44:56 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
From: Wols Lists <antlists@youngman.org.uk>
Message-ID: <5A548D31.4000002@youngman.org.uk>
Date: Tue, 9 Jan 2018 09:36:49 +0000
MIME-Version: 1.0
In-Reply-To: <20180108220139.GB16421@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On 08/01/18 22:01, Dave Chinner wrote:
> Yup, 21 devices in a RAID 10. That's a really nasty config for
> RAID10 which requires an even number of disks to mirror correctly.
> Why does MD even allow this sort of whacky, sub-optimal
> configuration?

Just to point out - if this is raid-10 (and not raid-1+0 which is a
completely different beast) this is actually a normal linux config. I'm
planning to set up a raid-10 across 3 devices. What happens is that is
that raid-10 writes X copies across Y devices. If X = Y then it's a
normal mirror config, if X > Y it makes good use of space (and if X < Y
it doesn't make sense :-)

SDA: 1, 2, 4, 5

SDB: 1, 3, 4, 6

SDC: 2, 3, 5, 6

Cheers,
Wol
