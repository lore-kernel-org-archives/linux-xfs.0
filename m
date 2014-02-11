Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA3C87F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 15:07:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48465AC013
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 13:07:06 -0800 (PST)
Received: from mail-qc0-f170.google.com (mail-qc0-f170.google.com
	[209.85.216.170]) by cuda.sgi.com with ESMTP id
	1kns5igzOqXwiVW5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 13:07:04 -0800 (PST)
Received: by mail-qc0-f170.google.com with SMTP id e9so14040550qcy.15
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 13:07:03 -0800 (PST)
Received: from [192.168.123.135] (c-71-236-220-78.hsd1.wa.comcast.net.
	[71.236.220.78])
	by mx.google.com with ESMTPSA id u20sm30457584qge.2.2014.02.11.13.07.02
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Tue, 11 Feb 2014 13:07:02 -0800 (PST)
Message-ID: <52FA90EA.9080107@codyps.com>
Date: Tue, 11 Feb 2014 13:06:50 -0800
From: Cody P Schafer <dev@codyps.com>
MIME-Version: 1.0
Subject: Re: xfs_repair fails to repair, run under valgrind shows "Invalid
	read..." and XFS_CORRUPTION_ERROR
References: <52FA8021.9050604@linux.vnet.ibm.com>
	<20140211204331.GL13647@dastard>
In-Reply-To: <20140211204331.GL13647@dastard>
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
To: xfs@oss.sgi.com

On 02/11/2014 12:43 PM, Dave Chinner wrote:
> On Tue, Feb 11, 2014 at 11:55:13AM -0800, Cody P Schafer wrote:
>> xfsprogs version: v3.2.0-alpha2-14-g6e79202
>>
>> uname: Linux hostname 3.11.10-301.fc20.ppc64 #1 SMP Tue Dec 10
>> 00:35:15 MST 2013 ppc64 POWER8 (architected), altivec supported CHRP
>> IBM,8286-42A GNU/Linux
>>
>> full log attached.
>
>>
>> syncop8lp7 xfsprogs # valgrind ./repair/xfs_repair -n /dev/sda5
> .....
>
> Runs fine becuase it doesn't try to fix and write changes.
>
>> ==6601== Memcheck, a memory error detector
>> ==6601== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et al.
>> ==6601== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright info
>> ==6601== Command: ./repair/xfs_repair -n /dev/sda5
>> ==6601==
>> --6601-- WARNING: Serious error when reading debug info
>> --6601-- When reading debug info from /usr/lib64/valgrind/memcheck-ppc64-linux:
>
> Ok, so you're on ppc64. Big endian or little endian?
>

Big endian.

>> syncop8lp7 xfsprogs # valgrind ./repair/xfs_repair /dev/sda5
> ....
>
>> resetting inode 67687581 nlinks from 4 to 3
>> xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
>> libxfs_writebufr: write verifer failed on bno 0x3239040/0x1000
>> Invalid inode number 0xfeffffffffffffff
>
> That's the smoking gun - the dirents in the rebuilt directory have
> invalid inode numbers. They all have the same invalid inode number,
> which indicates a bug in the directory reconstruction.
>
> Can you provide a metadump of the broken filesystem to one of us fo
> deeper inspection?
>

Sure:
http://turntable.einic.org/~cody/sda5-2.meta

> FWIW, the write verifiers have once again done their job - catching
> corruptions caused by software bugs and preventing them from causing
> further corruption to the filesystem...
>
>> libxfs_writebufr: write verifer failed on bno 0x3298f38/0x1000
>> ==6700== Syscall param pwrite64(buf) points to uninitialised byte(s)
>> ==6700==    at 0x40F810C: pwrite64 (pwrite64.c:51)
>> ==6700==    by 0x1003ABDB: __write_buf (rdwr.c:801)
>> ==6700==    by 0x1003C1B7: libxfs_writebufr (rdwr.c:863)
>> ==6700==    by 0x10036C4F: cache_flush (cache.c:600)
>> ==6700==    by 0x1003C77B: libxfs_bcache_flush (rdwr.c:994)
>> ==6700==    by 0x10004C6B: main (xfs_repair.c:886)
>> ==6700==  Address 0xbeb0622 is 34 bytes inside a block of size 4,096 alloc'd
>> ==6700==    at 0x406631C: memalign (in /usr/lib64/valgrind/vgpreload_memcheck-ppc64-linux.so)
>> ==6700==    by 0x1003ADEF: __initbuf (rdwr.c:367)
>> ==6700==    by 0x1003B797: libxfs_getbufr_map (rdwr.c:416)
>> ==6700==    by 0x100365C3: cache_node_get (cache.c:273)
>> ==6700==    by 0x1003A8DB: __cache_lookup (rdwr.c:519)
>> ==6700==    by 0x1003BA6F: libxfs_getbuf_map (rdwr.c:601)
>> ==6700==    by 0x1003D333: libxfs_trans_get_buf_map (trans.c:525)
>> ==6700==    by 0x10059A3B: xfs_da_get_buf (xfs_da_btree.c:2580)
>> ==6700==    by 0x10060E27: xfs_dir3_data_init (xfs_dir2_data.c:558)
>> ==6700==    by 0x1006407F: xfs_dir2_leaf_addname (xfs_dir2_leaf.c:826)
>> ==6700==    by 0x1005D59B: xfs_dir_createname (xfs_dir2.c:233)
>> ==6700==    by 0x100290D3: mv_orphanage (phase6.c:1205)
>
> And that looks kinda related. This has been triggered by the write
> of a directory buffer that was created during lost+found processing,
> and is a prime candidate for incorrect reconstruction. What is the
> head commit of the repo you built this xfs_repair binary from, and
> what version of gcc did you use?

>> xfsprogs version: v3.2.0-alpha2-14-g6e79202
full hash: 6e79202b24ed0dc9ddd8f02e0506182cc6587258

gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5)

>
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
