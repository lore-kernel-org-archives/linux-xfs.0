Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1B3HAi0104071 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 21:17:11 -0600
Message-ID: <499241C3.4070505@sandeen.net>
Date: Tue, 10 Feb 2009 21:10:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Don't reset di_format in xfs_ifree()
References: <49921B3E.8040406@sgi.com> <4992362F.1020307@sandeen.net>
	<4992424B.3030608@sgi.com>
In-Reply-To: <4992424B.3030608@sgi.com>
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
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> Eric Sandeen wrote:
>> Lachlan McIlroy wrote:
>>> I hit a panic while flushing a reclaimed inode that is fairly
>>> reproducible under load.
>> With what testcase?
> Initially with fsstress but then I wrote the extent.c program I
> attached to the next patch I posted.

Ah, ok, thanks.

-Eric

>> Thanks,
>> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
