Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 16:05:18 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6JN5Dbm022799
	for <linux-xfs@oss.sgi.com>; Thu, 19 Jul 2007 16:05:15 -0700
Subject: Re: tuning XFS for tiny files
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <469E7D70.9030606@sandeen.net>
References: <m23azlbpl1.fsf@tstotts.net>  <469E7D70.9030606@sandeen.net>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 09:05:08 +1000
Message-Id: <1184886308.16678.44.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, timotheus <timotheus@tstotts.net>
Cc: linux-xfs@oss.sgi.com

On Wed, 2007-07-18 at 15:52 -0500, Eric Sandeen wrote:
> 
> > Hi. Is there a way to tune XFS filesystem parameters to better
> address
> > the usage pattern of 10000s of tiny files in directories such as:
> >     maildir directory
> >     mh mail directory
> >     ccache directory
> > 
> > My understanding is that XFS will always be much slower than
> reiserfs
> > with respect to deleting 10000s files; but that XFS might be
> possible to
> > tune toward more rapid read access of 10000s of tiny files.
> > 
> > Regards,
> > -timotheus
> 
> Do you have a way to benchmark your load?
> 
> logv2 at mkfs time, and throwing in larger logbufs & logbsize as mount
> options might help.

For these kinds of workloads, you may have some joy using a mkfs run
with smaller blocksize (down to 512 bytes) and also larger directory
blocksize (up to 64k).  (e.g. mkfs.xfs -bsize=512 -nsize=16k ...)

cheers.

--
Nathan
