Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 949BB7CBE
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 16:59:01 -0500 (CDT)
Message-ID: <520D4F4B.9010908@sgi.com>
Date: Thu, 15 Aug 2013 16:59:39 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [v6] xfstests: add a new test case for ext4 indirect-based file
References: <1368676359-2404-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1368676359-2404-1-git-send-email-wenqing.lz@taobao.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "wenqing.lz" <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

This has not been reviewed since your second revision.
It looks good except you need to remove the changes to tests/generic/255 
and rebase against the latest tree.

You can then include a:
Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Thanks
--Rich

On 05/15/2013 10:52 PM, wenqing.lz wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> After applied this commit (864688d3), xfstests #255 will not test a
> file system that cannot support fallocate(2), such as a indirect-based
> file in ext4.  So we need to add a new generic test case to test it.
>
> The difference between #255 and this test case is only to use pwrite to
> allocate blocks.  Other filesystems should survive in this test case.
> In the mean time, a new argument '-u' is added into _test_generic_punch
> not to run unwritten tests.
>
And remove these 2 lines as they no longer apply.
> Meanwhile this commit fixes a minor problem in #255 that testfile should
> use $seq.$$ as testfile.
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>
> ---
> changelog:
>   * rebase against the latest master of xfstests tree (Based-on Eric's patch).
>
>   common/punch          | 164 ++++++++++++++++++++++++++-----------------------
>   tests/generic/255     |   2 +-



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
