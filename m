Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 22:44:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5K5iGxm015668
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 22:44:16 -0700
Date: Fri, 20 Jun 2008 07:45:04 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080620054504.GA2075@anita>
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <1213309629.29745.8.camel@localhost.localdomain> <20080613030841.GC3700@disturbed> <20080620052716.GA2022@anita>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620052716.GA2022@anita>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miquel van Smoorenburg <mikevs@xs4all.net>, Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com

Again. Before strace looks weird, this looks like the old one:

ksymoops 2.4.11 on x86_64 2.6.26-rc6.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.26-rc6/ (default)
     -m /usr/src/linux-2.6.26-rc6/System.map (specified)

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Pid: 2137, comm: fetchnews Not tainted 2.6.26-rc6 #1
Call Trace:
 [<ffffffff802ffa42>]
 [<ffffffff802fa35a>]
 [<ffffffff802ffa42>]
 [<ffffffff80308a29>]
 [<ffffffff80262799>]
 [<ffffffff8026500a>]
 [<ffffffff80223506>]
 [<ffffffff8023116c>]
 [<ffffffff8025a0fa>]
 [<ffffffff8020afab>]
Warning (Oops_read): Code line not seen, dumping what data is available


Trace; ffffffff802ffa42 <xfs_create+41d/462>
Trace; ffffffff802fa35a <xfs_trans_cancel+56/ee>
Trace; ffffffff802ffa42 <xfs_create+41d/462>
Trace; ffffffff80308a29 <xfs_vn_mknod+148/229>
Trace; ffffffff80262799 <vfs_create+75/ba>
Trace; ffffffff8026500a <do_filp_open+1dc/7c5>
Trace; ffffffff80223506 <ns_to_timeval+9/27>
Trace; ffffffff8023116c <__remove_hrtimer+6b/78>
Trace; ffffffff8025a0fa <do_sys_open+4a/f1>
Trace; ffffffff8020afab <system_call_after_swapgs+7b/80>


1 warning and 1 error issued.  Results may not be reliable.


-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
