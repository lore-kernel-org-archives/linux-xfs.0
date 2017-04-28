Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51488 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968758AbdD1VDk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Apr 2017 17:03:40 -0400
Subject: Re: Slow file stat/deletion
References: <bef58272-f791-52bf-cc4c-1cb1b7c9efec@assyoma.it>
 <20161127221433.GV28177@dastard>
 <a5774248-db44-bdfe-2310-bb1a327756fb@assyoma.it>
 <20161128215308.GD28177@dastard>
 <a37b6669-4ec1-074e-de51-ae15aee5a7d9@assyoma.it>
 <a3e391cf2ce08858aef806d5f052f73e@assyoma.it>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0539279f-6f46-d260-708e-68cc9e1107e5@sandeen.net>
Date: Fri, 28 Apr 2017 16:03:38 -0500
MIME-Version: 1.0
In-Reply-To: <a3e391cf2ce08858aef806d5f052f73e@assyoma.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 4/28/17 3:14 PM, Gionatan Danti wrote:
> Hi all,
> this is a note which can be useful to someone searching for the same thing: using "ftype=1" at mkfs time (which is, by the way, the default for CRC-enabled filesystem) greatly speed-up stat/find operations.
> 
> On a test case with 1.000.000 files and 1000 total directories, "find /mnt/xfs" time has fallen from ~70 to ~20 seconds.
> 
> As a side question: there is no method/possibility to enable ftype=1 to an already existing filesystem, right?
> Thanks.

That is correct.

-Eric

