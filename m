Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6V3b8i7122352 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 22:37:09 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42EE5AD4724
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 20:46:54 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Ob393GrPvzdSCDjr for
	<xfs@oss.sgi.com>; Thu, 30 Jul 2009 20:46:54 -0700 (PDT)
Message-ID: <4A726711.5050402@sandeen.net>
Date: Thu, 30 Jul 2009 22:37:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs i/O error
References: <24747808.post@talk.nabble.com> <200907310148.52085@zmi.at>
In-Reply-To: <200907310148.52085@zmi.at>
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
Cc: rnb <neil.bell@gmail.com>, xfs@oss.sgi.com

Michael Monnerie wrote:
> On Donnerstag 30 Juli 2009 rnb wrote:
>> [70273.864305] sd 8:0:0:0: [sdg] Sense Key : Medium Error [current]
>> [70273.864314] Info fld=0x0
>> [70273.864318] sd 8:0:0:0: [sdg] Add. Sense: Unrecovered read error
>> [70273.864327] end_request: I/O error, dev sdg, sector 378206415
> 
> Disk is bad, replace it.
> 
> mfg zmi

More or less, yep.

Read errors can be somewhat recoverable, if you write to that sector it
will remap if it can.

But anyway yeah, it's not an xfs I/O error, it's a disk IO error, and
xfs is bringing you the bad news.

repair may not have seen it because repair only looks at metadata, bad
sectors may be data in blocks, found when you try to copy data around.

-eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
