Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 May 2007 16:02:10 -0700 (PDT)
Received: from smtp111.sbc.mail.mud.yahoo.com (smtp111.sbc.mail.mud.yahoo.com [68.142.198.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l43N25fB020477
	for <xfs@oss.sgi.com>; Thu, 3 May 2007 16:02:06 -0700
Date: Thu, 3 May 2007 16:02:02 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: XFS crash on linux raid
Message-ID: <20070503230202.GA12747@tuatara.stupidest.org>
References: <20070503164521.16efe075@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503164521.16efe075@harpe.intellique.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Thu, May 03, 2007 at 04:45:21PM +0200, Emmanuel Florac wrote:

> After xfs_repair, the fs is fine. However, it crashes again when
> writing again a couple of GBs of data. It crashes again under
> 2.6.17.13, 2.6.17.13 SMP, 2.6.18.8, 2.6.16.36...

4K stacks?

> So I tend to believe this is a "write barrier" problem and it looks
> really nasty!!!

You could try "mount -o nobarrier ...."
