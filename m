Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:35422 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S968937AbdDTAJ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 20:09:28 -0400
Date: Thu, 20 Apr 2017 10:09:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] mkfs: unify numeric types of main variables in main()
Message-ID: <20170420000909.GI12369@dastard>
References: <20170419153025.10368-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170419153025.10368-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2017 at 05:30:24PM +0200, Jan Tulak wrote:
> Followup of my "[xfsprogs] Do we need so many data types for user input?" email.
> This version has bool for flags and uses PRIu64 for printing 64bit values.
> 
> Other issues from RFC, that I didn't get a satisfactory feedback to:
>  * __uint64_t is used because it is declared in xfsprogs, so unless there is a
>    reason to not use it (e.g. the declared type is just for some special use,
>    or is obsolete), I'm sticking to it.

uint64_t is a standard C99 type. Please use it over an internal
type that we plan to get rid of.  i.e.

http://oss.sgi.com/archives/xfs/2016-01/msg00386.html

These patches were never finalised/finished because of conflicts
with all the COW work that was pending at the time. This type
conversion still needs to be picked up and finished...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
