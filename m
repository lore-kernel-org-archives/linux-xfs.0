Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A638A7F3F
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 04:43:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 36760AC001
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 02:43:45 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	erYiXU99bSfCcl7T for <xfs@oss.sgi.com>;
	Mon, 07 Jul 2014 02:43:40 -0700 (PDT)
Date: Mon, 7 Jul 2014 19:43:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Data loss XFS with RT kernel on Debian.
Message-ID: <20140707094334.GA4453@dastard>
References: <CAA85NCjXU7rK8C4AcQ4Tnxowx5MFBUyAoLW_nuwmKyOFL-_PgQ@mail.gmail.com>
	<20140706235701.GQ9508@dastard>
	<CAA85NChTveO_GSJAK9veDH65d0hLhPpxkKhsxKmgBj=AA3mspQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA85NChTveO_GSJAK9veDH65d0hLhPpxkKhsxKmgBj=AA3mspQ@mail.gmail.com>
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
To: Jan de Kruyf <jan.de.kruyf@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 07, 2014 at 09:59:53AM +0200, Jan de Kruyf wrote:
> I tend to agree with Dave that is is an RT problem, however just for your info:
> 
> Kernel 3.2 (the stock Debian kernel) works in both versions, the plain
> vanilla and the RT.
> On Debugging this prob: will it be helpful for any of the parties
> involved if I rig up a serial link and try to get a stacktrace of all
> processes with SysRq ? Does that also give kernel processes? Cause Top
> tells me nothing.
> ( I am a bit fresh to this but willing to try)

Best to start for reading the archives to see the issues and
resolutoins for the problems that Austin Schuh has been having with
recent debian RT kernels - it starts with "XFS Crash" in early March,
and there are other issues from there - the thread migrates to LKML
as core RT problems are diagnosed...

See if the patches for the issues he hit solve your problem, and if
not the threads should give you an idea of who to talk to about the
RT issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
