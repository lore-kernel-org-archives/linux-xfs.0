Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9180C7F59
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 07:16:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7014B8F8054
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 05:16:06 -0700 (PDT)
Received: from p-smtp-as-01.sunrise.ch (p-smtp-as-01.sunrise.ch
	[212.35.39.69]) by cuda.sgi.com with ESMTP id hQWyehGMDT0HWj1g
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 07 Aug 2015 05:16:04 -0700 (PDT)
Message-ID: <55C4A182.5030904@vollmann.ch>
Date: Fri, 07 Aug 2015 14:16:02 +0200
From: Detlef Vollmann <dv@vollmann.ch>
MIME-Version: 1.0
Subject: Re: xfsdump doesn't compile: undefined reference to 'min'
References: <55C312CF.2040408@vollmann.ch> <20150806212620.GD3902@dastard>
In-Reply-To: <20150806212620.GD3902@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/06/15 23:26, Dave Chinner wrote:
> On Thu, Aug 06, 2015 at 09:54:55AM +0200, Detlef Vollmann wrote:
>> The message doesn't say from which header and configure doesn't test
>> for it.
>> If I compile it (cross-compilation, gcc, uclibc, xfsprogs 3.1.11,
>> xfsdump 3.1.4), I get lots of errors:
>> warning: implicit declaration of function 'max'
>> undefined reference to 'min'
>
> #include <xfs/xfs.h>
>    -> /usr/include/xfs/xfs.h
>       #include <xfs/platform_defs.h>
>         -> /usr/include/xfs/platform_defs.h
>            #define min(a,b)	(((a)<(b))?(a):(b))
>
> These headers come from xfsprogs, and you'll need to upgrade that
> package to 3.2.x....
Thank.
Unfortunately that doesn't seem to be an option, so sticking with xfsdump-3.1.3.

   Detlef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
