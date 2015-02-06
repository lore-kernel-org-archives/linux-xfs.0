Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D09858037
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 22:28:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CFD7AC001
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 20:27:58 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id 649vG1BV8rlwvn92 (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 20:27:56 -0800 (PST)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NJC009H91QIS110@mailout4.samsung.com> for
	xfs@oss.sgi.com; Fri, 06 Feb 2015 13:27:54 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
	<1421853126-4505-5-git-send-email-linkinjeon@gmail.com>
	<20150205234033.GW4251@dastard> <20150206031129.GL12722@dastard>
In-reply-to: <20150206031129.GL12722@dastard>
Subject: RE: [PATCH v9 4/11] xfsprogs: xfs_io: add finsert command for insert
	range
Date: Fri, 06 Feb 2015 13:27:53 +0900
Message-id: <001e01d041c5$466b6330$d3422990$@samsung.com>
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
Cc: 'Namjae Jeon' <linkinjeon@gmail.com>, tytso@mit.edu, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

> Hi Namjae,
Hi Dave,
> 
> On Fri, Feb 06, 2015 at 10:40:33AM +1100, Dave Chinner wrote:
> > On Thu, Jan 22, 2015 at 12:11:59AM +0900, Namjae Jeon wrote:
> > > From: Namjae Jeon <namjae.jeon@samsung.com>
> > >
> > > Add finsert command for fallocate FALLOC_FL_INSERT_RANGE flag.
> > >
> > > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> >
> > I've just pulled this patch into xfsprogs in preparation for getting
> > this functionality fully reviewed and merged in the 3.21 kernel
> > cycle.
> 
> xfs/293 3s ... - output mismatch (see /home/dave/src/xfstests-dev/results//xfs/293.out.bad)
>     --- tests/xfs/293.out       2014-01-20 16:57:34.000000000 +1100
>     +++ /home/dave/src/xfstests-dev/results//xfs/293.out.bad    2015-02-06 12:21:47.000000000 +1100
>     @@ -1,2 +1,3 @@
>      QA output created by 293
>      Silence is golden
>     +finsert not documented in the xfs_io manpage
>     .....
> 
> Can you send a patch that updates the xfs_io man page, please?
Okay, I will send it soon.
Thanks a lot!
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
