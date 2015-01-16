Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A1B67F4E
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 01:26:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C0998F8033
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 23:26:46 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id wIOs408CxWduFTvy (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Jan 2015 23:26:39 -0800 (PST)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NI900J5QE0DNH40@mailout4.samsung.com> for
	xfs@oss.sgi.com; Fri, 16 Jan 2015 16:26:37 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <1421165126-3585-1-git-send-email-linkinjeon@gmail.com>
	<1421165126-3585-3-git-send-email-linkinjeon@gmail.com>
	<20150115122906.GC18876@bfoster.bfoster>
In-reply-to: <20150115122906.GC18876@bfoster.bfoster>
Subject: RE: [PATCH v8 2/11] xfs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Date: Fri, 16 Jan 2015 16:26:36 +0900
Message-id: <005101d0315d$c31ad6e0$495084a0$@samsung.com>
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
To: 'Brian Foster' <bfoster@redhat.com>, 'Namjae Jeon' <linkinjeon@gmail.com>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

> On Wed, Jan 14, 2015 at 01:05:17AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > This patch implements fallocate's FALLOC_FL_INSERT_RANGE for XFS.
> >
> > 1) Make sure that both offset and len are block size aligned.
> > 2) Update the i_size of inode by len bytes.
> > 3) Compute the file's logical block number against offset. If the computed
> >    block number is not the starting block of the extent, split the extent
> >    such that the block number is the starting block of the extent.
> > 4) Shift all the extents which are lying bewteen [offset, last allocated extent]
> >    towards right by len bytes. This step will make a hole of len bytes
> >    at offset.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Cc: Brian Foster<bfoster@redhat.com>
> > ---
> 
> Fixes look good (I assume nothing else changed between the few nits
> called out in v7) and survives overnight fsstress and fsx testing
> without any explosions:
Yes, I am also running test for long time, If there is any issue, will share.
Thanks for your review and help :)
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
