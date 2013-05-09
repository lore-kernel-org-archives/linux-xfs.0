Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F77229DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 17:39:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09EA9AC00A
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 15:39:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AnXH8AQJ8ieTCVqF for <xfs@oss.sgi.com>;
	Thu, 09 May 2013 15:39:53 -0700 (PDT)
Date: Fri, 10 May 2013 08:39:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs_repair segfaults.
Message-ID: <20130509223928.GT24635@dastard>
References: <5187BF8A.2040303@sandeen.net>
	<CADNx=KvZPhbRn9Kc3+KdoAY7jZ3U0uyG6wgUB5vcxX85CkFdQg@mail.gmail.com>
	<CADNx=Kv0bt3fNGW8Y24GziW9MOO-+b7fBGub4AYP70b5gAegxw@mail.gmail.com>
	<5188FF88.6000508@sandeen.net>
	<CADNx=KvmA7jgqBUO0YvKddHvFaqxHNZKfF3eWajOW8GWKwNhbA@mail.gmail.com>
	<CADNx=Kv=7TFkJKom6_JM8B+A6YRckj175TbCcHrTWYL_N-qkYw@mail.gmail.com>
	<CADNx=KvxtCHEk9G07yS88-casVAXBxRTghV5nGKd_0LtcqpYpQ@mail.gmail.com>
	<20130508233910.GL24635@dastard>
	<CADNx=KuvQ1u+i+PgaCUqLbeGA0-8yfaCP=pez7ptGdm2pL_oGw@mail.gmail.com>
	<CADNx=KuUBVObX=UuWH+DpmES1kGppptMEMgjVnt_2kTzBDadDw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADNx=KuUBVObX=UuWH+DpmES1kGppptMEMgjVnt_2kTzBDadDw@mail.gmail.com>
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
To: Filippo Stenico <filippo.stenico@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, May 09, 2013 at 07:22:32PM +0200, Filippo Stenico wrote:
> Hello,
> ran xfs_repair -vv -L -P -m1750 and segfault at expected point.
> 
> I got the core-dump with dbg symbols, along with repair output and strace
> output.
> 
> What should I do with it? Provide as it is?

Run it in gdb to get a stack trace of where it died.

$ gdb xfs_repair corefile
...
> bt

and post the output, along with the repair output from the run that
crashed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
