Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5FA528068
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 08:36:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CFC28AC016
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 06:36:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZdliGNddhqtZAYHp for
	<xfs@oss.sgi.com>; Tue, 08 Apr 2014 06:36:00 -0700 (PDT)
Date: Tue, 8 Apr 2014 09:35:54 -0400
From: Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: [PATCH 1/2] xfsdump: getdents.c: clean up ifdef-hell around
	sys_getdents
Message-ID: <20140408133554.GD12397@redacted.bos.redhat.com>
References: <20140324181907.GF23291@redacted.bos.redhat.com>
	<20140408003311.GH27017@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140408003311.GH27017@dastard>
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
Cc: xfs@oss.sgi.com

On Tue, Apr 08, 2014 at 10:33:11AM +1000, Dave Chinner wrote:
> On Mon, Mar 24, 2014 at 02:19:07PM -0400, Kyle McMartin wrote:
> > Remove the ifdef-hell imported from glibc around getdents64. Everything
> > since 2.4.1 supports things properly and this seems like a sensible
> > clean up, so lets just assume it exists and handle it by falling back
> > if not.
> > 
> > Additionally, if the old getdents syscall doesn't exist, just stub out
> > the actual syscall and return ENOSYS.
> > 
> > ---
> 
> Kyle, these two patches are missing your SOB. I'm going to assume
> you wrote this yourself (given the history, it's a fair bet :)
> and add them in - let me know if then assumption is wrong so I can
> correct it.

That's correct, my apologies for not including it on the submission.

Thanks very much Dave.

--Kyle

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
