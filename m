Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6687C7F37
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 16:34:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 009BEAC004
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 14:34:03 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id dOAhLETCzPF271QG
	for <xfs@oss.sgi.com>; Thu, 03 Jul 2014 14:34:02 -0700 (PDT)
Message-ID: <53B5CC3B.5030108@hardwarefreak.com>
Date: Thu, 03 Jul 2014 16:33:47 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS syncs
References: <53B59B81.2030603@hotbox.ru>
In-Reply-To: <53B59B81.2030603@hotbox.ru>
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
To: flux@hotbox.ru, xfs@oss.sgi.com

On 7/3/2014 1:05 PM, flux@hotbox.ru wrote:
> Hi,
> 
> I issue 'mkdir abc' on my xfs partition the cut off the power. After
> reboot there's no 'abc' directoy. However, when I do that on ext4 the
> 'abc' direcory is always created after reboots. All the settings, about
> mount options are default for my distro. What am I missing or how do I
> change the things of the jounral or whatever?

So, you want XFS to behave like EXT4, is this correct?  Do you have an
actual workload where you need to cut power immediately after issuing
commands, as described above?

Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
