Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 May 2007 07:48:33 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4BEmSfB026547
	for <xfs@oss.sgi.com>; Fri, 11 May 2007 07:48:29 -0700
Message-ID: <4644823A.8090104@goop.org>
Date: Fri, 11 May 2007 07:48:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <20070510225834.GF86004887@sgi.com> <4643A5B2.3060906@goop.org> <20070510232729.GH86004887@sgi.com> <4643AF8F.5040705@goop.org> <20070511003257.GL86004887@sgi.com>
In-Reply-To: <20070511003257.GL86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

David Chinner wrote:
>> Yes, that does look like a good candidate.  Should I try to
>> before-and-after this change?
>>     
>
> Yes please!
>   

OK, definite result.  Before ba87ea699ebd9dd577bf055ebc4a98200e337542: 
all OK.  After: truncated files.

I also got a bmap of a particular truncated file,
linux-clone-test-1/.hg/store/00manifest.i, diffing before with after:

--rw-r--r--  1 root root   3558208 May 11 01:16 /home/jeremy/hg/linux-clone-test-1/.hg/store/00manifest.i
+-rw-r--r--  1 root root   3541760 May 11 01:16 /home/jeremy/hg/linux-clone-test-1/.hg/store/00manifest.i

   16: [6144..6271]:    18141808..18141935  2 (2413168..2413295)   128
   17: [6272..6399]:    18140608..18140735  2 (2411968..2412095)   128
   18: [6400..6911]:    18136464..18136975  2 (2407824..2408335)   512
-  19: [6912..6951]:    18136336..18136375  2 (2407696..2407735)    40
+  19: [6912..6919]:    18136336..18136343  2 (2407696..2407703)     8


    J
