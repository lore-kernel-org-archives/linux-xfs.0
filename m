Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:34176 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdHTFF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Aug 2017 01:05:56 -0400
Subject: Re: Estimate =?UTF-8?Q?xfs=5Frepair=20run=20time?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 20 Aug 2017 07:05:50 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20170820020438.GQ10621@dastard>
References: <22ed5cf73260ae39bf59779b302d8ad3@assyoma.it>
 <d80ca25cd28ec433c39a7d7d22c4e371@assyoma.it>
 <20170819154804.GS4796@magnolia>
 <3fcdaa5ea4365a1ddb7c76070236e6b3@assyoma.it>
 <20170819162025.GT4796@magnolia>
 <a42886b91433dcf4d7fdd3f541f2374a@assyoma.it>
 <20170820020438.GQ10621@dastard>
Message-ID: <128ec64d954acd2b8760d017fd16db46@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, g.danti@assyoma.it

Hi Dave,

Il 20-08-2017 04:04 Dave Chinner ha scritto:
> 
> Yes. And there's no hard and fast number we can give you because
> runtime will depends on the amount and density of the metadata, the
> speed of the underlying storage, how much RAM you have and how badly
> corrupted the filesystem is.
> 
> IOWs, runtime can vary from a few minutes to a few days as you vary
> those parameters, and there's really no way to tell in advance where
> in that massive variance any specific production filesystem will
> land.
> 
> Doing a test run (xfs_repair -n) to get a ballpark figure during a
> planned downtime period is the only way you'll get any idea of the
> *best case* repair duration on a *clean* filesystem. But the moment
> repair finds corruptions, all guesses you can make about runtime go
> out the window...

ok, so I at least need to try & see how well xfs_repair does on a clean 
filesystem.

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
