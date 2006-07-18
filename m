Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 10:02:10 -0700 (PDT)
Received: from smtp108.sbc.mail.mud.yahoo.com (smtp108.sbc.mail.mud.yahoo.com [68.142.198.207])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6IH1tDW001362
	for <xfs@oss.sgi.com>; Tue, 18 Jul 2006 10:01:59 -0700
Date: Tue, 18 Jul 2006 10:01:29 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: restore previous FAT ?
Message-ID: <20060718170129.GB24508@tuatara.stupidest.org>
References: <44BCB1F8.1030705@amakuru.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44BCB1F8.1030705@amakuru.net>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Morel <dmorel@amakuru.net>
Cc: xfs@oss.sgi.com

On Tue, Jul 18, 2006 at 12:03:36PM +0200, David Morel wrote:

> a client of mine (I SWEAR it is not me) accidentally formated one of
> their HDs, and they shouldn't have :) Kind of a mixup, and they end
> up having no data. Is there some miraculous way of restoring the
> previous FAT ?

probably not easily, the critical data for FAT filesystems were likely
clobbered by SB0 and the metadata associated with that AG (like thr
root inode, directory, etc).
