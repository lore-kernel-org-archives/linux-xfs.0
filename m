Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 39DBE7F7D
	for <xfs@oss.sgi.com>; Sat,  4 Jul 2015 18:38:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B90D8AC001
	for <xfs@oss.sgi.com>; Sat,  4 Jul 2015 16:38:08 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	W7pOh1FRj1SyVbjI for <xfs@oss.sgi.com>;
	Sat, 04 Jul 2015 16:38:06 -0700 (PDT)
Date: Sun, 5 Jul 2015 09:38:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failing XFS filesystem underlying Ceph OSDs
Message-ID: <20150704233802.GS7943@dastard>
References: <CADb9451tB71D3XCqcOkDxzpzbdEHqwj7XCZUpL8yg1DzYbpwBw@mail.gmail.com>
	<20150703235141.GQ7943@dastard>
	<CADb9451j0WEeL4m-fEHzrOf3ys+eSHJKNzcN9oHAOs2kDLL_kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADb9451j0WEeL4m-fEHzrOf3ys+eSHJKNzcN9oHAOs2kDLL_kQ@mail.gmail.com>
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
To: Alex Gorbachev <ag@iss-integration.com>
Cc: xfs@oss.sgi.com

On Sat, Jul 04, 2015 at 10:46:24AM -0400, Alex Gorbachev wrote:
> Hello Dave, thank you for the response.  I got some recommendations on the
> ceph-users list that essentially pointed to the problem with
> vm.swappiness=0 and its new behavior - described here
> https://www.percona.com/blog/2014/04/28/oom-relation-vm-swappiness0-new-kernel/
> 
> Basically setting it to 0 creates these OOM conditions due to never
> swapping anything out.  So I changed these settings right away:
> 
> sysctl vm.swappiness=20 (can probably be 1 as per article)
> 
> sysctl vm.min_free_kbytes=262144

That's not an explanation for what looks to be page cache radix
tree coruption. Memory reclaim still occurs with the settings you
have now and, well, those changes occurred back in 3.5 - some
3 years ago - so it's not really an explanation for a problem with a
recent 4.1 kernel...

> So far no issues, but I need to wait a week to see if anything shows up.
> Thank you for reviewing the error codes.

I expect that you'll see the problems again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
