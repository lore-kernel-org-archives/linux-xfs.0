Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82D27NU071256 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 08:02:07 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B26A219698CC
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2011 06:02:06 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id VGDnNV0eLgnKNGsC
	for <xfs@oss.sgi.com>; Fri, 02 Sep 2011 06:02:06 -0700 (PDT)
Received: from [192.168.100.200] (dales-rocket.hardwarefreak.com
	[192.168.100.200])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 906226C0EF
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2011 08:02:05 -0500 (CDT)
Message-ID: <4E60D3CD.5030806@hardwarefreak.com>
Date: Fri, 02 Sep 2011 08:02:05 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: nginx blocked task when XFS partition is very full
References: <3972BA0F-0E95-4758-9DDB-BC6197621C87@ci-info.com>
In-Reply-To: <3972BA0F-0E95-4758-9DDB-BC6197621C87@ci-info.com>
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

On 9/2/2011 7:23 AM, Sean Purdy wrote:
> Hi,
>
>
> This is on 2.6.32-32-server from Ubuntu Lucid 10.04 LTS
>
> We have nginx fileserving from four disks on a machine.  We're using mogilefs as a distributed file system.  We've come across an issue where when the filesystem is very full, and nginx tries to write to it, we get "task blocked for more than 120 seconds" messages from the kernel, nginx hangs and we can no longer access the fs.  When a file is uploaded via nginx, nginx writes to a .tmp directory on the disk before moving the file to its destination.  nginx can't be kill -9ed, it needs a reboot.
>
> Has this sort of issue been fixed since 2.6.32?

It would help to see df output for space and inodes of the XFS 
filesystem in question.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
