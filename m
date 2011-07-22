Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MI5IcR097918 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 13:05:18 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFA668EA7D
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 11:05:17 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Drk1FScxuuoi1315
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 11:05:17 -0700 (PDT)
Message-ID: <4E29BBDA.3000603@hardwarefreak.com>
Date: Fri, 22 Jul 2011 13:05:14 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 30 TB RAID6 + XFS slow write performance
References: <4E24907F.6020903@johnbokma.com> <201107210820.01019@zmi.at>
	<20110721064838.GA13963@dastard> <201107220810.01889@zmi.at>
In-Reply-To: <201107220810.01889@zmi.at>
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
Cc: John Bokma <contact@johnbokma.com>, xfs@oss.sgi.com

On 7/22/2011 1:10 AM, Michael Monnerie wrote:

> Yes, I just wanted to know about the corner cases, and how XFS behaves. 
> Actually, we're changing over to using NetApps, and with their WAFL 
> anyway I should drop all su/sw usage and just use 4KB blocks.

I've never used a NetApp filer myself.  However, that said, I would
assume that WAFL is only in play for NFS/CIFS transactions since WAFL is
itself a filesystem.

When exposing LUNs from the same filer to FC and iSCSI hosts I would
assume the filer acts just as any other SAN controller would.  In this
case I would think you'd probably still want to align your XFS
filesystem to the underlying RAID stripe from which the LUN was carved.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
