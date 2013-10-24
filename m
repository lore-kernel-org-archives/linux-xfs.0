Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29C547F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 12:06:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A27F8F8059
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 10:05:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id pkODxTA5UCFufvut (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 10:05:59 -0700 (PDT)
Date: Thu, 24 Oct 2013 13:05:28 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: xfstest 318
Message-ID: <20131024130528.37c2c44e@oracle.com>
In-Reply-To: <20131024154414.GB19055@infradead.org>
References: <20131024154414.GB19055@infradead.org>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 24 Oct 2013 08:44:14 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> This test has always been failing for me on my Debian stable system
> with the output below, any idea why this could be?

Looks like the | getfacl_filter_id isn't doing any good on the getfacl
that is being run in the userns because the uids don't match $acl[12]
(which is the point), and the uids that _acl_setup_ids picked are not
the same distance apart as they were on my system. So on your system
$acl2 is not $acl1 + 1.

Let me see about running the second getfacl through a filter that knows
how to replace it based on the delta between $acl1 and $acl2, I think
that should always work.

> --- tests/generic/318.out	2013-09-09 14:41:08.000000000 +0000
> +++ /root/xfstests/results//generic/318.out.bad	2013-10-24
> 15:44:01.000000000 +0000 @@ -17,7 +17,7 @@
>  # group: 65534
>  user::rw-
>  user:0:r-x	#effective:r--
> -user:1:rw-	#effective:r--
> +user:3:rw-	#effective:r--
>  group::r--
>  group:0:--x	#effective:---
>  mask::r--
> @@ -43,7 +43,7 @@
>  # group: 65534
>  user::rw-
>  user:0:r-x	#effective:r--
> -user:1:rw-	#effective:r--
> +user:3:rw-	#effective:r--
>  group::r--
>  group:0:--x	#effective:---
>  mask::r--

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
