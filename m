Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 10:01:59 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0EI1qBF023049
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 10:01:53 -0800
Received: from smtp124.sbc.mail.sp1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 87933519480
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 10:02:10 -0800 (PST)
Received: from smtp124.sbc.mail.sp1.yahoo.com (smtp124.sbc.mail.sp1.yahoo.com [69.147.64.97]) by cuda.sgi.com with SMTP id 1hIQGV53xgnC0IFF for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 10:02:10 -0800 (PST)
Date: Mon, 14 Jan 2008 09:55:53 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Question related to XFS sync , especially fsync
Message-ID: <20080114175553.GA3711@puku.stupidest.org>
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 14, 2008 at 05:44:22PM +0530, Gopala Krishna wrote:

> Is there any problem with XFS fsync? Why dimode is getting updated
> only during unmount? why not when I call fsync? Because fsync says
> it has to flush all meta dat to disk before existing.

it's probably in the log

if you must poke about under the fs like this, try doing
freeze/unfreeze (this is what i suggested to the grub people years
ago, but i'm not sure it ever made it upstream)
