Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 223DF7F4E
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 02:17:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 013B7304039
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 00:16:59 -0800 (PST)
Received: from mail-ob0-f179.google.com (mail-ob0-f179.google.com
	[209.85.214.179]) by cuda.sgi.com with ESMTP id
	d4OTp17mHkPTcICQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 00:16:55 -0800 (PST)
Received: by mail-ob0-f179.google.com with SMTP id vb8so185031obc.10
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 00:16:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
References: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Thu, 22 Jan 2015 09:16:34 +0100
Message-ID: <CAHO5Pa3HnzP=KcBQOWDEkBqppMGXJ2kzfNKj21ruQ5SvWnms2g@mail.gmail.com>
Subject: Re: [PATCH v9 0/11] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Namjae Jeon <namjae.jeon@samsung.com>, Linux API <linux-api@vger.kernel.org>, bfoster@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, a.sangwan@samsung.com, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org

[CC += linux-api]

Hello Namjae

Please, all patches such as this that touch the user-space ABI must CC
linux-api@. (The kernel source file Documentation/SubmitChecklist
notes that all Linux kernel patches that change userspace interfaces
should be CCed to linux-api@vger.kernel.org.  See also
https://www.kernel.org/doc/man-pages/linux-api-ml.html )

Thanks,

Michael


On Wed, Jan 21, 2015 at 4:11 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> In continuation of the work of making the process of non linear editing of
> media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
> for fallocate.
>
> This flag will work opposite to the FALLOC_FL_COLLAPSE_RANGE flag.
> As such, specifying FALLOC_FL_INSERT_RANGE flag will create new space inside file
> by inserting a hole within the range specified by offset and len.
> User can write new data in this space. e.g. ads.
> Like collapse range, currently we have the limitation that offset and len should
> be block size aligned for both XFS and Ext4.
>
> The semantics of the flag are :
> 1) It creates space within file by inserting a hole of  len bytes starting
>    at offset byte without overwriting any existing data. All the data blocks
>    from offset to EOF are shifted towards right to make hole space.
> 2) It should be used exclusively. No other fallocate flag in combination.
> 3) Offset and length supplied to fallocate should be fs block size aligned
>    in case of xfs and ext4.
> 4) Insert range does not work for the case when offset is overlapping/beyond
>    i_size. If the user wants to insert space at the end of file they are
>    advised to use either ftruncate(2) or fallocate(2) with mode 0.
> 5) It increses the size of file by len bytes.
>
>
> Namjae Jeon (11):
>  fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  xfsprogs: xfs_io: add finsert command for insert range via fallocate
>  xfstests: generic/039: Standard insert range tests
>  xfstests: generic/040: Delayed allocation insert range
>  xfstests: generic/041: Multi insert range tests
>  xfstests: generic/042: Delayed allocation multi insert
>  xfstests: generic/043: Test multiple fallocate insert/collapse range calls
>  xfstests: fsstress: Add fallocate insert range operation
>  xfstests: fsx: Add fallocate insert range operation
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
