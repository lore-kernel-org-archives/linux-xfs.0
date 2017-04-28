Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:56432 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756096AbdD1UUp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2017 16:20:45 -0400
Subject: Re: Slow file stat/deletion
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Apr 2017 22:14:54 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <a37b6669-4ec1-074e-de51-ae15aee5a7d9@assyoma.it>
References: <bef58272-f791-52bf-cc4c-1cb1b7c9efec@assyoma.it>
 <20161127221433.GV28177@dastard>
 <a5774248-db44-bdfe-2310-bb1a327756fb@assyoma.it>
 <20161128215308.GD28177@dastard>
 <a37b6669-4ec1-074e-de51-ae15aee5a7d9@assyoma.it>
Message-ID: <a3e391cf2ce08858aef806d5f052f73e@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi all,
this is a note which can be useful to someone searching for the same 
thing: using "ftype=1" at mkfs time (which is, by the way, the default 
for CRC-enabled filesystem) greatly speed-up stat/find operations.

On a test case with 1.000.000 files and 1000 total directories, "find 
/mnt/xfs" time has fallen from ~70 to ~20 seconds.

As a side question: there is no method/possibility to enable ftype=1 to 
an already existing filesystem, right?
Thanks.

Il 29-11-2016 08:53 Gionatan Danti ha scritto:
> On 28/11/2016 22:53, Dave Chinner wrote:
>> 
>> Nope. There's always going to be a penalty for subverting the
>> filesystem's physical layout optimisations on storage subsystems
>> that require physical layout optimisation for performance.
>> 
>> Cheers,
>> 
>> Dave.
>> 
> 
> Ok, very clear.
> 
> Thank you for taking the time to explain, Dave.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
