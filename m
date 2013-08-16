Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF2407F4E
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 00:31:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF11D30406B
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 22:31:14 -0700 (PDT)
Received: from mail-pd0-f181.google.com (mail-pd0-f181.google.com
	[209.85.192.181]) by cuda.sgi.com with ESMTP id
	WKoIlFPs4tcFqm7h (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 22:31:10 -0700 (PDT)
Received: by mail-pd0-f181.google.com with SMTP id g10so1762172pdj.26
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 22:31:10 -0700 (PDT)
Date: Fri, 16 Aug 2013 13:31:49 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [v6] xfstests: add a new test case for ext4 indirect-based file
Message-ID: <20130816053149.GA3871@gmail.com>
References: <1368676359-2404-1-git-send-email-wenqing.lz@taobao.com>
	<520D4F4B.9010908@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520D4F4B.9010908@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Aug 15, 2013 at 04:59:39PM -0500, Rich Johnston wrote:
> This has not been reviewed since your second revision.
> It looks good except you need to remove the changes to
> tests/generic/255 and rebase against the latest tree.
> 
> You can then include a:
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Thanks for your review.  I have rebased the patch and the latest patch
has been sent out.  Could you please review it?

Thanks,
                                                - Zheng

> 
> Thanks
> --Rich
> 
> On 05/15/2013 10:52 PM, wenqing.lz wrote:
> >From: Zheng Liu <wenqing.lz@taobao.com>
> >
> >After applied this commit (864688d3), xfstests #255 will not test a
> >file system that cannot support fallocate(2), such as a indirect-based
> >file in ext4.  So we need to add a new generic test case to test it.
> >
> >The difference between #255 and this test case is only to use pwrite to
> >allocate blocks.  Other filesystems should survive in this test case.
> >In the mean time, a new argument '-u' is added into _test_generic_punch
> >not to run unwritten tests.
> >
> And remove these 2 lines as they no longer apply.
> >Meanwhile this commit fixes a minor problem in #255 that testfile should
> >use $seq.$$ as testfile.
> >
> >Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> >
> >---
> >changelog:
> >  * rebase against the latest master of xfstests tree (Based-on Eric's patch).
> >
> >  common/punch          | 164 ++++++++++++++++++++++++++-----------------------
> >  tests/generic/255     |   2 +-
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
