Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC8F97F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 13:41:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BCF7A304048
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 11:41:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fg157WLRfxr8qhM3 for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 11:41:52 -0700 (PDT)
Message-ID: <540DF86D.8080705@sandeen.net>
Date: Mon, 08 Sep 2014 13:41:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: converting from external log to internal log ... is this possible?
References: <540DF0FD.205@gmail.com>
In-Reply-To: <540DF0FD.205@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Joe Landman <joe.landman@gmail.com>, xfs@oss.sgi.com

On 9/8/14 1:10 PM, Joe Landman wrote:
> Figured I'd ask, looked on the FAQ and didn't see anything there
> relevant to this.  There is a hint of this in xfs_growfs,
> specifically the -i option, though it is noted that "[NOTE: This
> option is not implemented]".

Yep, it's never been implemented.  You could do it manually with
some very careful xfs_db surgery, if you had enough contiguous
freespace available, but it's not at all supported.

Basically, no, you can't do it without getting very far under
the hood and directly editing the disk.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
