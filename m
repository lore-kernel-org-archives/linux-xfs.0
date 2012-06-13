Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D6DZOR093318 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 01:13:35 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cAuDs0w1lUwcNCwW for
	<xfs@oss.sgi.com>; Tue, 12 Jun 2012 23:13:34 -0700 (PDT)
Message-ID: <4FD82F89.80106@redhat.com>
Date: Wed, 13 Jun 2012 08:13:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
	<20120613013549.GO22848@dastard> <20120613033052.GT22848@dastard>
In-Reply-To: <20120613033052.GT22848@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

Il 13/06/2012 05:30, Dave Chinner ha scritto:
>> > 
>> > Also, a minor nit, but you should credit where this code has
>> > originated from in the commit messages, and describe the use case
>> > for requiring it. i.e. based on:
>> > 
>> > http://permalink.gmane.org/gmane.linux.file-systems/62449

Interesting, I didn't know this---I wrote the code from scratch.

I took the description from the man pages ("This operation is a fast
method of overwriting any from the range specified with zeros without
removing any blocks or having to write zeros to disk"), so perhaps those
will have to be patched as well.

> Oh, and you'll need to provide a new xfstests test based on 242 that
> uses the new fallocate interface, and to do that you'll also need to
> add support for the new fallocate function in xfs_io.

Sure.  Thanks for the hints, I'll submit a v2 (may take a while as I'll
leave for holiday soon).

Paolo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
