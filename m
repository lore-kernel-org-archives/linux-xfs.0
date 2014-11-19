Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E6CC7F3F
	for <xfs@oss.sgi.com>; Wed, 19 Nov 2014 16:27:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2CDE8304032
	for <xfs@oss.sgi.com>; Wed, 19 Nov 2014 14:27:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Ju6zF31FmBKESLdR for <xfs@oss.sgi.com>;
	Wed, 19 Nov 2014 14:27:27 -0800 (PST)
Message-ID: <546D194D.2010600@sandeen.net>
Date: Wed, 19 Nov 2014 16:27:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: catch invalid negative blknos in _xfs_buf_find()
References: <546D15E3.5000200@redhat.com>
In-Reply-To: <546D15E3.5000200@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/19/14 4:12 PM, Eric Sandeen wrote:
> Here blkno is a daddr_t, which is a __s64; it's possible to hold
> a value which is negative, and thus pass the (blkno >= eofs)
> test.  Then we try to do a xfs_perag_get() for a ridiculous
> agno via xfs_daddr_to_agno(), and bad things happen when that
> fails, and returns a null pag which is dereferenced shortly
> thereafter.
> 
> Found via a user-supplied fuzzed image...

NAK - this needs a bit more love; if we catch this and fail,
the caller may still do something crazy with this data.

V2 coming in a bit.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
