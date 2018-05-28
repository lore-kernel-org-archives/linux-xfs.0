Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38764 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbeE1DxF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 May 2018 23:53:05 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 2/7] xfs_buflock: ignore if buffer already locked
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728630924.22515.10673342689667210150.stgit@magnolia>
Message-ID: <85d1efcf-fbea-2ec2-bbe1-03bbe55e58df@oracle.com>
Date: Sun, 27 May 2018 20:52:50 -0700
MIME-Version: 1.0
In-Reply-To: <152728630924.22515.10673342689667210150.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Looks ok:
Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 05/25/2018 03:11 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the trace data says we ran trylock but we were already locked, don't
> record another lock.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   tools/xfsbuflock.py |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tools/xfsbuflock.py b/tools/xfsbuflock.py
> index 82b6e01f..cc15f582 100755
> --- a/tools/xfsbuflock.py
> +++ b/tools/xfsbuflock.py
> @@ -87,7 +87,8 @@ class Buffer:
>   		self.waiters = set()
>   
>   	def trylock(self, process, time):
> -		self.lockdone(process, time)
> +		if not self.locked:
> +			self.lockdone(process, time)
>   
>   	def lockdone(self, process, time):
>   		if self.locked:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=8vuusUIByYR12ltQmXnO0mMuejRO5YBnWt7UmuNa7xI&s=0Vksri2Xw7b7Ozg6v-k-gqsXg6ESgtqgviNx2HQgSuE&e=
> 
