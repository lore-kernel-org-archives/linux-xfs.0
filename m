Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 16:13:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3ONDNcd001597
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 16:13:27 -0700
Received: from QMTA06.emeryville.ca.mail.comcast.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4B27E874A
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 16:14:05 -0700 (PDT)
Received: from QMTA06.emeryville.ca.mail.comcast.net (qmta06.emeryville.ca.mail.comcast.net [76.96.30.56]) by cuda.sgi.com with ESMTP id 1CPYGkcXKVywuMRx for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 16:14:05 -0700 (PDT)
Date: Thu, 24 Apr 2008 16:13:37 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: xfs_quota report
Message-ID: <20080424231337.GA4479@puku.stupidest.org>
References: <200804250049.34740.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804250049.34740.arekm@maven.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Fri, Apr 25, 2008 at 12:49:34AM +0200, Arkadiusz Miskiewicz wrote:

> I wonder if there is a better way to get information about uid/gids
> that have any files on xfs filesystem? So report command could be
> enhanced to display such "users", too.

bulkstat would be one way to get a list of all uid/gids in use, it
could be very large though

(i know of installations where uid/gid values are used outside of
/etc/passwd and NIS/ldap that number in the millions, though, well,
that's not such a large number these days)
