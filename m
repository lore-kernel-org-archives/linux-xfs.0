Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Feb 2007 12:08:38 -0800 (PST)
Received: from smtp106.sbc.mail.mud.yahoo.com (smtp106.sbc.mail.mud.yahoo.com [68.142.198.205])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1NK8Wm7004587
	for <linux-xfs@oss.sgi.com>; Fri, 23 Feb 2007 12:08:33 -0800
Date: Fri, 23 Feb 2007 11:41:50 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: I/O error, SCSI error, reservation conflict.... xfs suggestions?
Message-ID: <20070223194150.GA31001@tuatara.stupidest.org>
References: <9124908.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9124908.post@talk.nabble.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: pgf111000 <junkmail@petergfrazier.com>
Cc: linux-xfs@oss.sgi.com

On Fri, Feb 23, 2007 at 11:13:03AM -0800, pgf111000 wrote:

> sd 3:0:1:0: reservation conflict

some other host has reserve (part) of your storage system, best you go
whack them or something

> sd 3:0:1:0: SCSI error: return code = 0x00070018
> end_request: I/O error, dev sdx, sector 681896097

low-level errors, not XFS
