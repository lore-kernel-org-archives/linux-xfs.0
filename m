Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DBjc5k034858 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 06:45:38 -0500
Received: from g5t0008.atlanta.hp.com (g5t0008.atlanta.hp.com [15.192.0.45])
	by cuda.sgi.com with ESMTP id nvan8WVHJ9dU1kNx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 04:45:37 -0700 (PDT)
Received: from G6W1798G.americas.hpqcorp.net (g6w1798g.atlanta.hp.com
	[16.230.17.175]) (using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g5t0008.atlanta.hp.com (Postfix) with ESMTPS id A561524171
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 11:45:36 +0000 (UTC)
From: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
Subject: Re: XFS / xfssyncd lock-ups on 2.6.38-8
Date: Fri, 13 Apr 2012 11:44:23 +0000
Message-ID: <A9EE9F358EEA094684DE8F34867F5DB72F9B2485@G4W3214.americas.hpqcorp.net>
Content-Language: en-US
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> > Would appreciate any thoughts/pointers to fixes or workarounds if this is a 
> > known issue.
>
> This was fixed by:
>
>         xfs: force the log if we encounter pinned buffers in .iop_pushbuf

Can this patch be applied to 2.6.38 by itself or does it depend on other things that are not present in 2.6.38? I noticed it's small, applies and compiles but I can't judge if there are other dependencies. 

...Juerg


>
> in Linux 3.1.  I've also backported it to the 3.0-stable issues.  I
> would recommend to upgrade to the latest Linux 3.0-stable release, as
> I'll plan to backport all important XFS fixes to it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
