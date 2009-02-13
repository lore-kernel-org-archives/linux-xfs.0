Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1DEEBdn184570 for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 08:14:11 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 546A2192D08F
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 06:13:35 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id ebXSR8NhXYaGLABB for <xfs@oss.sgi.com>;
	Fri, 13 Feb 2009 06:13:35 -0800 (PST)
Message-ID: <49957FBB.40900@sandeen.net>
Date: Fri, 13 Feb 2009 08:12:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr not defragmenting: 'could not open tmp file'
References: <283651.13069.qm@web51408.mail.re2.yahoo.com>
	<200902131014.59183@zmi.at>
In-Reply-To: <200902131014.59183@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> On Freitag 13 Februar 2009 Richard Troxell wrote:
>> xfs_fsr is coming from xfsprogs 3.0.0
>> Linux kernel is 2.6.23.9
>> Architecture is x86_64, but xfs_fsr is 32bit.
> 
> I'm not a dev, but I'd suggest trying the newest 2.6.28 kernel and see 
> if the problem persists. There have been many fixes since your kernel.
> 
> mfg zmi

Actually, yes.  there were 32/64 issues until recently, and fsr was in
fact using an ioctl that did not have a 32-bit handler.  These weren't
fixed until 2.6.29-rc1.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
