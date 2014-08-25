Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 120DB7F5A
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 01:52:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5BE0304048
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2014 23:52:30 -0700 (PDT)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id fZXPXW5ZO0EbO4gn (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 24 Aug 2014 23:52:28 -0700 (PDT)
Received: from epcpsbgr4.samsung.com
	(u144.gpu120.samsung.co.kr [203.254.230.144])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NAU00HRPOFE7U70@mailout3.samsung.com> for
	xfs@oss.sgi.com; Mon, 25 Aug 2014 15:52:26 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <004301cfb2c6$6ef2d330$4cd87990$@samsung.com>
	<20140822120659.GF3152@laptop.bfoster>
In-reply-to: <20140822120659.GF3152@laptop.bfoster>
Subject: RE: [PATCH v5 2/10] xfs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Date: Mon, 25 Aug 2014 15:52:26 +0900
Message-id: <001901cfc031$2140a950$63c1fbf0$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Brian Foster' <bfoster@redhat.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>, 'linux-ext4' <linux-ext4@vger.kernel.org>

> Hi Namjae,
Hi Brian.

Thanks for your mail :)
> 
> Sorry for finding things so late, but it looks like this suffers from
> the same couple bugs we've recently discovered with the collapse range
> patches. See the following for a couple fixes that have been proposed
> recently:
> 
> http://oss.sgi.com/archives/xfs/2014-08/msg00292.html
> 
> This one helps prevent scenarios where we try to cancel a transaction
> that is dirty. This leads to a shutdown on XFS. The idea is basically to
> avoid logging until we actually make a change, so errors hit early in
> the function (before we change anything) won't lead to an abort in the
> error path. It looks like the bmap split and shift functions in this
> patch could use the very same attention.
Okay, I will add this commit to insert range patch.

> 
> http://oss.sgi.com/archives/xfs/2014-08/index.html
> 
> This one deals with a problem with the high level shift algorithm. The
> problem with the algorithm here is that 'current_ext' can change
> unexpectedly once we release the ilock due to writeback on parts of the
> file before the range being collapsed/inserted. E.g., it is not a stable
> index once ilock is dropped. The temporary solution is to flush the
> entire file, since we have the iolock during the entire operation and
> nothing else can dirty the file. The better fix is to track via an
> offset across iterations of the shift, rather than the extent count
> (iirc, xfs_bunmapi() and other bmap functions provide examples of this
> kind of algorithm).
Okay, I will check your points.

> 
> Brian
> 
> P.S., It's probably a good idea to remove my r-b tag on the next post as
> well to avoid confusion and remind me that I need to take another look
> at this. ;) Thanks again.
Okay, I will remove it.

Thanks Brian!
> 

> > --
> > 1.7.11-rc0
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
