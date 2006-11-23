Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Nov 2006 22:06:54 -0800 (PST)
Received: from smtp113.sbc.mail.mud.yahoo.com (smtp113.sbc.mail.mud.yahoo.com [68.142.198.212])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAN66iaG023528
	for <xfs@oss.sgi.com>; Wed, 22 Nov 2006 22:06:45 -0800
Date: Wed, 22 Nov 2006 21:39:14 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Unexpected inode type 0160000 causes abort of xfs_repair
Message-ID: <20061123053914.GA22521@tuatara.stupidest.org>
References: <20061122201131.GD2493@groll.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061122201131.GD2493@groll.co.za>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jonathan Groll <lists@groll.co.za>
Cc: xfs@oss.sgi.com

On Wed, Nov 22, 2006 at 10:11:31PM +0200, Jonathan Groll wrote:

> Is there anything I can possibly do?

smash the inode using xfs_db (set mode to 0 should work) and run
repair, it will prune it away for you
