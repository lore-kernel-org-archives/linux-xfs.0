Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 39F0B7F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 05:50:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9DF48F8052
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 03:49:59 -0700 (PDT)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
	[209.85.220.51]) by cuda.sgi.com with ESMTP id xke5evgA7D6fyMo3
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Aug 2014 03:49:58 -0700 (PDT)
Received: by mail-pa0-f51.google.com with SMTP id ey11so12829860pad.38
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 03:49:58 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 12 Aug 2014 12:49:58 +0200
Message-ID: <CACyNnZNfTxxy0PsGKHgthoiGc74O_28uumGeG0CjLprxtiDv-Q@mail.gmail.com>
Subject: Location of backup superblocks
From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
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
To: xfs@oss.sgi.com

Hello,

I am trying to recover a XFS partition (or series of partitions) where
the main superblock was corrupted, and I see that there are multiple
superblock copies. I'd like to guess the partition start and size
also.

I see that the partition size can be calculated with sb_blocksize* sb_dblocks

But what about the partition start? I think I can guess it based in
the position of the found superblocks.

Any ideas where is the code that writes to disk those backup
superblocks? So far to me it looks like that their position is
calculated as disk_size / 4 rounded (nearest rounding?) to a multiple
of sb_blocksize, but having the exact code part would be better of
course =) Or even better, a list of backup superblock positions...

thanks,
-- 
Felipe Monteiro de Carvalho

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
