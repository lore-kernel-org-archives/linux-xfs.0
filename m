Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D29EF7FD5
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 19:33:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B532A30405F
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 17:33:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LmvljrYbeVpr5ax5 for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 17:33:13 -0700 (PDT)
Date: Tue, 8 Apr 2014 10:33:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfsdump: getdents.c: clean up ifdef-hell around
	sys_getdents
Message-ID: <20140408003311.GH27017@dastard>
References: <20140324181907.GF23291@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140324181907.GF23291@redacted.bos.redhat.com>
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
To: Kyle McMartin <kmcmarti@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 24, 2014 at 02:19:07PM -0400, Kyle McMartin wrote:
> Remove the ifdef-hell imported from glibc around getdents64. Everything
> since 2.4.1 supports things properly and this seems like a sensible
> clean up, so lets just assume it exists and handle it by falling back
> if not.
> 
> Additionally, if the old getdents syscall doesn't exist, just stub out
> the actual syscall and return ENOSYS.
> 
> ---

Kyle, these two patches are missing your SOB. I'm going to assume
you wrote this yourself (given the history, it's a fair bet :)
and add them in - let me know if then assumption is wrong so I can
correct it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
