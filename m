Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B15607F50
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 06:44:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B391304032
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 04:44:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id v0SVGlH7KqrGPhYb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 04:44:40 -0700 (PDT)
Date: Wed, 12 Aug 2015 13:42:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/2] xfs: kill lockdep false positives from readdir
Message-ID: <20150812114225.GA3712@redhat.com>
References: <1439330648-1057-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439330648-1057-1-git-send-email-david@fromorbit.com>
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
Cc: jack@suse.cz, xfs@oss.sgi.com

On 08/12, Dave Chinner wrote:
>
> Oleg and Jan, this patchset should fix the lockdep issues that have
> been seen with the freeze rework. Oleg, can you you try it with your
> current patchset and testing and let me know if there are any issues
> that you see?

Tested-by: Oleg Nesterov <oleg@redhat.com>



To clarify, I tested these patches with

	[PATCH v2 0/8] change sb_writers to use percpu_rw_semaphore

I sent yesterday first. Then I applied the additional patch (attached
below) which just restores the lockdep improvements from v1, everything
looks fine:

	Ran: generic/068 generic/085 generic/280 generic/311 xfs/011 xfs/119 xfs/297
	Passed all 7 tests

nothing interesting in dmesg.

Thanks Dave!

Oleg.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
