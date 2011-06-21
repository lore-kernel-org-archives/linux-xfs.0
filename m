Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5LIOGmW020415 for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 13:24:17 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C271E216AB
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 11:24:15 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id wwN5pPESAjSvJY6F for
	<xfs@oss.sgi.com>; Tue, 21 Jun 2011 11:24:15 -0700 (PDT)
Date: Tue, 21 Jun 2011 20:24:14 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110621182414.GA1723@x4.trippels.de>
References: <20110618141950.GA1685@x4.trippels.de>
	<20110619222447.GI561@dastard>
	<20110620005415.GA1730@x4.trippels.de>
	<20110620013449.GO561@dastard>
	<20110620020236.GB1730@x4.trippels.de>
	<20110620023625.GP561@dastard>
	<20110620060351.GC1730@x4.trippels.de>
	<20110620111359.GA12632@x4.trippels.de>
	<20110621042513.GN32466@dastard>
	<20110621080219.GA1684@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110621080219.GA1684@x4.trippels.de>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 2011.06.21 at 10:02 +0200, Markus Trippelsdorf wrote:
> On 2011.06.21 at 14:25 +1000, Dave Chinner wrote:
> > That is, you really need to get a profile of the rm -rf process - or
> > whatever is consuming the CPU time - (e.g. via perf or ftrace)
> > across the hang to so we can narrow down the potential cause of the
> > latency. Speaking of which, latencytop might be helpful in
> > identifying where input is getting held up....
> 
> I've recorded a profile with "perf record -g /home/markus/rm_sync"
> ~ % cat rm_sync
> rm -fr /mnt/tmp/tmp/linux && sync

FWIW here are two links to svg time-charts produced by:

perf timechart record /home/markus/rm_sync

http://trippelsdorf.de/timechart1.svg
http://trippelsdorf.de/timechart2.svg

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
