Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3398F7F6C
	for <xfs@oss.sgi.com>; Mon,  8 Apr 2013 09:04:43 -0500 (CDT)
Message-ID: <5162CE93.7010301@sgi.com>
Date: Mon, 8 Apr 2013 09:05:07 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfstests generic 310: fix common file path and other
	cleanups
References: <1365331147-15179-1-git-send-email-eguan@redhat.com>
	<1365331147-15179-3-git-send-email-eguan@redhat.com>
In-Reply-To: <1365331147-15179-3-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>, zhaohongjiang@huawei.com
Cc: xfs@oss.sgi.com

Hi Eryu,

Thanks for this cleanup patch. I was going to revert patch "bbaf78c0" 
which introduced test generic/310 but will wait and see if Zhao will 
provide more information which could be added to this patch.


On 04/07/2013 05:39 AM, Eryu Guan wrote:
> 1. add one space between # and test description

The rest of the changes look good, sorry I missed them when I reviewed ;).

> 2. remove creator/owner info
> 3. fix common/rc and common/filter path so they can be sourced correctly
> 4. no need to remove $seq.full cause it's not used(or if verbose output
>     is needed, $seqres.full should be used)
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>   tests/generic/310 | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/tests/generic/310 b/tests/generic/310
> index ef51422..35baa23 100644
> --- a/tests/generic/310
> +++ b/tests/generic/310
> @@ -1,8 +1,8 @@
>   #! /bin/bash
>   # FS QA Test No. 310
>   #
> -#Check if there are two threads,one keeps calling read() or lseek(), and
> -#the other calling readdir(), both on the same directory fd.
> +# Check if there are two threads,one keeps calling read() or lseek(), and
> +# the other calling readdir(), both on the same directory fd.
>   #

Hi Zhao,

I did see both threads running at the same time, but the more I look at 
this, the more I am a loss as to what this test is doing.

Will you expand this a little please.  I should have asked for more 
justification the first time I reviewed this. Please provide what bug
this is testing or what failure/weakness this test exposes.  If there is 
a commit this is related to, please reference it.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
