Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B4BB29E2B
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 17:20:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2894A8F8092
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 15:20:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id C8nryavuuM4EGmo3 for
	<xfs@oss.sgi.com>; Wed, 06 Nov 2013 15:19:59 -0800 (PST)
Date: Wed, 6 Nov 2013 18:19:54 -0500
From: Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: [PATCH] xfsdump: don't assume getdents exists
Message-ID: <20131106231954.GD29593@redacted.bos.redhat.com>
References: <20131106213635.GC24712@redacted.bos.redhat.com>
	<20131106224844.GI6188@dastard>
	<20131106225620.GC29593@redacted.bos.redhat.com>
	<20131106231713.GK6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106231713.GK6188@dastard>
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
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 10:17:13AM +1100, Dave Chinner wrote:
> > I'll try to clean it up and send a patch for that, using getdents64
> > wherever possible, and handling the fallback at runtime instead of
> > making things all ifdeffy... Just wanted to get things building in the
> > mean time. (Oh man the coding style there is janky...)
> 
> I'd factor and reformat the code using the normal kernel style. :)
> 
> And to avoid ifdef hackery and runtime fallbacks, I'd add an
> autoconf macro to determine which getdents call is supported, and
> then only compile in the relevant function and not have to care
> about runtime fallbacks.
> 
> But that may end up more complex and more work than you had in mind,
> so feel free to ignore my suggestions ;)
> 

Good thinking... I'll poke at it.

Thanks Dave!

Kyle

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
