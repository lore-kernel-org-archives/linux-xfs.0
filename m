Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Dec 2006 06:54:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBBEsLqw010849
	for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 06:54:34 -0800
Message-ID: <457D70E4.8090301@sandeen.net>
Date: Mon, 11 Dec 2006 08:53:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Unable to mount XFS partition on Sun Ultra/Linux 2.6.17 - Function
 not implemented
References: <BAY116-W64E893DB16B1A8692B9FDC9D30@phx.gbl> <457997E6.60900@sandeen.net> <20061210090454.GB6192@tuatara.stupidest.org>
In-Reply-To: <20061210090454.GB6192@tuatara.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Dennis Varouxis <dennisvarouxis@hotmail.com>, xfs@oss.sgi.com

Chris Wedgwood wrote:
> On Fri, Dec 08, 2006 at 10:50:46AM -0600, Eric Sandeen wrote:
> 
>> Looks like version one directories, recently ripped out of Linux...
> 
> there should be a prinkt to this effect for these cases
> 
There was some mount error message logic that was backwards, that might 
be why there was none.

see:

TAKE 958469 - Quiet mounts on XFS aren't

The XFS quiet mount logic was inverted making quiet
mounts noisy and vice versa. Fix it.



Haven't looked too closely but that may well be the problem.

-Eric
