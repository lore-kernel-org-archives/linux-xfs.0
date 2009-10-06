Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n965qbZn023800 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 00:52:42 -0500
Received: from hera.kernel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29CD4BD5098
	for <xfs@oss.sgi.com>; Mon,  5 Oct 2009 22:54:01 -0700 (PDT)
Received: from hera.kernel.org (hera.kernel.org [140.211.167.34]) by
	cuda.sgi.com with ESMTP id OC9ieUl2X6OmaZEJ for
	<xfs@oss.sgi.com>; Mon, 05 Oct 2009 22:54:01 -0700 (PDT)
Message-ID: <4ACADB74.5090508@kernel.org>
Date: Tue, 06 Oct 2009 14:53:56 +0900
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: stack bloat after stackprotector changes
References: <4ACA5EB0.4010707@sandeen.net>
In-Reply-To: <4ACA5EB0.4010707@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> It seems that after:
> 
> commit 5d707e9c8ef2a3596ed5c975c6ff05cec890c2b4
> Author: Tejun Heo <tj@kernel.org>
> Date:   Mon Feb 9 22:17:39 2009 +0900
> 
>     stackprotector: update make rules
> 
> xfs stack usage jumped up a fair bit;
> 
> Not a lot in each case but could be significant as it accumulates.
> 
> I'm not familiar w/ the gcc stack protector feature; would this be an
> expected result?

Yeah, it adds a bit of stack usage per each function call and around
arrays which seem like they could overflow, so the behavior is
expected and I can see it can be a problem with function call depth
that deep.  Has it caused actual stack overflow?

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
