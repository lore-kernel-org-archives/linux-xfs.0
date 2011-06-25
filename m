Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5PIXQb7132209
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 13:33:31 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7895815E767E
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 11:33:24 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id MGIt8N5ggidnCeMd for <linux-xfs@oss.sgi.com>;
	Sat, 25 Jun 2011 11:33:24 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1QaXfY-0001A1-0j
	for linux-xfs@oss.sgi.com; Sat, 25 Jun 2011 20:33:24 +0200
Received: from s0106000acd1d509c.du.shawcable.net ([70.67.174.161])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 20:33:24 +0200
Received: from prad by s0106000acd1d509c.du.shawcable.net with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 20:33:24 +0200
From: prad <prad@towardsfreedom.com>
Subject: Re: xfsrestore seems to hang
Date: Sat, 25 Jun 2011 11:29:26 -0700
Message-ID: <87iprtn4s9.fsf@psinom.home>
References: <87oc1ln8xx.fsf@psinom.home>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

prad <prad@towardsfreedom.com> writes:

> but it just hangs on the last line and we wait and wait and wait.
>
could it be that we're supposed to?

i just extracted a 21K file from a 3G dump and it took 168s.
the home.xfs file is 129G more than 40times the size of the small one,
so if things are simply proportional we're looking at 

168s x 40 = 112m or well over an hour and a half!

i acknowledge that i stopped the thing after a little more than half an
hour.

so is it possible that the xfsrestore system has to go through the
motion of handling the entire file even when it's just extracting a
small part of it and things will take their time?

-- 
in friendship,
prad

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
