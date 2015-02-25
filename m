Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D21227F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 22:15:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B1E148F80D4
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 20:15:56 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id UZDLaGcPwjD2uO5d (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 20:15:55 -0800 (PST)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NKB00F9K7UETW40@mailout4.samsung.com> for
	xfs@oss.sgi.com; Wed, 25 Feb 2015 13:15:50 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
	<1424533554-28024-11-git-send-email-linkinjeon@gmail.com>
	<20150225030451.GG4251@dastard>
In-reply-to: <20150225030451.GG4251@dastard>
Subject: RE: [PATCH v10 10/12] xfstests: fsstress: Add fallocate insert range
	operation
Date: Wed, 25 Feb 2015 13:15:49 +0900
Message-id: <003201d050b1$bcae7e10$360b7a30$@samsung.com>
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
To: 'Dave Chinner' <david@fromorbit.com>
Cc: linux-man@vger.kernel.org, 'Namjae Jeon' <linkinjeon@gmail.com>, tytso@mit.edu, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org


> On Sun, Feb 22, 2015 at 12:45:52AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > This commit adds insert operation support for fsstress, which is
> > meant to exercise fallocate FALLOC_FL_INSERT_RANGE support.
> 
> This causes xfs/068 to fail because it changes the file creation
> pattern that results from a specific fsstress random seed. As such,
> I added this to xfs/068:
> 
> FSSTRESS_AVOID="-f insert=0 $FSSTRESS_AVOID"
> 
> To turn off the insert operation for that test and hence produce the
> expected tree of files.
Thanks for your notice :) I will check other TCs as well as insert range
TC next time.
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
