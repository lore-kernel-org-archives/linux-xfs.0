Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 104627F37
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 14:40:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DCB7B304064
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 12:40:01 -0800 (PST)
Received: from mail-pd0-f170.google.com (mail-pd0-f170.google.com
	[209.85.192.170]) by cuda.sgi.com with ESMTP id
	WqmVZjP52pBSL0XG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 12:39:57 -0800 (PST)
Received: by mail-pd0-f170.google.com with SMTP id q10so939992pdj.15
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 12:39:57 -0800 (PST)
Message-ID: <5283E387.70704@gmail.com>
Date: Thu, 14 Nov 2013 05:39:35 +0900
From: Ric Wheeler <ricwheeler@gmail.com>
MIME-Version: 1.0
Subject: Re: Files not touched in weeks got truncated after a crash
References: <2662179.4mj0dgORXu@r008>
In-Reply-To: <2662179.4mj0dgORXu@r008>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Guido Winkelmann <guido@ambient-entertainment.de>, xfs@oss.sgi.com

You should update your kernel - this sounds like an issue that Dave fixed quite 
a few months back (and got shipped in RHEL and other distros, I don't know about 
when Centos would pick it up)

Ric


On 11/14/2013 01:36 AM, Guido Winkelmann wrote:
> Hi,
>
> We are having some trouble with one of our fileservers using XFS (on linux).
> Yesterday, one of the external RAIDs on the server failed. Of course, it is
> unavoidable that some data would get lost from the fileserver in such an
> event, however, we lost a lot more files than would seem reasonable. In
> particular, we lost a number of files that had not been written to (but had
> been been read from, in some cases) in several weeks.
>
> The data loss manifested itself through files being truncated to length 0 or
> to some other size short of what they should be. (We happen to have an
> external database that keeps track of that.)
>
> The fileserver is based on CentOS 6.3 with kernel version
> 2.6.32-279.9.1.el6.x86_64. It has got several external RAIDs in the 100 TB
> range, connected via FibreChannel.
>
> In case it matters: The server's primary role is as a samba server servicing a
> large number of Windows XP and Windows 7 machines.
>
> We had already been trying to reduce the possible impact of a hardware failure
> by setting a few tunables in /etc/sysctl.conf to try and make the kernel not
> keep dirty buffers around too long:
>
> vm.dirty_background_bytes = 536870912
> vm.dirty_bytes = 134217728
> vm.dirty_writeback_centisecs = 500
> vm.dirty_expire_centisecs = 3000
>
> and by issuing a sync from cron every 15 minutes:
>
> 0,15,30,45 * * * * /bin/sync
>
> Unfortunately, I seem to be unable so far to reproduce the issue on a smaller
> system - and I cannot exactly just walk up to the in-production fileserver and
> rip out yet another array just to see what happens...
>
> This leaves me with a few questions:
>
> Why did we lose so much data through the crash?
>
> Why did not even a sync every 15 minutes prevent further damage?
>
> What can we do to prevent this from happening again in the future?
>
> Regards,
>
> 	Guido
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
