Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 09:21:17 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5TGL7tL023671
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 09:21:09 -0700
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l5TFoJ4x013463
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 11:50:19 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5TFoFO9011933
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 11:50:15 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5TFo9q9225876
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 09:50:11 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5TFo8tY021841
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 09:50:08 -0600
Message-ID: <46852A2C.9040407@us.ibm.com>
Date: Fri, 29 Jun 2007 11:50:04 -0400
From: Mingming Caoc <cmm@us.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
References: <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070628025543.9467216f.akpm@linux-foundation.org> <20070628175757.GA1674@amitarora.in.ibm.com> <20070628113342.c9c0f49c.akpm@linux-foundation.org> <20070629135612.GH29279@thunk.org>
In-Reply-To: <20070629135612.GH29279@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

Theodore Tso wrote:
> On Thu, Jun 28, 2007 at 11:33:42AM -0700, Andrew Morton wrote:
>   
>>> Please let us know what you think of Mingming's suggestion of posting
>>> all the fallocate patches including the ext4 ones as incremental ones
>>> against the -mm.
>>>       
>> I think Mingming was asking that Ted move the current quilt tree into git,
>> presumably because she's working off git.
>>     
>
> No, mingming and I both work off of the patch queue (which is also
> stored in git).  So what mingming was asking for exactly was just
> posting the incremental patches and tagging them appropriately to
> avoid confusion.
>
> I tried building the patch queue earlier in the week and it there were
> multiple oops/panics as I ran things through various regression tests,but that may have been fixed since (the tree was broken over the
> weekend and I may have grabbed a broken patch series) or it may have
> been a screw up on my part feeding them into our testing grid.  I
> haven't had time to try again this week, but I'll try to put together
> a new tested ext4 patchset over the weekend.
>
>   
I think the ext4 patch queue is in good shape now.  Shaggy have tested 
in on dbench, fsx, and tiobench, tests runs fine. and BULL team has 
benchmarked  the latest ext4 patch queue with iozone and FFSB.

Regards,
Mingming
>> I'm not sure what to do, really.  The core kernel patches need to be in
>> Ted's tree for testing but that'll create a mess for me.
>>     
>
> I don't think we have a problem here.  What we have now is fine, and
> it was just people kvetching that Amit reposted patches that were
> already in -mm and ext4.
>
> In any case, the plan is to push all of the core bits into Linus tree
> for 2.6.22 once it opens up, which should be Real Soon Now, it looks
> like.
>
> 						- Ted
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
