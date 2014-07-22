Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CDA257F47
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 16:57:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68C38AC002
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 14:57:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Eazewb1oKzy7zJGg for <xfs@oss.sgi.com>;
	Tue, 22 Jul 2014 14:56:58 -0700 (PDT)
Date: Wed, 23 Jul 2014 07:56:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem building xfsprogs
Message-ID: <20140722215656.GQ4453@dastard>
References: <20140722160641.GU17967@beardog.cce.hp.com>
	<20140722205605.GJ20518@dastard>
	<CAK2EqxR93J8441Ajj8no7_Pu1WSDLaVsKG=_FLMYvTnOUEzKGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAK2EqxR93J8441Ajj8no7_Pu1WSDLaVsKG=_FLMYvTnOUEzKGQ@mail.gmail.com>
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
To: Martin Furuhjelm <martin.furuhjelm@seagate.com>
Cc: scameron@beardog.cce.hp.com, fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 22, 2014 at 03:14:42PM -0600, Martin Furuhjelm wrote:
> I have just recently gone through the process of attempting to build and
> run xfstests based on the current sources from oss.sgi.com.
> Not having exactly the correct packages and kernel version creates
> problems. The build on FEDORA fails complaining about too many symlinks, I
> was successful on SUSE V 13 updated to kernel v3.15 and adding the
> following packages before attempting git and the build:
> 
> git gcc libtool automake make gettext-tools libattr-devel libacl-devel
> libuuid-devel ncurses-devel quota indent libcap-progs btrfsprogs
> 
> I then git and built xfsprogs followed by xfsdump and finally xfstests
> 
> After adding the fsgqa group and user the appropriate definitions of
> TEST_DEV and SCRATCH_DEV the quick test (./check -g quick)
> runs with 5 errors on xfs and one error on ext4.
> 
> If you just want xfstest to run - you may want to start with SUSE and the
> procedure above.

Perhaps it would be good to document that in the INSTALL file? Can
you write a patch to do that, please?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
