Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6OCq12m128707 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 07:52:01 -0500
Subject: Re: umount xfs filesystem
References: <4A66C5E7.7050408@readytec.it>
From: Olaf Weber <olaf@sgi.com>
Date: Fri, 24 Jul 2009 14:52:42 +0200
In-Reply-To: <4A66C5E7.7050408@readytec.it> (Daniele Nuzzo's message of "Wed,
	22 Jul 2009 09:55:19 +0200")
Message-ID: <bzytz12kztx.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
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
To: Daniele Nuzzo - Readytec SPA <d.nuzzo@readytec.it>
Cc: xfs@oss.sgi.com

Daniele Nuzzo writes:

> hi,
> I think I need your advice-opinion ...
> I set up a system like CentOS 5.3, lvm, drbd 8.2, various systems raid
> (Adaptec aacraid or LSI MegaRAID with or without write back cache)
> after some time of work (a few hours or days) do the umount is
> slow... even a few minutes ... why?
> I have already disabled barrier and write cache on drbd, but not on
> the controller or the sas  drives... ideas?
> thanks a lot.

> p.s.
> drbd partitions formatted with the default options.

On unmount the system has flush all dirty data to disk.  Depending on
the amount of data in memory, this might take a while.

I'm not claiming this is definitely the case here, but it is an
obvious candidate.

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
