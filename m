Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3872729DFA
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 07:54:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 13E48304053
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 05:54:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FIHSS04HFjMEEJdM for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 05:54:06 -0700 (PDT)
Date: Tue, 9 Apr 2013 22:54:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair has been running for a very long time, no disk IO.
Message-ID: <20130409125402.GO17758@dastard>
References: <20130409121726.6342519e@harpe.intellique.com>
	<20130409120236.GL17758@dastard>
	<20130409143010.114f3fda@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130409143010.114f3fda@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 09, 2013 at 02:30:10PM +0200, Emmanuel Florac wrote:
> Le Tue, 9 Apr 2013 22:02:36 +1000
> Dave Chinner <david@fromorbit.com> =E9crivait:
> =

> > Either use the latest version, or use the -P option.
> > =

> =

> Currently running the latest version (3.1.11-pre2). I'll wait for a
> while (it takes something like 10 minutes to reach the point at which it
> freezes over). I suppose -P makes it slower?

Yes, it turns prefetching off, which is what usually what causes the
hangs. Though 3.1.4 is pretty old, and I think a few prefetch hangs
were fixed in 3.1.8....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
