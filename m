Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38F3E7F37
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 15:28:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CA4AAAC006
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 13:28:43 -0700 (PDT)
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
	by cuda.sgi.com with ESMTP id VtnQcGMFayzEe1L6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 13:28:42 -0700 (PDT)
Message-ID: <55380476.3050509@hp.com>
Date: Wed, 22 Apr 2015 16:28:38 -0400
From: Waiman Long <waiman.long@hp.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: call xfs_idestroy_fork() in xfs_ilock() critical
	section
References: <1429724021-7675-1-git-send-email-Waiman.Long@hp.com>
	<20150422191137.GF6688@bfoster.bfoster>
In-Reply-To: <20150422191137.GF6688@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 04/22/2015 03:11 PM, Brian Foster wrote:
> On Wed, Apr 22, 2015 at 01:33:41PM -0400, Waiman Long wrote:
>> The commit f7be2d7f594cbc ("xfs: push down inactive transaction
>> mgmt for truncate") refactored the xfs_inactive() function
>> in fs/xfs/xfs_inode.c.  However, it also moved the call to
>> xfs_idestroy_fork() from inside the xfs_ilock() critical section to
>> outside. That was causing memory corruption and strange failures like
>> deferencing NULL pointers in some circumstances.
>>
>> This patch moves the xfs_idestroy_fork() call back into an xfs_ilock()
>> critical section to avoid memory corruption problem.
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>> ---
> Interesting... so from your previous mail we have an inactive/reclaim
> racing with an xfs_iflush_fork() of the attr fork, or something of that
> nature? Is there a specific reproducer or is it some kind of stress
> test?
>
> Good catch in any case, it looks like a deviation from the previous
> code...

I am not sure what kind of races are going on. I was running the AIM7 
workload for performance comparison purpose. I hit the error when 
running the disk workload with xfs filesystem. The smaller the ramdisk 
that I used, the easier it was to reproduce the error. I think I haven't 
run it for quite a while so I did not notice any problem or I might have 
just ignored it in some previous runs.

I did check some other call sites of xfs_idestroy_fork() and they are 
under xfs_ilock(). So I suppose it is not safe to call it outside of the 
critical section. This patch did indeed fix the problem that I saw when 
running the disk workload.

Cheers,
Longman


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
