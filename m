Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33E377FE1
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 04:16:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E2678F8035
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 02:16:32 -0800 (PST)
Received: from mail-qe0-f53.google.com (mail-qe0-f53.google.com
	[209.85.128.53]) by cuda.sgi.com with ESMTP id TJ1uBuChkuE0dyZa
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Mar 2013 02:16:28 -0800 (PST)
Received: by mail-qe0-f53.google.com with SMTP id cz11so891820qeb.12
	for <xfs@oss.sgi.com>; Fri, 08 Mar 2013 02:16:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130307232214.GY23616@dastard>
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com>
	<CAPcwv6wK7m5UbJZass5690N5UpXEMV+HVzJa5mn9KWtT9UPQ9w@mail.gmail.com>
	<20130307232214.GY23616@dastard>
Date: Fri, 8 Mar 2013 11:16:27 +0100
Message-ID: <CAPcwv6zcYAQLh5OXrMXvP-vUkgfPR_yffWYi4a_wUbZoKj-tag@mail.gmail.com>
Subject: Re: XFS filesystem corruption
From: Julien FERRERO <jferrero06@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

>
> Yes they were. XFS had barrier support added in 2.6.15.
>

The XFS was running over a software RAID0 or software RAID5 depending
on the product. In both case, my understanding is that either software
RAID0 or software RAID5 did not support barrier in 2.6.18.

> Yes, that would have been me that said that. I started seeing lots
> of boy-racer "tweak your filesystem to go faster" blogs recommending
> that unwritten extents should be turned off high up in google
> results, with numbers to prove that it improved performance.
>
> There were two common things wrong with these blogs:
>
>         1. None of them mentioned that turning off unwritten extents
>         exposes stale data to users. i.e. a whopping great big
>         security hole.
>
>         2. they reported significant performance improvements for
>         workloads that *didn't use unwritten extents* when they set
>         this flag. i.e. they mistook run-to-run variablity of the
>         benchmark for a performance improvement. i.e. Benchmarking
>         101 Fail.
>
> When you get people who do not understand what they are doing and
> giving bad advice as the first 10 hits for a google search about
> optimising/tuning XFS filesystems, it's a major concern, and so I
> took steps to ensure you can't turn off unwritten extents with
> mkfs...

Thanks for the explanation.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
