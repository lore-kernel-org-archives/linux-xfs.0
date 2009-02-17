Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1HFvboO232872 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 09:57:38 -0600
Received: from smtp.welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C80A12A043
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 07:57:03 -0800 (PST)
Received: from smtp.welcomes-you.com (welcomes-you.com [85.214.50.128]) by
	cuda.sgi.com with ESMTP id yycdb6wyCeCmWTEa for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2009 07:57:03 -0800 (PST)
Message-ID: <499ADE17.10302@aei.mpg.de>
Date: Tue, 17 Feb 2009 16:56:07 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: xfs problems (possibly after upgrading from linux kernel 2.6.27.10
	to .14)
References: <017cbf6388451888f2156b2fb77115e8@webmail.zmi.at>
In-Reply-To: <017cbf6388451888f2156b2fb77115e8@webmail.zmi.at>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Michael,

Michael Monnerie schrieb:
> "Carsten Aulbert" <carsten.aulbert@aei.mpg.de> schrieb:
>> Feb 16 20:34:49 n0035 kernel: [275873.343508] Filesystem "sda6":
> Corruption of
>> in-memory data detected.  Shutting down filesystem: sda6
> 
> Are you absolutely sure your RAM doesn't have problems? Run memtest86.
> At least I would from that error description.

Pretty sure, all boxes have ECC memory and mcelog has not reported
anything on the nodes in question right now - we usually have only a few
spurious MCE errors a week. We have encountered 17 of these incidences
within the past week and basically nothing before - I don't think that
memory in 17 nodes goes bad just by upgrading the kernel or out of
coincidence.

I'll pick 4-5 nodes for memtests just to be sure.

Cheers

Carsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
