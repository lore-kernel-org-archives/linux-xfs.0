Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:37371 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdEHNgu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2017 09:36:50 -0400
Subject: Re: XFS and multiple mounts protection (aka preventing multiple
 mounts)
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
 <63a045ae-0c12-e1b7-a7e0-df251dd88a4f@sandeen.net>
 <473d24bc-bab5-8f1e-efe6-f60e099f636d@assyoma.it>
 <680a24f3-6523-acf4-5019-8a0dc4f46224@sandeen.net>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <061f5629-208a-05c9-a500-5b15ddc484b3@assyoma.it>
Date: Mon, 8 May 2017 15:36:43 +0200
MIME-Version: 1.0
In-Reply-To: <680a24f3-6523-acf4-5019-8a0dc4f46224@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

On 08/05/2017 15:26, Eric Sandeen wrote:
> It also delays each mount by that amount of time, which
> may not be desirable in a production environment.

True. With the default mmp interval (5 sec), during my testing I saw >15 
secs delay mounting the filesystem.

> I'm sure it depends on what happens during that mount.  Damage could
> range from none to minimal to catastrophic.  If you've escaped without
> corruption, it's partly luck.  If the 2nd node did no IO, and unmounted
> quickly, you'd get an unmount record written to the log which, depending
> on the location, may or may not matter if a subsequent log replay was
> required, for example.
>
> -Eric
>

Very interesting. Thank you so much.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
