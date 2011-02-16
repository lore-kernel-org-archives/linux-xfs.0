Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1GIv924066079 for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 12:57:10 -0600
Received: from homer.spinpro.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D48482DD132
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 10:54:48 -0800 (PST)
Received: from homer.spinpro.com (mail.spinpro.com [206.223.182.178]) by
	cuda.sgi.com with ESMTP id TKmSPJIqBZID9dw5 for
	<xfs@oss.sgi.com>; Wed, 16 Feb 2011 10:54:48 -0800 (PST)
Received: from [127.0.0.1] (unknown [192.168.10.254])
	by homer.spinpro.com (Postfix) with ESMTP id 943D733D006
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 13:54:47 -0500 (EST)
Message-ID: <4D5C1D77.1060000@spinpro.com>
Date: Wed, 16 Feb 2011 13:54:47 -0500
From: Andrew Klaassen <ak@spinpro.com>
MIME-Version: 1.0
Subject: External log size limitations
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

I found some this document:

http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?coll=linux&db=bks&fname=/SGI_Admin/LX_XFS_AG/ch02.html

...which says that an XFS external log is limited to 128MB.

Is there any way to make that larger?

Goal:  I'd love to try putting the external log on an SSD that could 
sustain two or three minutes of steady full-throttle writing.  128MB 
gives me less than a second worth of writes before my write speed slows 
down to the underlying storage speed.

I'll do lots of benchmarks before rolling it out to make sure it 
actually does help, of course.  I just want to know if it's possible, 
and how to do it if it is.

Thanks.

Andrew



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
