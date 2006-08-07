Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 12:26:04 -0700 (PDT)
Received: from brmea-mail-4.sun.com (brmea-mail-4.Sun.COM [192.18.98.36])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k77JPcDW006220
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 12:25:38 -0700
Received: from centralmail3brm.Central.Sun.COM ([129.147.62.199])
	by brmea-mail-4.sun.com (8.13.6+Sun/8.12.9) with ESMTP id k77JPB6S021128
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 13:25:11 -0600 (MDT)
Received: from kickball-mn.Central.Sun.COM (kickball-mn.Central.Sun.COM [10.1.170.217])
	by centralmail3brm.Central.Sun.COM (8.13.6+Sun/8.13.6/ENSMAIL,v2.2) with ESMTP id k77JLV8v020623
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 13:21:31 -0600 (MDT)
Date: Mon, 7 Aug 2006 14:25:10 -0500
From: Dean Roehrich <dean.roehrich@sun.com>
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
Message-ID: <20060807192510.GA17251@kickball-mn.Central.Sun.COM>
References: <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM> <44D379A6.9040200@sgi.com> <44D38D34.1010503@thebarn.com> <44D3C351.7060109@sgi.com> <20060807150324.GA8421@kickball-mn.Central.Sun.COM> <44D75C87.8050402@thebarn.com> <20060807155248.GA22411@tuatara.stupidest.org> <20060807165159.GA10521@kickball-mn.Central.Sun.COM> <44D790E2.8030000@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44D790E2.8030000@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bill Kendall <wkendall@sgi.com>
Cc: Chris Wedgwood <cw@f00f.org>, Russell Cattelan <cattelan@thebarn.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

On Mon, Aug 07, 2006 at 02:13:38PM -0500, Bill Kendall wrote:

> I'll put these defines in hsmapi.c, and revert DMF_EV_BITS back to using
> these symbols:

I guess I'd favor copying in the whole enum.  But I'm a bit more concerned
about losing parts of a story than other people.

Dean
