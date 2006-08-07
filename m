Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 09:53:12 -0700 (PDT)
Received: from brmea-mail-1.sun.com (brmea-mail-1.Sun.COM [192.18.98.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k77GqRDW009663
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 09:52:50 -0700
Received: from centralmail4brm.central.Sun.COM ([129.147.62.198])
	by brmea-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id k77Gq1Da028806
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 10:52:01 -0600 (MDT)
Received: from kickball-mn.Central.Sun.COM (kickball-mn.Central.Sun.COM [10.1.170.217])
	by centralmail4brm.central.Sun.COM (8.13.6+Sun/8.13.6/ENSMAIL,v2.2) with ESMTP id k77Gq0d6001063
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 10:52:00 -0600 (MDT)
Date: Mon, 7 Aug 2006 11:51:59 -0500
From: Dean Roehrich <dean.roehrich@sun.com>
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
Message-ID: <20060807165159.GA10521@kickball-mn.Central.Sun.COM>
References: <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM> <44D379A6.9040200@sgi.com> <44D38D34.1010503@thebarn.com> <44D3C351.7060109@sgi.com> <20060807150324.GA8421@kickball-mn.Central.Sun.COM> <44D75C87.8050402@thebarn.com> <20060807155248.GA22411@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060807155248.GA22411@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Russell Cattelan <cattelan@thebarn.com>, Bill Kendall <wkendall@sgi.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

On Mon, Aug 07, 2006 at 08:52:48AM -0700, Chris Wedgwood wrote:
> On Mon, Aug 07, 2006 at 10:30:15AM -0500, Russell Cattelan wrote:
> 
> > It seems rather dangerous to have a #define floating around that
> > could potentially get out of sync with the original, especially if
> > you transport the number and not the enum table. (It make it really
> > hard for cscope to find :-)
> 
> If it saves a header I don't see any harm in the original approach
> with a comment preceding it explain what the bits are and why not to
> screw them up.

I agree with Russell that you want cscope to tell you about every place those
bits are being used, so you want those defines or at least those symbols to
show up here.  Having them in a comment won't help cscope.

Dean
