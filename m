Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 05:59:20 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6JCxFbm017338
	for <linux-xfs@oss.sgi.com>; Thu, 19 Jul 2007 05:59:16 -0700
Subject: Re: tuning XFS for tiny files
References: <m23azlbpl1.fsf@tstotts.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Jul 2007 15:38:43 +0200
In-Reply-To: <m23azlbpl1.fsf@tstotts.net>
Message-ID: <p73wswwwm1o.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: timotheus <timotheus@tstotts.net>
Cc: linux-xfs@oss.sgi.com

timotheus <timotheus@tstotts.net> writes:

> Hi. Is there a way to tune XFS filesystem parameters to better address
> the usage pattern of 10000s of tiny files in directories such as:
>     maildir directory
>     mh mail directory
>     ccache directory
> 
> My understanding is that XFS will always be much slower than reiserfs
> with respect to deleting 10000s files; but that XFS might be possible to
> tune toward more rapid read access of 10000s of tiny files.

-d agcount=1 at mkfs time might help (unless you have a lot of CPUs) 

-Andi
