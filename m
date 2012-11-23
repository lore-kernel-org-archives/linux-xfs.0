Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qANKJQ6D114690
	for <linux-xfs@oss.sgi.com>; Fri, 23 Nov 2012 14:19:27 -0600
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id 2Dkwy6zscvsfccyJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Fri, 23 Nov 2012 12:21:37 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Tbzkw-0008NE-44
	for linux-xfs@oss.sgi.com; Fri, 23 Nov 2012 21:21:46 +0100
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 23 Nov 2012 21:21:46 +0100
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 23 Nov 2012 21:21:46 +0100
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: high load and xfsaild in d
Date: Fri, 23 Nov 2012 12:19:59 -0800
Message-ID: <fc25o9xgfg.ln2@goaway.wombat.san-francisco.ca.us>
References: <sn23o9xkh3.ln2@goaway.wombat.san-francisco.ca.us>
	<20121123025624.GC32450@dastard>
	<uua3o9x9q5.ln2@goaway.wombat.san-francisco.ca.us>
	<20121123053913.GD32450@dastard>
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

On 2012-11-23, Dave Chinner <david@fromorbit.com> wrote:
>
> Do whatever you want - you might be waiting a while for CentOS to
> fix it, though, because they don't fix user reported bugs. They just
> repackage whatever Red Hat releases as RHEL.

Yes, that's why I was asking--I was wondering whether it is safe to wait
for what could be some time for a) RHEL to decide to patch (if they do
so at all), b) RHEL to patch, and c) CentOS to patch.  IOW, is the high
load the only likely symptom of the originail aild patch, or are there
potentially other problems, such as performance degradation that I
haven't seen yet, that would make waiting for CentOS unwise?

>> Do you know why I might not see this behavior on a different CentOS 6.x
>> kernel?
>> 
>> Linux xxxxxx 2.6.32-279.5.2.el6.x86_64 #1 SMP Fri Aug 24 01:07:11 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>
> Because the log hang bug hadn't been fixed in that kernel.

This actually gives me some optimism that RHEL might introduce a new
kernel sooner rather than later--that kernel wasn't all that long ago,
and there have been quite a few (mostly unrelated) patches since.
(That's why I was so surprised--I'm not used to the RHEL kernel moving
so quickly!)

--keith

-- 
kkeller-usenet@wombat.san-francisco.ca.us
(try just my userid to email me)
AOLSFAQ=http://www.therockgarden.ca/aolsfaq.txt
see X- headers for PGP signature information


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
