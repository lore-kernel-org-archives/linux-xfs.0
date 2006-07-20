Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 12:04:45 -0700 (PDT)
Received: from smtp113.sbc.mail.mud.yahoo.com (smtp113.sbc.mail.mud.yahoo.com [68.142.198.212])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6KJ4UDW009367
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 12:04:34 -0700
Date: Thu, 20 Jul 2006 12:04:01 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: stable xfs
Message-ID: <20060720190401.GA28836@tuatara.stupidest.org>
References: <17595.47312.720883.451573@base.ty.sabi.co.UK> <1153262166.2669.267.camel@localhost.localdomain> <17597.27469.834961.186850@base.ty.sabi.co.UK> <1153272044.2669.282.camel@localhost.localdomain> <17598.2129.999932.67127@base.ty.sabi.co.UK> <1153314670.2691.14.camel@localhost.localdomain> <20060720061527.GB18135@tuatara.stupidest.org> <1153404502.2768.50.camel@localhost.localdomain> <20060720161707.GB26748@tuatara.stupidest.org> <1153413481.2768.65.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1153413481.2768.65.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Thu, Jul 20, 2006 at 12:38:01PM -0400, Ming Zhang wrote:

> i could not control my application. so i still need to do defrag
> some time.

one thing that irks me about fsr is that unless it's given path
elements it that the files created to replace the fragmented file are
usually not allocated close the original file (they are openned by
handle after a bulkstat pass) so you tend to scatter your files about
if you're not careful

also, fsr implies doing a lot more work on the whole, writing, reading
and rewriting the files in most cases and because it uses dio it will
invalidate the page-cache of any files that might be being read-from
when it's running

> yes. i should find out. hope to force a repair?

umount cleanly and run xfs_repair, check to see how much memory it
uses with ps/top/whatever as it's running

> unplug my power cord? ;)

raid protects against failed disks, it usually doesn't protect well
against corruption from lost/bad writes as a result of dropping power
so well, if you have backups, sure, go for it
