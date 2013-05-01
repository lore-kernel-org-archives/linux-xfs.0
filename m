Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1256929DF8
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 09:43:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5D99304066
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 07:43:51 -0700 (PDT)
Received: from na3sys009aog103.obsmtp.com (na3sys009aog103.obsmtp.com
	[74.125.149.71]) by cuda.sgi.com with SMTP id FAcsGTL9Znv8mQR6
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 May 2013 07:43:50 -0700 (PDT)
Received: by mail-ob0-f198.google.com with SMTP id tb18so8339115obb.1
	for <xfs@oss.sgi.com>; Wed, 01 May 2013 07:43:47 -0700 (PDT)
Date: Wed, 1 May 2013 09:43:41 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: deadlock on vmap_area_lock
Message-ID: <20130501144341.GA2404@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org

I've got two compute clusters with around 350 machines each which are
running kernels based off of 3.1.9 (Yes I realize this is ancient by
todays standards).  All of the machines run a 'find' command once an
hour on one of the mounted XFS filesystems.  Occasionally these find
commands get stuck requiring a reboot of the system.  I took a peek
today and see this with perf:

    72.22%          find  [kernel.kallsyms]          [k] _raw_spin_lock
                    |
                    --- _raw_spin_lock
                       |          
                       |--98.84%-- vm_map_ram
                       |          _xfs_buf_map_pages
                       |          xfs_buf_get
                       |          xfs_buf_read
                       |          xfs_trans_read_buf
                       |          xfs_da_do_buf
                       |          xfs_da_read_buf
                       |          xfs_dir2_block_getdents
                       |          xfs_readdir
                       |          xfs_file_readdir
                       |          vfs_readdir
                       |          sys_getdents
                       |          system_call_fastpath
                       |          __getdents64
                       |          
                       |--1.12%-- _xfs_buf_map_pages
                       |          xfs_buf_get
                       |          xfs_buf_read
                       |          xfs_trans_read_buf
                       |          xfs_da_do_buf
                       |          xfs_da_read_buf
                       |          xfs_dir2_block_getdents
                       |          xfs_readdir
                       |          xfs_file_readdir
                       |          vfs_readdir
                       |          sys_getdents
                       |          system_call_fastpath
                       |          __getdents64
                        --0.04%-- [...]

Looking at the code my best guess is that we are spinning on
vmap_area_lock, but I could be wrong.  This is the only process
spinning on the machine so I'm assuming either another process has
blocked while holding the lock, or perhaps this find process has tried
to acquire the vmap_area_lock twice?

I've skimmed through the change logs between 3.1 and 3.9 but nothing
stood out as fix for this bug.  Does this ring a bell with anyone?  If
I have a machine that is currently in one of these stuck states does
anyone have any tips to identifying the processes currently holding
the lock?

Additionally as I mentioned before I have two clusters of roughly
equal size though one cluster hits this issue more frequently.  On
that cluster with approximately 350 machines we get about 10 stuck
machines a month.  The other cluster has about 450 machines but we
only get about 1 or 2 stuck machines a month.  Both clusters run the
same find command every hour, but the workloads on the machines are
different.  The cluster that hits the issue more frequently tends to
run more memory intensive jobs.

I'm open to building some debug kernels to help track this down,
though I can't upgrade all of the machines in one shot so it may take
a while to reproduce.  I'm happy to provide any other information if
people have questions.

Thanks,
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
