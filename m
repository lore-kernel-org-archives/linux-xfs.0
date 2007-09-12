Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Sep 2007 18:39:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8C1dq4p031472
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 18:39:53 -0700
Message-ID: <46E74368.5090503@sandeen.net>
Date: Tue, 11 Sep 2007 20:39:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: compression
References: <654e62180709111643k4700c2bdibec2a16eb5446e76@mail.gmail.com>
In-Reply-To: <654e62180709111643k4700c2bdibec2a16eb5446e76@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jordan Mendler <jmendler@ucla.edu>
Cc: xfs@oss.sgi.com

Jordan Mendler wrote:
> Hi all,
> 
> I searched the mailing list archive and could not find an answer. We are
> currently using XFS on Linux for a 17TB Volume used for backups. We are
> running out of space, so rather than order another array, I would like to
> try to implement filesystem-level compression. Does XFS support any type of
> compression? If not, are there any other ways to optimize for more space
> storage? We are doing extensive rsyncs as our method of backups, so gzipping
> on top of the filesystem is not really an option.
> 
> Thanks so much,
> Jordan
> 

No native compression in xfs... and it's not got a lot of space
overhead, to start with.

If you're keeping multiple copies of things via complete nightly rsync
backups, there are mechanisms that just symlink files which haven't
changed... Or, have you looked into incremental backups via xfsdump?
Dunno if any of that helps, or if you've already thought of such things.  :)

-Eric
