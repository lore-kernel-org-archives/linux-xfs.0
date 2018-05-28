Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54072 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbeE1Dwf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 May 2018 23:52:35 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 4/7] xfs_buflock: record buffer initialization
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728632163.22515.2423877809843536137.stgit@magnolia>
Message-ID: <fd6f49d6-fac7-40d7-462e-4123a993f4c9@oracle.com>
Date: Sun, 27 May 2018 20:52:21 -0700
MIME-Version: 1.0
In-Reply-To: <152728632163.22515.2423877809843536137.stgit@magnolia>
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

On 05/25/2018 03:12 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Buffers are created locked, so we have to factor that into the buffer
> state machine that the script utilizes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   tools/xfsbuflock.py |   11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> 
> diff --git a/tools/xfsbuflock.py b/tools/xfsbuflock.py
> index 954f0954..8f38f9f0 100755
> --- a/tools/xfsbuflock.py
> +++ b/tools/xfsbuflock.py
> @@ -91,6 +91,13 @@ class Buffer:
>   		if not self.locked:
>   			self.lockdone(process, time)
>   
> +	def init(self, process, time):
> +		# Buffers are initialized locked, but we could be allocating
> +		# a surplus buffer while trying to grab a buffer that may or
> +		# may not already exist.
> +		if not self.locked:
> +			self.lockdone(process, time)
> +
>   	def lockdone(self, process, time):
>   		if self.locked:
>   			print('Buffer 0x%x already locked at line %d? (line %d)' % \
> @@ -183,6 +190,10 @@ for line in fileinput.input():
>   		buf = getbuf(toks)
>   		if buf is not None:
>   			buf.trylock(proc, time)
> +	elif fn == 'xfs_buf_init':
> +		buf = getbuf(toks)
> +		if buf is not None:
> +			buf.init(proc, time)
>   	elif fn == 'xfs_buf_item_unlock':
>   		pass
>   	else:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=ZceT9igTX4NtDB5x4zRNsz3TmN4D9IUS-PIL2AEkKxI&s=VCNmW1CRDq3QALM6L6wQiTmHHrEeGSZVf4H7GUBQG2w&e=
> 
