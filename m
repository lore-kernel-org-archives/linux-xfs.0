Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbeE1Dw3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 May 2018 23:52:29 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 3/7] xfs_buflock: record line number of trace where we
 locked the buffer
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728631542.22515.4825509736346292149.stgit@magnolia>
Message-ID: <ab75e6ee-1a99-4516-7273-f15cd6e518e0@oracle.com>
Date: Sun, 27 May 2018 20:52:13 -0700
MIME-Version: 1.0
In-Reply-To: <152728631542.22515.4825509736346292149.stgit@magnolia>
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
> Enhance the debug output by reporting at which line in the trace output
> we locked a particular buffer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   tools/xfsbuflock.py |    8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tools/xfsbuflock.py b/tools/xfsbuflock.py
> index cc15f582..954f0954 100755
> --- a/tools/xfsbuflock.py
> +++ b/tools/xfsbuflock.py
> @@ -85,6 +85,7 @@ class Buffer:
>   		self.locktime = None
>   		self.owner = None
>   		self.waiters = set()
> +		self.lockline = 0
>   
>   	def trylock(self, process, time):
>   		if not self.locked:
> @@ -92,7 +93,8 @@ class Buffer:
>   
>   	def lockdone(self, process, time):
>   		if self.locked:
> -			print('Buffer already locked on line %d?!' % nr)
> +			print('Buffer 0x%x already locked at line %d? (line %d)' % \
> +					(self.bno, self.lockline, nr))
>   		#	process.dump()
>   		#	self.dump()
>   		#	assert False
> @@ -101,6 +103,7 @@ class Buffer:
>   		self.locked = True
>   		self.owner = process
>   		self.locktime = time
> +		self.lockline = nr
>   		process.locked_bufs.add(self)
>   		process.bufs.add(self)
>   		locked_buffers.add(self)
> @@ -118,7 +121,8 @@ class Buffer:
>   
>   	def dump(self):
>   		if self.owner is not None:
> -			pid = '%s@%f' % (self.owner.pid, self.locktime)
> +			pid = '%s@%f (line %d)' % \
> +				(self.owner.pid, self.locktime, self.lockline)
>   		else:
>   			pid = ''
>   		print('dev %s bno 0x%x nblks 0x%x lock %d owner %s' % \
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=A4tW0F_UCH_YAKW12KzczzEcpxJELFgLQG594Ox2rhM&s=6yKJqQwtIKgwri-M_jFoU5ujldLBzdDVf_JJ3QxNi3o&e=
> 
