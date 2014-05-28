Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A4DC7F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 19:10:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 990D3AC003
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 17:10:40 -0700 (PDT)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id jxlKA7MeZOqxZlFe (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 17:10:38 -0700 (PDT)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N69008PHCHOTO20@mailout1.samsung.com> for
	xfs@oss.sgi.com; Wed, 28 May 2014 09:10:36 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <001401cf7984$4e3e1850$eaba48f0$@samsung.com>
	<20140527205959.GA26393@bfoster.bfoster>
In-reply-to: <20140527205959.GA26393@bfoster.bfoster>
Subject: RE: [PATCH v3 2/10] xfs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Date: Wed, 28 May 2014 09:10:35 +0900
Message-id: <000401cf7a09$3fb514c0$bf1f3e40$@samsung.com>
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
Cc: linux-fsdevel@vger.kernel.org, 'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com

> 
> On Tue, May 27, 2014 at 05:18:57PM +0900, Namjae Jeon wrote:
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
> > 5) Allocate unwritten extents for the hole created in step 4.
> >
> > Cc: Brian Foster <bfoster@redhat.com>
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> 
> FYI, while I didn't notice any test failures so far, a run through some
> of the generic xfstests do produce some assert failures and whatnot. I
> noticed output from generic/013,091,127,263. I haven't looked at these
> much at all so far, I just wanted to get them on the list...
> 
> Namjae, I reproduced these issues running ./check -g auto with
> CONFIG_XFS_WARN enabled for XFS (to warn on assert failures). Below is a
> quick dump of output from generic/091, as an example. That one
> reproduces consistently for me. We'll probably want to run through and
> squash this and any others before this gets merged.
Hi Brian.

I will check this problem.
Thanks for your help!
> 
> Brian
> 
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
