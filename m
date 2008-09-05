Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 05 Sep 2008 09:27:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m85GR1U0013290
	for <xfs@oss.sgi.com>; Fri, 5 Sep 2008 09:27:01 -0700
Received: from coraid.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77EC9124CBBC
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2008 09:28:27 -0700 (PDT)
Received: from coraid.com (baron.coraid.com [12.51.113.4]) by cuda.sgi.com with ESMTP id 5UGMkogN6Fy5YBGu for <xfs@oss.sgi.com>; Fri, 05 Sep 2008 09:28:27 -0700 (PDT)
Date: Fri, 5 Sep 2008 12:29:21 -0400
From: Ed Cashin <ecashin@coraid.com>
Subject: Re: xfs_growfs fix backport for 2.6.16.y
Message-ID: <20080905162921.GA8000@coraid.com>
References: <20080825153931.GD7575@coraid.com> <20080826020101.GU5706@disturbed> <20080903182701.GA29192@coraid.com> <20080904231418.GB5991@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904231418.GB5991@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, Adrian Bunk <bunk@kernel.org>

On Fri, Sep 05, 2008 at 09:14:18AM +1000, Dave Chinner wrote:
...
> Ah, yes. That. I think Barry can try to explain that one because:
> 
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/078.out.diff?r1=1.3;r2=1.4
> 
> The test golden output was changed instead of someone understanding
> why the fixes to growfs changed the size that the filesystem was
> grown to. ISTR being opposed to changing the golden output because
> it was the wrong thing to do and would break QA on older kernels,
> not to mention that it indicated some possible off-by-one bug in
> a change that had been made at some point...
> 
> Other than that, the backport should be fine given it passed all the
> other parts of the test....

Oh, that's good news, thanks.

I just need to test the patch on a 32-bit O.S. now, but
I am having a difficult time building xfs-cmds/xfstests
on a CentOS 5 VM.

Does anyone have a recommendation for an O.S. I can use
to build and run the xfsqa test 078?  It would be running
the 2.6.16.62 kernel with the patch in question, not the
stock distro kernel.

-- 
  Ed Cashin <ecashin@coraid.com>
