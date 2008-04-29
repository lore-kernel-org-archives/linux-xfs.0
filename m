Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 17:21:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3T0LU3f025765
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 17:21:34 -0700
Date: Tue, 29 Apr 2008 10:22:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH, XFSQA] Don't run 175-177 if DMAPI is not supported
Message-ID: <20080429002211.GH108924158@sgi.com>
References: <20080423013802.GJ103491721@sgi.com> <480EDE04.5080003@sgi.com> <20080424065822.GY103491721@sgi.com> <481515C8.6020601@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481515C8.6020601@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 28, 2008 at 10:09:44AM +1000, Timothy Shimmin wrote:
> David Chinner wrote:
> >On Wed, Apr 23, 2008 at 04:58:12PM +1000, Timothy Shimmin wrote:
> >>Hi,
> >>
> >>_test_punch already does a umount $SCRATCH_MNT.
> >>However, IMHO, it would probably be nicer if one could
> >>use a _require_dmapi or really it may be simpler if
> >>we could roll it into common.dmapi
> >>so one just needs to include common.dmapi and
> >>it would complain at that point if the kernel
> >>didn't support it.
> >
> >Sure, but we don't have that, and I'm not about to spend the time to
> >convert >20 tests to something like this. Right now I just want to
> >remove all the bloody silly test failures on mainline kernels.
> >
> >All the other dmapi tests "not run" just fine, I want these to do
> >the same thing. Is that good enough to check in right now?
> >
> >Cheers,
> >
> >Dave.
> 
> Sure, that's fine.
> 
> I was really just suggesting to put:
> 
> +# test that we have DMAPI support
> +_dmapi_scratch_mount
> +unmount $SCRATCH_MNT > /dev/null 2>&1
> 
> directly into common.dmapi - not as a function
> but just as code to always execute.

Ok, so i tried this and all the dmapi tests then gave "not run"
status even though dmapi was build into the kernel.

Don't know why, don't really have time to find out right now.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
