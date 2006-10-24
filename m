Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 10:13:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OHDJaG002538
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 10:13:20 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D392CD1A65BD
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 10:12:34 -0700 (PDT)
Message-ID: <453E494F.8080808@sandeen.net>
Date: Tue, 24 Oct 2006 12:11:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel panic after upgrading to 2.6
References: <Pine.LNX.4.58.0610240938400.8370@lewis.et.byu.edu>
In-Reply-To: <Pine.LNX.4.58.0610240938400.8370@lewis.et.byu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Dougall <davidd@et.byu.edu>
Cc: nfs@lists.sourceforge.net, xfs@oss.sgi.com

David Dougall wrote:
> I am running kernel 2.6.18 after trying 2.6.17.6 and 2.6.17.13 with
> similar results.  I continue to have nfs servers kernel panic on a very
> regular basis, every few days.  Sometimes I need to do an xfs_repair to
> get the filesystem to remount.  I got the following kernel panic message
> from the syslog this time:
> Message from syslogd@nfs09 at Tue Oct 24 09:35:14 2006 ...
> nfs09 kernel: Oops: 0000 [#1]

If you ran 2.6.17 < 2.6.17.7, there was a bug:

http://oss.sgi.com/projects/xfs/faq.html#dir2

I would suggest getting xfsprogs v. 2.8.10 or newer, as referenced in
the faq, repair your filesystem, and see if the problem is resolved.

-Eric
