Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D26F77F4C
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 02:12:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B08AA8F8037
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 00:12:10 -0800 (PST)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id S5K7abUN1cRuXcvJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 00:12:06 -0800 (PST)
Message-ID: <5121E253.8000400@profihost.ag>
Date: Mon, 18 Feb 2013 09:12:03 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: 32bit apps and inode64
References: <4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
	<4FA82B07.1020102@profihost.ag>
	<4FAA153D.1030606@hardwarefreak.com>
	<20120509070450.GP5091@dastard> <511E4F00.2010703@profihost.ag>
	<20130215214653.GP22182@sgi.com>
	<F4526E0F-2DDC-4FB4-927D-BFD8AD489D55@profihost.ag>
	<20130217213359.GA26694@dastard>
In-Reply-To: <20130217213359.GA26694@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

Am 17.02.2013 22:33, schrieb Dave Chinner:

>>> xfs_reno was ported to linux in '07 and was most recently reposted by Jeff Liu:
>>> http://oss.sgi.com/archives/xfs/2012-11/msg00425.html
>>>
>>> It isn't in xfsprogs today.
> 
> Simple answer: mount with inode32, run find to print out all the
> filenames in the filesystem and their inode number, copy the files
> with inodes numbers greater than 32 bit to a temporary file and then
> rename them over the top of the original.

Thanks, what about directories? Is renaming / moving using mv enough?

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
