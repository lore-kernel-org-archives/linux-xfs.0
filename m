Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 429F87F76
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 02:40:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3BDE38F8050
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 00:40:33 -0700 (PDT)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id 2OSgVf5LRl5AWJSB (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 31 May 2014 00:40:32 -0700 (PDT)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N6F002Y1HBH1J90@mailout3.samsung.com> for
	xfs@oss.sgi.com; Sat, 31 May 2014 16:40:29 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <003601cf6aa7$883103b0$98930b10$@samsung.com>
	<alpine.LFD.2.00.1405301238190.2009@localhost.localdomain>
In-reply-to: <alpine.LFD.2.00.1405301238190.2009@localhost.localdomain>
Subject: RE: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Sat, 31 May 2014 16:40:29 +0900
Message-id: <000d01cf7ca3$98335c50$c89a14f0$@samsung.com>
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
To: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>

 
> > Date: Thu, 08 May 2014 19:23:19 +0900
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
> > Cc: linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
> >     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> >     Ashish Sangwan <a.sangwan@samsung.com>
> > Subject: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
> >
> > In continuation of the work of making the process of non linear editing of
> > media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
> > for fallocate.
> >
> > This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
> > As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
> > in between the file within the range specified by offset and len. User can
> > write new data in this space. e.g. ads.
> > Like collapse range, currently we have the limitation that offset and len should
> > be block size aligned for both XFS and Ext4.
> >
> > The semantics of the flag are :
> > 1) It allocates new zeroed out on disk space of len bytes starting
> >    at offset byte without overwriting any existing data. All the data blocks
> >    from offset to EOF are shifted towards right to make space for inserting
> >    new blocks
> 
> Hi,
> 
> this sounds a little bit weird to me. I understand the reason for
> this, but this is effectively two operations masking as one. We
> shift the existing data and then we allocate unwritten extents for
> the hole we've created.
> 
> What would make more sense to me is to implement only the first
> operation - the shift. And then let the user to allocate unwritten
> extents for the hole using simple fallocate.
> 
> The reason is that if you succeed the first part and then fail the
> second due to ENOSPC or any other reason the file will end up in
> undefined state unnecessarily. Yes in your current implementation
> it seems that you'll always end up with the hole in the file and the
> rest is properly shifted, but that may vary from file system to file
> system. Some might choose to roll back the shift, some might not.
> 
> If FALLOC_FL_INSERT_RANGE (or any name you wish to choose) would
> just simply shift the extents then you'll get rid of this and the
> only thing that user needs to do (if he chooses to) is to use
> fallocate for the hole created by the shift. If it fails, then
> well, he can try again without any consequences. As a bonus you get
> the possibility to leave the hole in the file which might be useful
> as well.
> 
> With current behaviour this might get very confusing very quickly.
> 
> What do you and others think ?
Hi Lukas.
Insert range inherently means inserting a real range of space into
the file to provide guaranteed space with user in the inserted area
so that further writes should not fail with an -ENOSPC at least.
If insert range cannot gurantees the above semantics, It should
return error to user space.

If insert range has been performed on a file, It will reserve space
that write never fail in the inserted area,
In case of full partition or small available size than the range
user want, It seems odd just only left inserting a hole in the middle
of file and return success to user when no one can really write to
this hole.

Thanks!
> 
> Thanks!
> -LUkas
> 
> 
> > 2) It should be used exclusively. No other fallocate flag in combination.
> > 3) Offset and length supplied to fallocate should be fs block size aligned
> >    in case of xfs and ext4.
> > 4) Insert range does not work for the case when offset is overlapping/beyond
> >    i_size. If the user wants to allocate space at the end of file they are
> >    advised to use either ftruncate(2) or fallocate(2) with mode 0.
> > 5) It increses the size of file by len bytes.
> >
> >
> > Namjae Jeon (10):
> >  fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  xfsprogs: xfs_io: add finsert command for insert range via fallocate
> >  xfstests: generic/027: Standard insert range tests
> >  xfstests: generic/028: Delayed allocation insert range
> >  xfstests: generic/029: Multi insert range tests
> >  xfstests: generic/030: Delayed allocation multi insert
> >  xfstests: fsstress: Add fallocate insert range operation
> >  xfstests: fsx: Add fallocate insert range operation
> >
> >

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
