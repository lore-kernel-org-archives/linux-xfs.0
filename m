Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 980D17CA4
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 08:27:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65BEA304032
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 06:27:12 -0700 (PDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id pyCiPv7nv0LrU3L8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2016 06:27:07 -0700 (PDT)
Received: by mail-wm0-f43.google.com with SMTP id a66so27864657wme.0
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 06:27:07 -0700 (PDT)
Message-ID: <57727B27.7060104@plexistor.com>
Date: Tue, 28 Jun 2016 16:27:03 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<20160623232446.GA12670@dastard> <20160624072612.GA22205@lst.de>
	<20160624230045.GG12670@dastard> <20160628131059.GA30475@lst.de>
In-Reply-To: <20160628131059.GA30475@lst.de>
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
To: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com

On 06/28/2016 04:10 PM, Christoph Hellwig wrote:
> On Sat, Jun 25, 2016 at 09:00:45AM +1000, Dave Chinner wrote:
<>
> 
> Right.  And an existing application can get DAX turned on under its
> back, and will now suddently get different synchronization behavior.
> That is if it's writes happen to be aligned to the fs block size.
> 

Is there an actual application that does that? or is this purely
theoretical right now?


Thanks
Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
