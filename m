Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:22447 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753591AbdDGBuE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 21:50:04 -0400
Date: Fri, 7 Apr 2017 11:50:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 1/2] mkfs: unify numeric types of main variables in
 main()
Message-ID: <20170407014959.GT17542@dastard>
References: <20170406144139.20284-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170406144139.20284-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org, mcgrof@kernel.org, sandeen@sandeen.net

On Thu, Apr 06, 2017 at 04:41:38PM +0200, Jan Tulak wrote:
> Followup of my "[xfsprogs] Do we need so many data types for user input?" email.
> 
> In the past, when mkfs was first written, it used atoi and
> similar calls, so the variables were ints. However, the situation moved
> since then and in course of the time, mkfs began to use other types too.
> 
> Clean and unify it. We don't need negative values anywhere in the code and
> some numbers has to be 64bit. Thus, uint64 is the best candidate as the target
> type.

I'm with Darrick and Eric on this - it's not the right conversion to
make for all the reasons they've pointed out. Further, I think it's
the wrong direction to be working in.

What I originally intended the config option table to be used for
was to /replace all these config variables/ with config option table
lookups. We don't need tens of variables to say we certain options
set - once option parsing is complete we can just lookup the config
table and use the option value directly. i.e.  we need to work
towards removing all the variables, not try to make them pretty....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
