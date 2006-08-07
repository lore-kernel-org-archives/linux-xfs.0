Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 08:04:23 -0700 (PDT)
Received: from brmea-mail-4.sun.com (brmea-mail-4.Sun.COM [192.18.98.36])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k77F3uDW014588
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 08:03:57 -0700
Received: from centralmail4brm.central.Sun.COM ([129.147.62.198])
	by brmea-mail-4.sun.com (8.13.6+Sun/8.12.9) with ESMTP id k77F3POc001724
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 09:03:25 -0600 (MDT)
Received: from kickball-mn.Central.Sun.COM (kickball-mn.Central.Sun.COM [10.1.170.217])
	by centralmail4brm.central.Sun.COM (8.13.6+Sun/8.13.6/ENSMAIL,v2.2) with ESMTP id k77F3PQu008428
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 09:03:25 -0600 (MDT)
Date: Mon, 7 Aug 2006 10:03:24 -0500
From: Dean Roehrich <dean.roehrich@sun.com>
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
Message-ID: <20060807150324.GA8421@kickball-mn.Central.Sun.COM>
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM> <44D379A6.9040200@sgi.com> <44D38D34.1010503@thebarn.com> <44D3C351.7060109@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44D3C351.7060109@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bill Kendall <wkendall@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

On Fri, Aug 04, 2006 at 04:59:45PM -0500, Bill Kendall wrote:

> -#define DMF_EV_BITS	( (1<<DM_EVENT_DESTROY) | \
> -			  (1<<DM_EVENT_READ)    | \
> -			  (1<<DM_EVENT_WRITE)   | \
> -			  (1<<DM_EVENT_TRUNCATE) )
> +#define DMF_EV_BITS	( (1<<16) | (1<<17) | (1<<18) | (1<<20) )

Don't do that.

Granted, those bits can never be changed else all of your customers will start
a lynch mob and come after you.

At the very least, don't allow those bits to be anonymous--copy that whole
enum from the dmapi header.  Even that I object to, but at least the bits will
_be_ something.

Dean
