Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0819E7F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 12:48:46 -0500 (CDT)
Message-ID: <5245C4FA.7010208@sgi.com>
Date: Fri, 27 Sep 2013 12:48:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix memory leak in xfs_dir2_node_removename
References: <20130927130140.640252809@sgi.com> <5245B5E5.7000206@sandeen.net>
In-Reply-To: <5245B5E5.7000206@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 09/27/13 11:44, Eric Sandeen wrote:
> On 9/27/13 8:01 AM, Mark Tinguely wrote:
>> Free the memory pointed to by state before returning on error from
>> xfs_dir2_node_removename.c
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> ---
>> Found by Coverity (134681) in userspace, same patch applies there
>> also.
>
> Heh, looks like that one has been around since the dawn of time, thanks.
>
> Reviewed-by: Eric Sandeen<sandeen@redhat.com>
>
> how do we handle the matching userspace fixes, separate patch to
> be explicit?  Wait for the next syncup?
>
> Thanks,
> -Eric

<patch delete>

Good question.

The user space should be kept up to date with the kernel.

Since the patches will be identical except the directory name, I was 
hoping to submit one copy. But I am not trying to invent a policy, just 
being lazy.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
