Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA36C7CA0
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 03:03:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF901304048
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 01:03:49 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id IkyzFFumIsy3woNO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 01:03:43 -0700 (PDT)
Subject: Re: shrink_active_list/try_to_release_page bug? (was Re: xfs trace in
	4.4.2 / also in 4.3.3 WARNING fs/xfs/xfs_aops.c:1232
	xfs_vm_releasepage)
References: <20160516010602.GA24980@bfoster.bfoster>
	<57420A47.2000700@profihost.ag> <20160522213850.GE26977@dastard>
	<574BEA84.3010206@profihost.ag> <20160530223657.GP26977@dastard>
	<20160531010724.GA9616@bbox> <20160531025509.GA12670@dastard>
	<20160531035904.GA17371@bbox> <20160531060712.GC12670@dastard>
	<574D2B1E.2040002@profihost.ag> <20160531073119.GD12670@dastard>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <574D455D.8050101@profihost.ag>
Date: Tue, 31 May 2016 10:03:41 +0200
MIME-Version: 1.0
In-Reply-To: <20160531073119.GD12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 31.05.2016 um 09:31 schrieb Dave Chinner:
> On Tue, May 31, 2016 at 08:11:42AM +0200, Stefan Priebe - Profihost AG wrote:
>>> I'm half tempted at this point to mostly ignore this mm/ behavour
>>> because we are moving down the path of removing buffer heads from
>>> XFS. That will require us to do different things in ->releasepage
>>> and so just skipping dirty pages in the XFS code is the best thing
>>> to do....
>>
>> does this change anything i should test? Or is 4.6 still the way to go?
> 
> Doesn't matter now - the warning will still be there on 4.6. I think
> you can simply ignore it as the XFS code appears to be handling the
> dirty page that is being passed to it correctly. We'll work out what
> needs to be done to get rid of the warning for this case, wether it
> be a mm/ change or an XFS change.

So is it OK to remove the WARN_ONCE in kernel code? So i don't get
alarms from our monitoring systems for the trace.

Stefan

> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
