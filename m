Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Sep 2006 18:02:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8B11XDW030407
	for <xfs@oss.sgi.com>; Sun, 10 Sep 2006 18:01:44 -0700
Date: Mon, 11 Sep 2006 11:00:35 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Critical xfs bug in 2.6.17.11?
Message-ID: <20060911010035.GL10950339@melbourne.sgi.com>
References: <4504151F.6050704@rapidforum.com> <Pine.LNX.4.64.0609101731150.29937@p34.internal.lan> <45048E1E.6040002@rapidforum.com> <Pine.LNX.4.64.0609101835390.29937@p34.internal.lan> <4504A12C.9090608@rapidforum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4504A12C.9090608@rapidforum.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Schmid <webmaster@rapidforum.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

On Mon, Sep 11, 2006 at 01:35:08AM +0200, Christian Schmid wrote:
> Memory-test with ECC disabled ran through 12 hours without any errors. ECC 
> is on now of course, so the possibility of a simple hardware problem is 
> eliminated from my side.

A _memory error_ can be ruled out, but what about a bad disk, bad
disk controller, bad PCI bus interface, a bad driver, etc. Memory is
just one piece of hardware that can result in bad data being read
from or written to disk. Is there any indication of disk or driver
errors in your syslog?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
