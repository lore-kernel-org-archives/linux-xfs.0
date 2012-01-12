Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0C1HorY205200 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 19:17:51 -0600
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id otp9hoEA7dLpTk0w for
	<xfs@oss.sgi.com>; Wed, 11 Jan 2012 17:17:48 -0800 (PST)
Message-ID: <4F0E347C.5040506@cn.fujitsu.com>
Date: Thu, 12 Jan 2012 09:16:44 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix 251's cp -axT problem
References: <1326195560-4434-1-git-send-email-liubo2009@cn.fujitsu.com>
	<20120111114544.GE14423@infradead.org>
	<alpine.LFD.2.00.1201111310060.5636@dhcp-27-109.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1201111310060.5636@dhcp-27-109.brq.redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 01/11/2012 08:14 PM, Lukas Czerner wrote:
> On Wed, 11 Jan 2012, Christoph Hellwig wrote:
> 
>> On Tue, Jan 10, 2012 at 07:39:20PM +0800, Liu Bo wrote:
>>> When I ran xfstests, 251 got failed cause "cp -axT" did not work as wish:
>>> cp: cannot overwrite directory `/mnt/scratch/1' with non-directory
>>>
>>> With this patch, 251 has passed.
>> Why would cp give that message with a missing /?
>>
>> I'm not against putting this in, but I'd like to understand what's going
>> on.
>>
>> Lukas, any idea?
>>
> 
> Hi Christoph,
> 
> the only reason I can think of is probably that Liu is accessing the
> xfstests directory via symbolic link, hence the '$content' addresses the
> symbolic link and cp is trying to overwrite the directory with
> non-directory (symlink).
> 
> The fix is fine for both cases (xfstests as symlink and directory), confirmed
> with a simple test.
> 

Sorry for not showing the full story in changelog, but symbolic link is the point:

[root@kvm tmp]# ll XFStests 
lrwxrwxrwx 1 root root 32 Jan  1 09:48 XFStests -> /home/kvm_img/liub/xfstests-dev/

thanks,
liubo

> Thanks!
> -Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
