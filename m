Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MNNfwi089217 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 18:23:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 367FC1847CC6
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 16:24:35 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	1ozT9HZ9RA0xY6FB for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 16:24:35 -0700 (PDT)
Date: Thu, 23 Sep 2010 09:24:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error xfs_da_do_buf(2)
Message-ID: <20100922232431.GH2614@dastard>
References: <20100922083226.GF2614@dastard>
	<20100922121123.GB23326@pirx.askja.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100922121123.GB23326@pirx.askja.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: xfs@oss.sgi.com

On Wed, Sep 22, 2010 at 02:11:23PM +0200, Ralf Gross wrote:
> Dave Chinner schrieb:
> > On Wed, Sep 22, 2010 at 09:26:53AM +0200, Ralf Gross wrote:
> > > Any hints what to look for or what to do to notice this corruption as soon as possible?
> > 
> > You won't find an error on disk without scrubbing of some kind.
> > In the case of filesystem metadata, you need to read all the
> > metadata and validity check it to find random corruptions. The best
> > you can do is traverse and stat every file regularly...
> 
> 
> Disk scrubbing is activated on the infortrend RAIDs (2 week schedule).

Ok, so that should catch bit errors as a result of disk write/read
errors, but it would take 2 weeks to find it. That still leaves a
window for undetected disk corruption to be trippd over by the
filesystem...

> With 'stat every file regularly' you mean check the md5sum?

If you just want to read the metadata, then just doing something
like a 'ls -R <mntpt>' will read every directory block and inode and
run the checks that trigger the errors you are seeing. running
md5sum on every file will check the data as well, but will take a
lot longer.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
