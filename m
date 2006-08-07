Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 08:53:44 -0700 (PDT)
Received: from smtp101.sbc.mail.mud.yahoo.com (smtp101.sbc.mail.mud.yahoo.com [68.142.198.200])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k77FrJDW029528
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 08:53:19 -0700
Date: Mon, 7 Aug 2006 08:52:48 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
Message-ID: <20060807155248.GA22411@tuatara.stupidest.org>
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM> <44D379A6.9040200@sgi.com> <44D38D34.1010503@thebarn.com> <44D3C351.7060109@sgi.com> <20060807150324.GA8421@kickball-mn.Central.Sun.COM> <44D75C87.8050402@thebarn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44D75C87.8050402@thebarn.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Dean Roehrich <dean.roehrich@sun.com>, Bill Kendall <wkendall@sgi.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

On Mon, Aug 07, 2006 at 10:30:15AM -0500, Russell Cattelan wrote:

> It seems rather dangerous to have a #define floating around that
> could potentially get out of sync with the original, especially if
> you transport the number and not the enum table. (It make it really
> hard for cscope to find :-)

If it saves a header I don't see any harm in the original approach
with a comment preceding it explain what the bits are and why not to
screw them up.
