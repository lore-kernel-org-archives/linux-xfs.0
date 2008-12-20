Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBK61qNY020780 for <xfs@oss.sgi.com>; Sat, 20 Dec 2008 00:01:52 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18AA239551
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 22:01:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id kUkEonYBurQRniNp for <xfs@oss.sgi.com>;
	Fri, 19 Dec 2008 22:01:50 -0800 (PST)
Message-ID: <494C8A4E.5020904@sandeen.net>
Date: Sat, 20 Dec 2008 00:01:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests tests not in the auto group; do we know why?
References: <49473616.1020307@sandeen.net>
	<20081219214411.GA18003@infradead.org>
In-Reply-To: <20081219214411.GA18003@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:

>> 080: # rwtest (iogen|doio)
> 
> Doesn't run under Linux anyway.  Not sure why.

Heh, that one is funny:

_supported_os IRIX
[ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"

Eh?

Anyway, if we add "Linux" to _supported_os and un-comment:

#quiet=-q

it seems to pass fine on Linux.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
