Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 89A557F51
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 13:43:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 73BDD8F8049
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 11:43:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fkr1qYHs0ltU1y1v for
	<xfs@oss.sgi.com>; Thu, 31 Jan 2013 11:43:02 -0800 (PST)
Message-ID: <510AC9FF.4010007@redhat.com>
Date: Thu, 31 Jan 2013 14:46:07 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: 50% more blocks allocated than needed
References: <CA+kHd+eRifnCVkri6TPKS9UcUpBSW9nPnCEz0a412vO_Aw8=Xw@mail.gmail.com>
	<510AB2D5.2080600@redhat.com>
	<CAAxjCExedk+fWLpD1ypak9HK7b2domtc3aJuBRyEWsvXXsiSWA@mail.gmail.com>
In-Reply-To: <CAAxjCExedk+fWLpD1ypak9HK7b2domtc3aJuBRyEWsvXXsiSWA@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On 01/31/2013 01:28 PM, Stefan Ring wrote:
>> I don't think so at the moment
> 
> Really? Even for closed files? I was almost sure that the space would
> be reclaimed before running out of it. I have only slightly less than
> 1 year of XFS experience though...
> 

Note that in most cases preallocation is trimmed on file close. The
repeated open-write-close cycle is what causes it to hang around longer
(until inode reclaim).

Somebody else can chime in if I'm missing something, but my
understanding is that we currently run a flush to free up reserved
metadata blocks on ENOSPC and retry. The eofblocks functionality
provides a mechanism that the out of space conditions can use to free up
preallocation, but that part is a work-in-progress.

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
