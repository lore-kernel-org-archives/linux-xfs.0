Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Sep 2006 10:24:05 -0700 (PDT)
Received: from smtp102.sbc.mail.mud.yahoo.com (smtp102.sbc.mail.mud.yahoo.com [68.142.198.201])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k86HNiDW013417
	for <xfs@oss.sgi.com>; Wed, 6 Sep 2006 10:23:51 -0700
Date: Wed, 6 Sep 2006 10:23:06 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Bad block on partition, how to deal with it?
Message-ID: <20060906172306.GA19108@tuatara.stupidest.org>
References: <60fdb1ad0609060459k6132f8b8s40e4f20f51a746ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60fdb1ad0609060459k6132f8b8s40e4f20f51a746ed@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vijay Gill <vijay.s.gill@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 06, 2006 at 12:59:24PM +0100, Vijay Gill wrote:

> Got this bad sector in a seagate 40G hard disk.

recorder where it is, dd over it and hopefully the drive will remap it
(if there are many sectors the drive is probably toast)

if you know which block is/was bad you can user xfs_bmap to figure out
which file it was in

> Also I have run badblocks to get the number of the block which is
> bad, but how do I get it marked now so that the OS does not try to
> allocate it for data in future.

modern drivers (pretty much anything less than 10 years old) will
remap bad sectors on writes, if they fail to do this get a new drive

smartctl will usually let you get a count of how many times the drive
has done this since
