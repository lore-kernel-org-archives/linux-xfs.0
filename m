Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2163D7CBF
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 14:50:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE9F8AC003
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 12:50:30 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id krLBKSVOpkQl86mo
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 12:50:29 -0700 (PDT)
Message-ID: <51549F09.1090109@hardwarefreak.com>
Date: Thu, 28 Mar 2013 14:50:33 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Help with XFS in VMs on VMFS
References: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
In-Reply-To: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: Jan Perci <jperci@gmail.com>
Cc: xfs@oss.sgi.com

On 3/28/2013 8:21 AM, Jan Perci wrote:

> Normally I would use raw mappings and XFS directly on the volumes.  But
> there is a hard requirement to support VM snapshots, so all the data must
> reside within VMDK files on the VMFS datastores.

Since when?  ESX has had LUN snapshot capability back to 3.0, 6 years or
so.  It may have required the VCB add on back then.

Is this simply a limitation of the freebie version?  If so, pony up and
pay for what you need, or switch to a FOSS solution which has no such
limitations.

VMFS volumes are not intended for high performance IO.  Unless things
have changed recently, VMware has always recommended housing only OS
images and the like in VMDKs, not user data.  They've always recommended
using RDMs for everything else.  IIRC VMDKs have a huge block (sector)
size, something like 1MB.  That's going to make XFS alignment difficult,
if not impossible.

I cannot stress emphatically enough that you should not stitch 2TB VMDKs
together and use them in the manner you described.  This is a recipe for
disaster.  Find another solution.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
