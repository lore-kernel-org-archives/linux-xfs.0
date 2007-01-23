Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 14:59:57 -0800 (PST)
Received: from smtp113.sbc.mail.mud.yahoo.com (smtp113.sbc.mail.mud.yahoo.com [68.142.198.212])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0NMxpqw032460
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 14:59:52 -0800
Date: Tue, 23 Jan 2007 14:58:55 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: how to sync / commit data to disk?
Message-ID: <20070123225855.GA5054@tuatara.stupidest.org>
References: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com> <20070123165050.GA28720@tuatara.stupidest.org> <1169591069.18017.143.camel@edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169591069.18017.143.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: Peter Gervai <grinapo@gmail.com>, xfs@oss.sgi.com

On Wed, Jan 24, 2007 at 09:24:29AM +1100, Nathan Scott wrote:

> FWIW, this hack can be better achieved in a filesystem independent
> way by doing a remount,ro ... remount,rw instead of freeze/thaw.

except it won't work if the are open read-write files (which can be
the case)
