Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58004 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbdEHN01 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 May 2017 09:26:27 -0400
Subject: Re: XFS and multiple mounts protection (aka preventing multiple
 mounts)
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
 <63a045ae-0c12-e1b7-a7e0-df251dd88a4f@sandeen.net>
 <473d24bc-bab5-8f1e-efe6-f60e099f636d@assyoma.it>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <680a24f3-6523-acf4-5019-8a0dc4f46224@sandeen.net>
Date: Mon, 8 May 2017 08:26:26 -0500
MIME-Version: 1.0
In-Reply-To: <473d24bc-bab5-8f1e-efe6-f60e099f636d@assyoma.it>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

On 5/8/17 4:34 AM, Gionatan Danti wrote:
> On 05/05/2017 21:20, Eric Sandeen wrote:
>> I guess this has been covered, but: no.  There is no cross-machine 
>> multi-mount protection in XFS.  Nothing like ext4's MMP.
>> 
>> There is a unique UUID test at mount time, so you can't i.e. mount 
>> the same path twice /on the same box/, but there is no mechanism
>> in XFS to prevent the same disk from being mounted by 2 /separate/
>> machines on a SAN.
>> 
>> -Eric
> 
> Thanks Eric. Just out of curiosity, there are some specific technical
> motivations to avoid this check?

Partly it's just never been written, but also, mechanisms like MPP aren't
foolproof.  MPP picks a timeout, and if nothing changes during that
timeout it's assumed safe to mount.  If for some reason the other machine
was busy or hung for that mount of time, the check would pass and allow
a double mount.  It also delays each mount by that amount of time, which
may not be desirable in a production environment.
 
> One more pragmatic question: what kind of corruption can be expected
> from shot-lived (ie some seconds) double mount? For example, in
> raiserfs I remember an immediate catastrophic faileres when a double
> mount happened. On XFS it *seems* that filesystem remain more or less
> consistent (even an xfs_repair does not find nothing wrong).

I'm sure it depends on what happens during that mount.  Damage could
range from none to minimal to catastrophic.  If you've escaped without
corruption, it's partly luck.  If the 2nd node did no IO, and unmounted
quickly, you'd get an unmount record written to the log which, depending
on the location, may or may not matter if a subsequent log replay was
required, for example.

-Eric
 
> Thanks again.
> 
