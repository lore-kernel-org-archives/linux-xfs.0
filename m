Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9AEuHYB058616 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 09:56:17 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	mpJAv7t4ntC9rlrr (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 07:57:48 -0700 (PDT)
Received: by mail-ob0-f181.google.com with SMTP id un3so625036obb.26
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 07:57:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
Date: Wed, 10 Oct 2012 16:57:47 +0200
Message-ID: <CAAxjCEwYyzTLTJk7SU0t=1SnT-V=7VadtKd0v9qj0soXtJ8XTg@mail.gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

Btw, one of our customers recently aquired new gear with HP SmartArray
Gen8 controllers. Now they are something to get excited about! This is
the kind of write performance I would expect from an expensive server
product. Check this out (this is again my artificial benchmark as well
as random write of 4K blocks):

SmartArray P400, 6 300G disks (10k, SAS) RAID 6, 256M BBWC:

ag4
Read 0b  Written 161.56Mb  Total transferred 161.56Mb  (5.3853Mb/sec)
 1378.63 Requests/sec executed

random write
Read 0b  Written 97.578Mb  Total transferred 97.578Mb  (3.2526Mb/sec)
  832.66 Requests/sec executed

SmartArray Gen8, 8 300G disks (15k, SAS) RAID 5, 2GB FBWC:

ag4
Read 0b  Written 2.4575Gb  Total transferred 2.4575Gb  (83.883Mb/sec)
21474.03 Requests/sec executed

random write
Read 0b  Written 343.86Mb  Total transferred 343.86Mb  (11.462Mb/sec)
 2934.24 Requests/sec executed

So yeah, the disks are a bit faster. But what does that matter when
there is such a huge difference otherwise?

Unfortunately, while composing this text, I noticed that the new one
is configured as RAID 5, and I cannot change it because of HP's
licensing policy. That makes it not a meaningful comparison, although
extrapolation from previous SmartArray controllers would suggest that
the RAID5 and RAID6 performance is comparable.

My subjective impression is still a very good one!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
