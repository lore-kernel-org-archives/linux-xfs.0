Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9CDpZds100312 for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 08:51:36 -0500
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79268DDF66
	for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 06:52:42 -0700 (PDT)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109])
	by cuda.sgi.com with ESMTP id 2FsaxVtVNG4sbvZj for
	<xfs@oss.sgi.com>; Tue, 12 Oct 2010 06:52:42 -0700 (PDT)
Message-ID: <4CB46828.2030104@mail.upjs.sk>
Date: Tue, 12 Oct 2010 15:52:40 +0200
From: Jan Derfinak <ja@mail.upjs.sk>
MIME-Version: 1.0
Subject: Re: ENOSPC at 90% with plenty of inodes
References: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>	<20101008225146.GJ4681@dastard>	<AANLkTikLyEuSoFRVwirKLws97Vemz4ScNHOqu2Jc5sWR@mail.gmail.com>	<20101011223507.GB32255@dastard>
	<4CB3B964.40109@hardwarefreak.com> <20101012102954.GQ4681@dastard>
In-Reply-To: <20101012102954.GQ4681@dastard>
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
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

Dave Chinner wrote:

>> If so, could/should the OP specify anything
>> during the mkfs.xfs reformat that may help alleviate or mitigate his
>> problem in the future?
> 
> No. These problems usually appear in filesystems that have run at
> greater than 85-90% full for extended periods of time without being
> emptied at all. Once you start to free up space, it naturally
> defragments itself, but if you never free up any significant amount
> of space in the filesytesm, this cannot occur and so fragmentation
> just keeps getting worse....

I'm curious if using noikeep mount option has any effect on free space
fragmentation?

jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
