Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 18:27:33 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5Q1RNtL007540
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 18:27:25 -0700
Subject: Re: Reducing memory requirements for high extent xfs files
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <467C620E.4050005@agami.com>
References: <200705301649.l4UGnckA027406@oss.sgi.com>
	 <20070530225516.GB85884050@sgi.com> <4665E276.9020406@agami.com>
	 <20070606013601.GR86004887@sgi.com> <4666EC56.9000606@agami.com>
	 <20070606234723.GC86004887@sgi.com>  <467C620E.4050005@agami.com>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 11:26:15 +1000
Message-Id: <1182821175.15488.64.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Hi Mike,

On Fri, 2007-06-22 at 16:58 -0700, Michael Nishimoto wrote:
> >  > Also, should we consider a file with 1MB extents as
> >  > fragmented?  A 100GB file with 1MB extents has 100k extents.
> > 
> > Yes, that's fragmented - it has 4 orders of magnitude more extents
> > than optimal - and the extents are too small to allow reads or
> > writes to acheive full bandwidth on high end raid configs....
> 
> Fair enough, so multiply those numbers by 100 -- a 10TB file ...

This seems a flawed way to look at this to me - in practice, almost
noone would have files that large.  While filesystem sizes increase
and can be expected to continue to increase, I'd expect individual
file sizes do not tend to increase anywhere near as much - file sizes
tend to be an application property, and apps want to work for all
filesystems.  So, people want to store _more_ files in their larger
filesystems, not _larger_ files, AFAICT.

So, IMO, this isn't a good place to invest effort - there are alot
of bigger bang-for-buck places that XFS could do with change to make
it generally much better.  The biggest probably being the amount of
log traffic that XFS generates ... that really needs to be tackled.

cheers.

--
Nathan
