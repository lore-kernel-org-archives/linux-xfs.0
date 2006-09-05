Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 16:15:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k85NFEDW028040
	for <xfs@oss.sgi.com>; Tue, 5 Sep 2006 16:15:25 -0700
Date: Wed, 6 Sep 2006 09:14:08 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [xfs-masters] Re: [PATCH 2.6.18-rc4-mm3 2/2] fs/xfs: Converting into generic boolean
Message-ID: <20060906091407.M3365803@wobbly.melbourne.sgi.com>
References: <44F833C9.1000208@student.ltu.se> <20060904150241.I3335706@wobbly.melbourne.sgi.com> <44FBFEE9.4010201@student.ltu.se> <20060905130557.A3334712@wobbly.melbourne.sgi.com> <44FD71C6.20006@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44FD71C6.20006@student.ltu.se>; from ricknu-0@student.ltu.se on Tue, Sep 05, 2006 at 02:47:02PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: akpm@osdl.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Tue, Sep 05, 2006 at 02:47:02PM +0200, Richard Knutsson wrote:
> Just the notion: "your" guys was the ones to make those to boolean(_t), 

Sort of, we actually inherited that type from IRIX where it is
defined in <sys/types.h>.

> and now you seem to want to patch them away because I tried to make them 
> more general.

Nah, I just don't see the value either way, and see it as another
code churn exercise.

> So, is the:
> B_FALSE -> false
> B_TRUE -> true
> ok by you?

Personally, no.  Thats code churn with no value IMO.

> >"int needflush;" is just as readable (some would argue moreso) as
> >"bool needflush;" and thats pretty much the level of use in XFS -
> >  
> How are you sure "needflush" is, for example, not a counter?

Well, that would be named "flushcount" or some such thing.  And you
would be able to tell that it was a counter by the way its used in
the surrounding code.

This discussion really isn't going anywhere useful; I think you need
to accept that not everyone sees value in a boolean type. :)

cheers.

-- 
Nathan
