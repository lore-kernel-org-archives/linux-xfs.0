Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F02FD29DF7
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 08:23:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D0B198F804B
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 06:23:56 -0700 (PDT)
Received: from order.stressinduktion.org (order.stressinduktion.org
	[87.106.68.36]) by cuda.sgi.com with ESMTP id ckbu22IL6C5TM1rh
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 27 Mar 2014 06:23:55 -0700 (PDT)
Date: Thu, 27 Mar 2014 14:23:54 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: xfs errors while unlinking filenames with hash collisions
Message-ID: <20140327132354.GU29498@order.stressinduktion.org>
References: <20140327074156.GJ29498@order.stressinduktion.org>
	<5334241E.9060708@sgi.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5334241E.9060708@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 27, 2014 at 08:14:06AM -0500, Mark Tinguely wrote:
> Have you tried to run a xfs_repair on the filesystem after the reboot?

Yes, I did. I still use the filesystem and it works. As soon as I try to
remove the directory again the same splash from above happens again.

> Do you fill the filesystem with the test or just part way?

Just part way. The problem certainly appears with 100_000 created directories.

Greetings,

  Hannes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
