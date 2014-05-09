Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 393F87F51
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 12:33:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B16D1AC002
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 10:33:11 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id u7lkWaSSPTsLEXlz
	for <xfs@oss.sgi.com>; Fri, 09 May 2014 10:33:10 -0700 (PDT)
Message-ID: <536D1149.2020502@fb.com>
Date: Fri, 9 May 2014 13:32:57 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests/btrfs: add qgroup rescan stress test
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<1399615343-28544-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1399615343-28544-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org

On 05/09/2014 02:02 AM, Wang Shilong wrote:
> Test flow is to run fsstress after triggering quota rescan.
> the ruler is simple, we just remove all files and directories,
> sync filesystem and see if qgroup's ref and excl are nodesize.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
> v2->v3: addressed comments from josef:
> 	- remove unnecessary redirections
> 	- don't use _run_btrfs_util_prog() when capturing qgroup show output.
> 	- turn off inode_cache mount option explicitly.
>
> v1->v2: switch to _run_btrfs_util_prog()

Perfect thanks Wang,

Reviewed-by: Josef Bacik <jbacik@fb.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
