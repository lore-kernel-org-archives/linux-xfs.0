Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A85497F76
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 10:57:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96025304064
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 08:57:41 -0700 (PDT)
Received: from mail-pa0-f45.google.com (mail-pa0-f45.google.com
	[209.85.220.45]) by cuda.sgi.com with ESMTP id SLj1J1G7uFl7rDbF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 May 2013 08:57:40 -0700 (PDT)
Received: by mail-pa0-f45.google.com with SMTP id lf10so926370pab.32
	for <xfs@oss.sgi.com>; Wed, 01 May 2013 08:57:39 -0700 (PDT)
Date: Wed, 1 May 2013 08:57:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
Subject: Re: deadlock on vmap_area_lock
In-Reply-To: <20130501144341.GA2404@BohrerMBP.rgmadvisors.com>
Message-ID: <alpine.DEB.2.02.1305010855440.4547@chino.kir.corp.google.com>
References: <20130501144341.GA2404@BohrerMBP.rgmadvisors.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, 1 May 2013, Shawn Bohrer wrote:

> I've got two compute clusters with around 350 machines each which are
> running kernels based off of 3.1.9 (Yes I realize this is ancient by
> todays standards).  All of the machines run a 'find' command once an
> hour on one of the mounted XFS filesystems.  Occasionally these find
> commands get stuck requiring a reboot of the system.  I took a peek
> today and see this with perf:
> 
>     72.22%          find  [kernel.kallsyms]          [k] _raw_spin_lock
>                     |
>                     --- _raw_spin_lock
>                        |          
>                        |--98.84%-- vm_map_ram
>                        |          _xfs_buf_map_pages
>                        |          xfs_buf_get
>                        |          xfs_buf_read
>                        |          xfs_trans_read_buf
>                        |          xfs_da_do_buf
>                        |          xfs_da_read_buf
>                        |          xfs_dir2_block_getdents
>                        |          xfs_readdir
>                        |          xfs_file_readdir
>                        |          vfs_readdir
>                        |          sys_getdents
>                        |          system_call_fastpath
>                        |          __getdents64
>                        |          
>                        |--1.12%-- _xfs_buf_map_pages
>                        |          xfs_buf_get
>                        |          xfs_buf_read
>                        |          xfs_trans_read_buf
>                        |          xfs_da_do_buf
>                        |          xfs_da_read_buf
>                        |          xfs_dir2_block_getdents
>                        |          xfs_readdir
>                        |          xfs_file_readdir
>                        |          vfs_readdir
>                        |          sys_getdents
>                        |          system_call_fastpath
>                        |          __getdents64
>                         --0.04%-- [...]
> 
> Looking at the code my best guess is that we are spinning on
> vmap_area_lock, but I could be wrong.  This is the only process
> spinning on the machine so I'm assuming either another process has
> blocked while holding the lock, or perhaps this find process has tried
> to acquire the vmap_area_lock twice?
> 

Significant spinlock contention doesn't necessarily mean that there's a 
deadlock, but it also doesn't mean the opposite.  Depending on your 
definition of "occassionally", would it be possible to run with 
CONFIG_PROVE_LOCKING and CONFIG_LOCKDEP to see if it uncovers any real 
deadlock potential?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
