Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57780 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752292AbdJFSST (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Oct 2017 14:18:19 -0400
Subject: Re: [GIT PULL] xfsprogs: mkfs refactor
From: Eric Sandeen <sandeen@sandeen.net>
References: <20171003080607.GM15067@dastard>
 <eca367b2-03de-517d-9ef5-5400e8a4739e@sandeen.net>
Message-ID: <703ae545-3cc1-5554-d496-1a12aa678a1f@sandeen.net>
Date: Fri, 6 Oct 2017 13:18:18 -0500
MIME-Version: 1.0
In-Reply-To: <eca367b2-03de-517d-9ef5-5400e8a4739e@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 10/6/17 1:01 PM, Eric Sandeen wrote:
> On 10/3/17 3:06 AM, Dave Chinner wrote:


>> mkfs: factor naming subopts parser
> no "nvflag" in "temp don't break" code?  Oh, nice - write-only var.  Ok.
> do we still test it for respec, or care?  Will check later.
> 

Whoops meant to check it sooner than later.  Looks like respec is handled
fine and nvflag was indeed extraneous.

Thanks,
-Eric
