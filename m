Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Nov 2006 04:02:52 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAAC2haG027197
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 04:02:44 -0800
Received: from emailer.gwdg.de (emailer.gwdg.de [134.76.10.24])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E53DE5159E7
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 04:01:56 -0800 (PST)
Date: Fri, 10 Nov 2006 12:59:59 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: XFS filesystem performance drop in kernels 2.6.16+
In-Reply-To: <4553F3C6.2030807@sandeen.net>
Message-ID: <Pine.LNX.4.61.0611101259490.6068@yvahk01.tjqt.qr>
References: <bde600590611090930g3ab97aq3c76d7bca4ec267f@mail.gmail.com>
 <4553F3C6.2030807@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Igor A. Valcov" <viaprog@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

>> I also noticed that I/O barriers were introduced in v2.6.16 and
>> thought they may be the cause, but mounting the file system with
>> 'nobarrier' doesn't seem to affect the performance in any way.
>
>
> did this happen to be a remount with nobarrier, or a fresh mount?

For the barrier stuff, see
http://lkml.org/lkml/2006/5/19/33


	-`J'
-- 
