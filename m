Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D2D647F7C
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 12:42:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F94AAC008
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 10:42:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MHvY7UyW2wNa6qUK for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 10:42:16 -0700 (PDT)
Message-ID: <544FD577.9040605@sandeen.net>
Date: Tue, 28 Oct 2014 12:42:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Kernel crashes with trace ending in XFS code on RHEL6 variant
	kernel
References: <CA+tQb7GSvkgsxZT2awAkMjh9wY6JXBygLoenTrtFtmRMSVwuUA@mail.gmail.com>
In-Reply-To: <CA+tQb7GSvkgsxZT2awAkMjh9wY6JXBygLoenTrtFtmRMSVwuUA@mail.gmail.com>
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
To: Jan Kokoska <jan@glow.cz>, xfs@oss.sgi.com

On 10/28/14 10:38 AM, Jan Kokoska wrote:
> Hi,
> 
> I'm running OpenVZ (OS container) kernel variant of RHEL6 kernel on

... for which we have no source code? ;)

I don't know what's in "2.6.32-openvz-amd64" so can't help much.

What is at line 86 of xfs_aops.c in that kernel?

-Eric

> several amd64 machines by different manufacturers (HP and Supermicro)
> and different RAID cards (HP and Areca).
> 
> I've started seeing kernel crashes in October, as per the netconsole
> logs attached, on two of the machines (one HP, one Supermicro). The
> traces look quite similar, the machine in question cannot write
> anything to its own filesystem when this happens so the logs are made
> over the network. The XFS filesystem is not root (that's ext4), but
> one for data (OS containers), on both machines. When I run xfs_check
> and xfs_repair on the filesystem after the kernel crash & reboot, no
> issue is ever found.
> 
> This may very well have nothing to do with XFS kernel code you wrote
> and maintain, but in that case, could you, from looking at the traces,
> tell me whether it maybe looks like something issue related to
> vm/paging just ending up in XFS related code path?
> 
> I'm happy to test any suggestions/fixes for this if it is XFS related.
> 
> Thank you,
> -- 
> Jan Kokoska
> Glow Internet s.r.o.
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
