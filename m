Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4MNa5hf032449 for <xfs@oss.sgi.com>; Tue, 22 May 2012 18:36:05 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 386D9304043
	for <xfs@oss.sgi.com>; Tue, 22 May 2012 16:36:02 -0700 (PDT)
Received: from [134.15.95.100] (cf-vpn-hw-arenaud-3.corp.sgi.com
	[134.15.95.100])
	by estes.americas.sgi.com (Postfix) with ESMTP id DA33B700076F
	for <xfs@oss.sgi.com>; Tue, 22 May 2012 18:36:01 -0500 (CDT)
Message-ID: <4FBC22DA.4020500@sgi.com>
Date: Tue, 22 May 2012 19:35:54 -0400
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Prefix IO_XX flags with XFS_IO_XX to avoid namespace
	colision.
References: <4fbbfd75.nYwhMRRjLSAq0x8u%arenaud@sgi.com>
	<20120522232424.GK25351@dastard>
In-Reply-To: <20120522232424.GK25351@dastard>
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
To: xfs@oss.sgi.com



On 12-05-22 07:24 PM, Dave Chinner wrote:
> On Tue, May 22, 2012 at 03:56:21PM -0500, Alain Renaud wrote:
>>   This mod simply add a XFS_ prefix to IO_DIRECT,XFS_IO_DELALLOC,
>> XFS_IO_UNWRITTEN and XFS_IO_OVERWRITE. This to avoid namespace conflict
>> with other modules.
> While I don't see any problems with making the change, I don't see
> exactly how we could have a namespace clash here given they are
> internal to XFS, not very widely included and have beenthis way for
> years. What is the namespace clash you are seeing/caring about?
>
> Cheers,
>
> Dave.
>
Hi Dave,

Looking at the XFS code in general we do tend to prefix XFS specific macro 
with XFS_ . I did hit the name conflict with one of our internal module I 
did fix our module to prefix with the module name but I thought since I did 
hit the problem that maybe other people might have the same issue. This is 
why I am proposing this mod. it is low priority but I find it is a little 
cleaner to have this prefix.

Hope this make sense.

Alain

-- 
===============================================
Alain Renaud     - Cluster File System Engineer
arenaud@sgi.com  - SGI
===============================================

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
