Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A1B7829E1D
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 12:51:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46D08AC001
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 10:51:46 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id BW6i6i8t2ifQ7EH6 for
	<xfs@oss.sgi.com>; Tue, 09 Apr 2013 10:51:39 -0700 (PDT)
Date: Tue, 9 Apr 2013 19:51:36 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_repair has been running for a very long time, no disk IO.
Message-ID: <20130409195136.5e16473d@harpe.intellique.com>
In-Reply-To: <20130409125402.GO17758@dastard>
References: <20130409121726.6342519e@harpe.intellique.com>
	<20130409120236.GL17758@dastard>
	<20130409143010.114f3fda@harpe.intellique.com>
	<20130409125402.GO17758@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Le Tue, 9 Apr 2013 22:54:02 +1000
Dave Chinner <david@fromorbit.com> =E9crivait:

> Yes, it turns prefetching off, which is what usually what causes the
> hangs. Though 3.1.4 is pretty old, and I think a few prefetch hangs
> were fixed in 3.1.8....
> =


Actually 3.1.11-pre2 did it without -P. Thanks.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
