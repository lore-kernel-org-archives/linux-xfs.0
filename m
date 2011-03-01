Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p21Lc64R220054 for <xfs@oss.sgi.com>; Tue, 1 Mar 2011 15:38:06 -0600
Received: from mail.mnsu.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B5691634A0D
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2011 13:40:54 -0800 (PST)
Received: from mail.mnsu.edu (Mail.MNSU.EDU [134.29.1.12]) by cuda.sgi.com
	with ESMTP id ak8NdtzyHI2wHqHb for <xfs@oss.sgi.com>;
	Tue, 01 Mar 2011 13:40:54 -0800 (PST)
Message-ID: <4D6D67E2.80503@mnsu.edu>
Date: Tue, 01 Mar 2011 15:40:50 -0600
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
MIME-Version: 1.0
Subject: Re: [PATCH, V3 (sort of)] xfs: zero proper structure size for geometry
	calls
References: <4D6C28A5.60905@mnsu.edu>
	<4D6C4DEE.6020902@sandeen.net>		<4D6C9958.2040607@sandeen.net>
	<1298984132.32568.3.camel@dan>		<4D6D128C.6010503@mnsu.edu>
	<4D6D157B.9070800@sandeen.net>	<1299001800.2381.10.camel@doink>
	<4D6D3891.5060908@sandeen.net>
In-Reply-To: <4D6D3891.5060908@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, xfs@oss.sgi.com, Eugene Teo <eugeneteo@kernel.org>, aelder@sgi.com



On 03/01/2011 12:18 PM, Eric Sandeen wrote:
> On 3/1/11 11:50 AM, Alex Elder wrote:
>    
>> I'm sorry to muddy the waters with this.  But I think the
>> proposed patch fixes the wrong problem.  Having xfs_fs_geometry()
>> zero its argument is fine--it defines an interface and honors
>> it.  The real problem lies in xfs_ioc_fsgeometry_v1(), which
>> violates that interface by passing the address of an object
>> that's not the right size.  So below is an alternative to
>> Eric's solution which just fixes this one caller instead.
>>
>> Eric has already told me this makes more sense.  It would
>> be nice if Jeffrey would re-test this fix, and Dan would
>> sign off on it as well.
>>      
> Reviewed-by: Eric Sandeen<sandeen@redhat.com>

I can't tell you if the security concerns are met but I can tell you 
that xfs_fsr is working as one would expect without a Kernel panic.

Tested-by: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
