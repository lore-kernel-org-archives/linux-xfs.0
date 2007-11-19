Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Nov 2007 15:44:15 -0800 (PST)
Received: from smtp115.sbc.mail.sp1.yahoo.com (smtp115.sbc.mail.sp1.yahoo.com [69.147.64.88])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAJNi9cw027349
	for <xfs@oss.sgi.com>; Mon, 19 Nov 2007 15:44:11 -0800
Date: Mon, 19 Nov 2007 15:44:15 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: XFS crash on linux raid
Message-ID: <20071119234415.GB29042@puku.stupidest.org>
References: <20070503164521.16efe075@harpe.intellique.com> <20070504005922.GC32602149@melbourne.sgi.com> <20070504090613.7c0f97d3@galadriel.home> <20070504073344.GL32602149@melbourne.sgi.com> <20070504152546.614374ac@harpe.intellique.com> <463B4962.70904@sandeen.net> <20070504173049.14606033@harpe.intellique.com> <20070504232028.GA19744@tuatara.stupidest.org> <4741D198.2060908@strike.wu-wien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4741D198.2060908@strike.wu-wien.ac.at>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Bergolth <leo@strike.wu-wien.ac.at>
Cc: Emmanuel Florac <eflorac@intellique.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Nov 19, 2007 at 07:10:32PM +0100, Alexander Bergolth wrote:

> Several months ago, you posted a patch for 8k stacks together with
> irqstacks:

I've posted it off and on for two or three years now --- quite a few
people are using it or the equivalent of it, but thus far people
resist merging this.

The other idea (also nixed) that I posed was to dosable XFS if people
are using 4KSTACKS

> Do you have a working version of your patch for 2.6.23?

No.  I can go digg out a 32-bit machine and retest though.

> I've been using a similar patch (attached) for several years now but
> since 2.6.23, it produces oopses like below. The patch applies
> cleanly but there seems to be some major change between 2.6.22 and
> 2.6.23 that isn't covered correctly.

I'll take a look.  Can you make sure it works with 8K stacks (more or
less works).
