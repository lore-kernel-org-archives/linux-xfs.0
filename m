Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAB887F7E
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 06:51:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B98ED30404E
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 04:51:06 -0700 (PDT)
Received: from mail-pd0-f170.google.com (mail-pd0-f170.google.com
	[209.85.192.170]) by cuda.sgi.com with ESMTP id
	1zWRB42tEuhYfUwf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Aug 2014 04:51:02 -0700 (PDT)
Received: by mail-pd0-f170.google.com with SMTP id g10so5100019pdj.29
	for <xfs@oss.sgi.com>; Thu, 07 Aug 2014 04:51:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140806142329.GA39990@bfoster.bfoster>
References: <CACyNnZM8D4ZdOAvbXNoiRUAGh1uZF8=9Gy34qS2XH7QUVjiGsQ@mail.gmail.com>
	<20140806113447.GA14820@bfoster.bfoster>
	<CACyNnZNwCPw8dsyRKSty7GPp4DxAd7ycHuztsC-VAdGEmjdnyw@mail.gmail.com>
	<20140806142329.GA39990@bfoster.bfoster>
Date: Thu, 7 Aug 2014 13:51:01 +0200
Message-ID: <CACyNnZM7FB464+T22xkEvCKBkY6syixGJzsAGwHWsQOZnUpd_g@mail.gmail.com>
Subject: Re: xfs_bmbt_rec_64 leading to wrong blocks
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hello,

Thanks, that worked perfectly =)

My actual idea is to not only read the partition, but to also recover
deleted/corrupted files. With the information that you provided I
advanced a lot in this direction, and I can now recover the file
information in that memory area completely. I can also obtain the
inode nr (well 4 bytes of it are preserved, but its better then
nothing), but my current problem is with the inode itself. In a
deleted file the following changes are done by the linux driver in the
inode:

xfs_dinode_core_t.di_mode was changed to zero
xfs_dinode_core_t.di_format was changed from 1 (local) to 2 (extent)

But di_mode in particular is a key element as I am using it to
differentiate files from directories.

Is there anything else what I can use to differentiate files from
directories in case di_mode was corrupted? I am searching here but so
far I didn't find anything...

thanks,
-- 
Felipe Monteiro de Carvalho

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
