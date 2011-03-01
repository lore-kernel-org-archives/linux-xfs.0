Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p212wJAq171190 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 20:58:19 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45DBE1DDC1A4
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 19:01:06 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ooEJx6KKEf9GfECE for <xfs@oss.sgi.com>;
	Mon, 28 Feb 2011 19:01:06 -0800 (PST)
Message-ID: <4D6C6171.8070105@sandeen.net>
Date: Mon, 28 Feb 2011 21:01:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: zero proper structure size for geometry calls
References: <4D6C28A5.60905@mnsu.edu> <4D6C4DEE.6020902@sandeen.net>
	<20110301025944.GG3087@dastard>
In-Reply-To: <20110301025944.GG3087@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>, Dan Rosenberg <drosenberg@vsecurity.com>, Eugene Teo <eugeneteo@kernel.org>, xfs@oss.sgi.com

On 2/28/11 8:59 PM, Dave Chinner wrote:
> On Mon, Feb 28, 2011 at 07:37:50PM -0600, Eric Sandeen wrote:
>> commit 493f3358cb289ccf716c5a14fa5bb52ab75943e5 added:
>>
>> +       memset(geo, 0, sizeof(*geo)); 
>>
>> but unfortunately we're dealing with a cast pointer here, and
>> the caller may actually have a smaller structure on the stack.
>> Zeroing out more leads to stack corruption traps:
>>
>> Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: f87aca93
>>
>> Pid: 262, comm: xfs_fsr Not tainted 2.6.38-rc6-493f3358cb2+ #1
>> Call Trace:
>>
>> [<c12991ac>] ? panic+0x50/0x150
>> [<c102ed71>] ? __stack_chk_fail+0x10/0x18
>> [<f87aca93>] ? xfs_ioc_fsgeometry_v1+0x56/0x5d [xfs] 
>>
>> Fix this by zeroing out the structure in the callers, where we know
>> the actual size.
>>
>> Reported-by: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
>> index f5e2a19..34e401f 100644
>> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
>> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
>> @@ -698,6 +698,7 @@ xfs_ioc_fsgeometry_v1(
>>  	xfs_fsop_geom_v1_t	fsgeo;
>>  	int			error;
>>  
>> +	memset(&fsgeo, 0, sizeof(xfs_fsop_geom_v1_t));
> 
> I'd prefer that sizeof(fsgeo) is used here. That means if the type
> is changed, then memset doesn't need to be. Same for all the rest
> of the memset calls.
> 
> Otherwise,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Cheers,
> 
> Dave.

Ok, I can resend, I was going to do that but most of xfs uses the other style so wasn't sure.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
