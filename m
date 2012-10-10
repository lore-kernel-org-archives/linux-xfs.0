Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9AM065a167837 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 17:00:06 -0500
Received: from mail-oa0-f53.google.com (mail-oa0-f53.google.com
	[209.85.219.53]) by cuda.sgi.com with ESMTP id NmksmdGHWa4cPDYF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Oct 2012 15:01:38 -0700 (PDT)
Received: by mail-oa0-f53.google.com with SMTP id j6so1159188oag.26
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 15:01:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121010212733.GW23644@dastard>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEwYyzTLTJk7SU0t=1SnT-V=7VadtKd0v9qj0soXtJ8XTg@mail.gmail.com>
	<20121010212733.GW23644@dastard>
Date: Thu, 11 Oct 2012 00:01:37 +0200
Message-ID: <CAAxjCEzV+7yqpd5x_VbnAxiWptkF3Wp6zdpH-k7sk-jg+auoYA@mail.gmail.com>
Subject: Re: A little RAID experiment
From: Stefan Ring <stefanrin@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

> Just inidicates that the working set for your test is much more
> resident in the controller cache - has nothing to do with the disk
> speeds. Tun a larger set of files/workload and the results will end
> up a lot closer to disk speed instead of cache speed...

That's indeed a valid objection, but I just verified that with the
working set size multiplied by the relative cache size difference
(64GB instead of 8GB), the performance stays exactly the same. The new
controller seems to run much better cache control algorithms.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
