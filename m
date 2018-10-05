Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45364 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726732AbeJENwG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 09:52:06 -0400
Message-ID: <5BB70AA3.6060000@cn.fujitsu.com>
Date: Fri, 5 Oct 2018 14:54:27 +0800
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/6] xfs/270: use _scratch_xfs_set_metadata_field to fuzz
 rocompat bits
References: <153869874763.26648.516233620615833277.stgit@magnolia> <153869877319.26648.6762297729048228417.stgit@magnolia>
In-Reply-To: <153869877319.26648.6762297729048228417.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org

On 2018/10/05 8:19, Darrick J. Wong wrote:
> From: Darrick J. Wong<darrick.wong@oracle.com>
>
> Use the helper to set the metadata field so that we can bypass write
> verifier checks.
Hi Darrick,

When write command doesn't support -d option, xfs/270 with the patch 
works well.
Reviewed-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

Thanks,
Xiao Yang
> Signed-off-by: Darrick J. Wong<darrick.wong@oracle.com>
> ---
>   tests/xfs/270 |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
>
> diff --git a/tests/xfs/270 b/tests/xfs/270
> index da66bc33..fb72ba7c 100755
> --- a/tests/xfs/270
> +++ b/tests/xfs/270
> @@ -44,8 +44,8 @@ _scratch_mkfs_xfs>>$seqres.full 2>&1
>   # set the highest bit of features_ro_compat, use it as an unknown
>   # feature bit. If one day this bit become known feature, please
>   # change this case.
> -$XFS_DB_PROG -x -c "sb 0" -c "write -d features_ro_compat $((2**31))" \
> -	$SCRATCH_DEV | grep -v "Allowing write of corrupted data"
> +_scratch_xfs_set_metadata_field "features_ro_compat" "$((2**31))" "sb 0" | \
> +	grep 'features_ro_compat'
>
>   # rw mount with unknown ro-compat feature should fail
>   echo "rw mount test"
>
>
>
>
