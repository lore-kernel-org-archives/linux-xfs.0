Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BD6827F61
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 11:14:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AEE0D8F804B
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 09:14:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id eDviXt3qXkrw8SFl for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2015 09:14:26 -0700 (PDT)
Message-ID: <5579B3E3.2080400@sandeen.net>
Date: Thu, 11 Jun 2015 11:14:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs for-next build error on Debian Wheezy / amd64
References: <20150610070604.GA9855@infradead.org>	<20150610081914.GV9143@dastard>	<20150610082415.GA23860@infradead.org>	<20150610083441.GW9143@dastard>	<20150610084043.GA31392@infradead.org>	<20150610091952.GE24666@dastard>
	<20150611160335.GA28312@infradead.org>
In-Reply-To: <20150611160335.GA28312@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 6/11/15 11:03 AM, Christoph Hellwig wrote:
> On Wed, Jun 10, 2015 at 07:19:52PM +1000, Dave Chinner wrote:
>> Actually, I think that platform_defs.h needs to be symlinked into
>> include/xfs. that was the intent, but I bet I missed it because
>> the build wasn't failing and so I didn't notice that I'd failed to
>> put it into the the include/Makefile rule for installed headers.
>>
>> Yeah, there we are - the install-dev rule has a specific install
>> rule for platform_defs.h as well, so it was being included in the
>> package builds correctly (i.e. installed in /usr/include/xfs)
>> without being mentioned in the HFILES definition that defines header
>> files to be packaged for /usr/include/xfs....
>>
>> Patch below (which uncovers another issue to do with include files
>> on the distclean side, but is not fatal and I'll fix tomorrow).
> 
> This works fine for me.
> 
> Btw, we really shouldn't be installing generated files, that's a major
> PITA for multiarch setups.  I'll see how much of the autoconf magic
> we even need here.

FWIW, we do a crazy thing in RPM land ...

# cat /usr/include/xfs/platform_defs.h 
/* This file is here to prevent a file conflict on multiarch systems. A
 * conflict will occur because platform_defs.h has arch-specific definitions.
 *
 * DO NOT INCLUDE THE NEW FILE DIRECTLY -- ALWAYS INCLUDE THIS ONE INSTEAD. */

#if defined(__i386__)
#include "platform_defs-i386.h"
#elif defined(__x86_64__)
#include "platform_defs-x86_64.h"
#elif defined(__powerpc64__)
#include "platform_defs-ppc64.h"
... etc ...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
