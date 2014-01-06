Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 677797F4E
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 02:23:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8D43AC005
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 00:23:47 -0800 (PST)
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]) by cuda.sgi.com with
	ESMTP id bl59WWrw0govABzm (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Jan 2014 00:23:45 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id E27FA3EE1D8
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 17:23:43 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id D001F45DEB7
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 17:23:43 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id B8DC345DD76
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 17:23:43 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id A88E0E08002
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 17:23:43 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com
	[10.240.81.136])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 5888A1DB803C
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 17:23:43 +0900 (JST)
Message-ID: <52CA67F2.9010108@jp.fujitsu.com>
Date: Mon, 06 Jan 2014 17:23:14 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix wrong return check for case 022
References: <1388995737-3480-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1388995737-3480-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 2014/01/06 17:08, Wang Shilong wrote:
> Here we expect 0 as return value, fix it.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Cc: Josef Bacik <jbacik@fb.com>
> ---
>   tests/btrfs/022 | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>   mode change 100644 => 100755 tests/btrfs/022
> 
> diff --git a/tests/btrfs/022 b/tests/btrfs/022
> old mode 100644
> new mode 100755
> index 5b18643..142aaf9
> --- a/tests/btrfs/022
> +++ b/tests/btrfs/022
> @@ -106,7 +106,7 @@ _limit_test()
>   	[ $? -ne 0 ] || _fail "quota should have limited us"
>   	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
>   		$seqres.full 2>&1
> -	[ $? -eq 0 ] || _fail "should have been allowed to write"
> +	[ $? -ne 0 ] || _fail "should have been allowed to write"

from "man bash",
       An OR list has the form
              command1 || command2
       command2 is executed if and only if command1 returns a non-zero exit
       status.

So, original code is OK, I think.

Thanks,
Tsutomu

>   }
>   
>   _scratch_mkfs > /dev/null 2>&1
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
