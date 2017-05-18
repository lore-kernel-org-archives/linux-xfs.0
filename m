Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:49173 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752354AbdERGCs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 02:02:48 -0400
Date: Thu, 18 May 2017 16:01:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: remove double-underscore integer types
Message-ID: <20170518060158.GP17542@dastard>
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013043.GU4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518013043.GU4519@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Wed, May 17, 2017 at 06:30:43PM -0700, Darrick J. Wong wrote:
> This is a purely mechanical patch that removes the private
> __{u,}int{8,16,32,64}_t typedefs in favor of using the system
> {u,}int{8,16,32,64}_t typedefs.  This is the sed script used to perform
> the transformation and fix the resulting whitespace and indentation
> errors:
> 
> s/typedef\t__uint8_t/typedef __uint8_t\t/g
> s/typedef\t__uint/typedef __uint/g
> s/typedef\t__int\([0-9]*\)_t/typedef int\1_t\t/g
> s/__uint8_t\t/__uint8_t\t\t/g
> s/__uint/uint/g
> s/__int\([0-9]*\)_t\t/__int\1_t\t\t/g
> s/__int/int/g
> /^typedef.*int[0-9]*_t;$/d

I'm not sure that this is entirely correct when it comes to sparse
endian notations or the way the __ types were intended to be used.
ISTR we used the __ types were originally for the in-memory endian
converted variable definitions that shadowed the on-disk structures.
The cleanup plan I was planning to do was to convert these all to
the linux kernel definitions of __[s,u][8,16,32,64] so it was clear
they shadow on disk structures of specific sizes.

Once that was done, everything else could be converted to c99 types
(like you've done above) and then we'd be free of all the old
__[u]int*_t types....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
