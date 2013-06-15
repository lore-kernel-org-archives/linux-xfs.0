Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 886247F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 19:17:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6B9D6304051
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 17:17:33 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id pzzJBx7353OlunOp for
	<xfs@oss.sgi.com>; Fri, 14 Jun 2013 17:17:32 -0700 (PDT)
Date: Fri, 14 Jun 2013 20:17:30 -0400 (EDT)
From: Nathan Scott <nathans@redhat.com>
Message-ID: <504625587.1365681.1371255450937.JavaMail.root@redhat.com>
In-Reply-To: <CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<91017249.1356192.1371248207334.JavaMail.root@redhat.com>
	<CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@redhat.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: xfs@oss.sgi.com



----- Original Message -----
> actually I have since found a decoder ring here -
> http://xfs.org/index.php/Runtime_Stats and have been incorporating a lot of
> the data so I can look at things in real time.  I'd still love to know why

Ah, good stuff.

> writing 1000 1K files results in 200MB/sec of disk I/O though.  clearly

For how many seconds?  (or fractions thereof?)  You may need the level of
detail that only tracing will provide to explore further, although off the
top of my head I'm not sure exactly which events you should focus on (log,
inode creation, or space allocation at a guess).

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
