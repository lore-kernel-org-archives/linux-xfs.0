Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34587 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932661AbdGTHwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2017 03:52:19 -0400
Received: by mail-io0-f173.google.com with SMTP id l7so8968567iof.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 00:52:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cb16e0b4-2ef2-cdef-e0e3-cf04abd3d4c6@sandeen.net>
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
 <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
 <20170717234814.GK17762@dastard> <CAAxjCEzP=bf5S12J8rTn7EyJK_MeM=t1JSa7pBzZyXK=9TrjQQ@mail.gmail.com>
 <bcb651de-75bf-97a6-7ed8-c083d2a440e5@sandeen.net> <CAAxjCEzZ2Q0wL=nhGVHVtK3M5Ws3MQdrUNKm3jJKO+1y-wxTkw@mail.gmail.com>
 <cb16e0b4-2ef2-cdef-e0e3-cf04abd3d4c6@sandeen.net>
From: Stefan Ring <stefanrin@gmail.com>
Date: Thu, 20 Jul 2017 09:52:17 +0200
Message-ID: <CAAxjCEwjU+gMszjCWWpv8Vpc+Cx+_b0v9Vvi81d+HC8uy=FGuA@mail.gmail.com>
Subject: Re: Collecting aged XFS profiles
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 12:00 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> ok, that shoulda worked... I wonder how to debug this, if you can't
> legally share the problematic image with me to investigate...
>
> I put a lot of effort into selectively zeroing out unused portions
> of metablocks a couple years back, I am surprised that this much remains.
>
> I wonder if something regressed ...

I will try if I can find out which code paths lead to the content
being dumped out.
