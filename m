Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A50E97F3F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 18:08:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CCB9304062
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 16:08:39 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id makRZGaKbqdBDI83
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 16:08:38 -0700 (PDT)
Message-ID: <53AA04F5.5080000@hardwarefreak.com>
Date: Tue, 24 Jun 2014 18:08:37 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS Repair hangs at inode repair in phase3
References: <trinity-ffefb824-acab-4879-8870-2861ffb3bad2-1403648145455@3capp-gmx-bs71>
In-Reply-To: <trinity-ffefb824-acab-4879-8870-2861ffb3bad2-1403648145455@3capp-gmx-bs71>
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
To: Dragon <Sunghost@gmx.de>, xfs@oss.sgi.com

On 6/24/2014 5:15 PM, Dragon wrote:
> Hi,
> yes read this, but i am new and dont know what this command will do and i dont 
> want to lost my data. I read in the net, that some people couldnt start or boot 
> from that disk, after running xfs_repair. I looked for a upgrade to latest 
> xfsprogs version, but it seems difficult for amd64 systems. Do you have a 
> changelog to latest version, could my installed version be ok, or better not to use?
> Thx Stan and Eric

# xfs_repair -n -P /dev/device

Post the output in your next reply, assuming it doesn't hang again.

Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
