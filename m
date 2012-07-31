Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6VAOUWJ167417 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 05:24:30 -0500
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id 7Xk5mF1JSbEtppz2 for
	<xfs@oss.sgi.com>; Tue, 31 Jul 2012 03:24:28 -0700 (PDT)
Date: Tue, 31 Jul 2012 06:24:26 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
Message-ID: <1148424756.1249426.1343730266948.JavaMail.root@redhat.com>
In-Reply-To: <20120730220413.GI2877@dastard>
Subject: Re: [PATCH] xfstests: Change fstrim behaviour to be consistent with
	upstream version
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
To: Dave Chinner <david@fromorbit.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

> If we have duplicate code (i.e. a copy of the upstream utility) or
> the local tool can be completely replaced by the upstream tool,
> then we should use upstream and remove the local copy completely.
> Distros have been shipping fstrim for long enough now that most
> people running testing on upstream kernels will have it installed...
> 

OK, I'll create the patch which drops local version.

> Adding a _require_fstrim() function that checks for the upstream
> version of fstrim to be installed for each test that requires it
> would go along with this.

Did you mean something like

_require_fstrim()
{
         which fstrim &>/dev/null || _notrun "This test requires fstrim utility."
}

in common.rc or locally in each test?

Thanks for comments!

Tomas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
