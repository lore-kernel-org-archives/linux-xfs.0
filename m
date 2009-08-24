Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7OGv6gU136888 for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 11:57:16 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6DC01520E31
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 09:57:29 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id L5O8CX6DTDL9Gpv4 for
	<xfs@oss.sgi.com>; Mon, 24 Aug 2009 09:57:29 -0700 (PDT)
Message-ID: <4A92C43B.1060604@tlinx.org>
Date: Mon, 24 Aug 2009 09:47:55 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Changing a file system from case sensitive to case	insensitive...
References: <4A928413.4050205@tlinx.org> <20090824144904.GB20898@infradead.org>
In-Reply-To: <20090824144904.GB20898@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>



Christoph Hellwig wrote: 
> It's not theoretically impossible, but not implemented right now.
----
	How difficult -- would it just be changing a flag
in the super, in the simple case -- i.e. with the result that
a user could lose access to any files of alternate cases?

	I know it's not what's there now, but there is a nice search
option in 'Gvim', 'smartcase', where if you use a lower case
search string, it finds strings of either case, but if you explicitly
have any letter capitalized, then it forces a case sensitive search.

	That could be a recovery mechanism for conflicts, but would
likely involve more work...

-l

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
