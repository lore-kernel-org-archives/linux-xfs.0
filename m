Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1EFC07CA2
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 07:44:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96C74304059
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 05:44:35 -0700 (PDT)
Received: from mail02.iobjects.de (mail02.iobjects.de [188.40.134.68]) by
	cuda.sgi.com with ESMTP id uvVU4lTU4ZRDEHyH (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2016 05:44:32 -0700 (PDT)
Subject: Re: shrink_active_list/try_to_release_page bug? (was Re: xfs trace in
	4.4.2 / also in 4.3.3 WARNING fs/xfs/xfs_aops.c:1232
	xfs_vm_releasepage)
References: <20160516010602.GA24980@bfoster.bfoster>
	<57420A47.2000700@profihost.ag> <20160522213850.GE26977@dastard>
	<574BEA84.3010206@profihost.ag> <20160530223657.GP26977@dastard>
	<20160531010724.GA9616@bbox> <20160531025509.GA12670@dastard>
	<20160531035904.GA17371@bbox> <20160531060712.GC12670@dastard>
	<574D2B1E.2040002@profihost.ag> <20160531073119.GD12670@dastard>
	<575022D2.7030502@profihost.ag>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57502A2E.60702@applied-asynchrony.com>
Date: Thu, 2 Jun 2016 14:44:30 +0200
MIME-Version: 1.0
In-Reply-To: <575022D2.7030502@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>

On 06/02/16 14:13, Stefan Priebe - Profihost AG wrote:
> 
> Am 31.05.2016 um 09:31 schrieb Dave Chinner:
>> On Tue, May 31, 2016 at 08:11:42AM +0200, Stefan Priebe - Profihost AG wrote:
>>>> I'm half tempted at this point to mostly ignore this mm/ behavour
>>>> because we are moving down the path of removing buffer heads from
>>>> XFS. That will require us to do different things in ->releasepage
>>>> and so just skipping dirty pages in the XFS code is the best thing
>>>> to do....
>>>
>>> does this change anything i should test? Or is 4.6 still the way to go?
>>
>> Doesn't matter now - the warning will still be there on 4.6. I think
>> you can simply ignore it as the XFS code appears to be handling the
>> dirty page that is being passed to it correctly. We'll work out what
>> needs to be done to get rid of the warning for this case, wether it
>> be a mm/ change or an XFS change.
> 
> Any idea what i could do with 4.4.X? Can i safely remove the WARN_ONCE
> statement?

By definition it won't break anything since it's just a heads-up message,
so yes, it should be "safe". However if my understanding of the situation
is correct, mainline commit f0281a00fe "mm: workingset: only do workingset
activations on reads" (+ friends) in 4.7 should effectively prevent this
from happenning. Can someone confirm or deny this?

-h

PS: Stefan: I backported that commit (and friends) to my 4.4.x patch queue,
so if you want to try that for today's 4.4.12 the warning should be gone.
No guarantees though :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
