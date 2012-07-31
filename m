Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6VAfE14168431 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 05:41:14 -0500
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id UxPG5uBbw4vZjAIi for
	<xfs@oss.sgi.com>; Tue, 31 Jul 2012 03:41:13 -0700 (PDT)
Date: Tue, 31 Jul 2012 06:41:12 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
Message-ID: <483754529.1252527.1343731272189.JavaMail.root@redhat.com>
In-Reply-To: <20120730215630.GH2877@dastard>
Subject: Re: [PATCH] xfstests: Don't require to set $TEST_DEV and $TEST_DIR
	when creating new script
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

> > 
> >    #  Mandatory Config values.
> >    MC=""
> > -  [ -z "$EMAIL" ]          && MC="$MC EMAIL"
> > -  [ -z "$TEST_DIR" ]       && MC="$MC TEST_DIR"
> > -  [ -z "$TEST_DEV" ]       && MC="$MC TEST_DEV"
> > +  [ -z "$EMAIL" ]                           && MC="$MC EMAIL"
> > +  [ -z "$TEST_DIR" ] && [ "$iam" != "new" ] && MC="$MC TEST_DIR"
> > +  [ -z "$TEST_DEV" ] && [ "$iam" != "new" ] && MC="$MC TEST_DEV"
> 
> Given that I'm currently in the process of killing $iam as I
> rework the structure of xfstests, I really don't like the idea of
> introducing new dependencies on it.

OK, I didn't know that. ;-)

> Also, I prefer to know that someone writing a new test is developing
> it in a configured, working test environment. After all, you have to
> test your new test as you write it... :p

I thought that is not necessary to depend on those if new script doesn't require them but I can see your point.

Thanks for comments!

Tomas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
