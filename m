Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 15:49:38 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.229])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5JMnXdo029764
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 15:49:35 -0700
Received: by wx-out-0506.google.com with SMTP id s17so2190816wxc
        for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 15:49:34 -0700 (PDT)
Subject: Re: XFS shrink (step 0)
From: Ruben Porras <nahoo82@gmail.com>
In-Reply-To: <20070604001632.GA86004887@sgi.com>
References: <1180715974.10796.46.camel@localhost>
	 <20070604001632.GA86004887@sgi.com>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 00:22:31 +0200
Message-Id: <1182291751.5289.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, iusty@k1024.org

Am Montag, den 04.06.2007, 10:16 +1000 schrieb David Chinner:

> Here's the "simple" bits that will allow you to shrink
> the filesystem down to the end of the internal log:
> 
> 	0. Check space is available for shrink

Now that I'm almost* finish with the point 1), is there any place in the
xfs_code where a similar task is done? This way I would have a basis to
start off.

Cheers.

* I need only to fix the indentation, and change the ioctl interface as
David suggested in another mail in this thread, so that the
implementation is not so specific.
