Return-Path: <lists@ku-gbr.de>
Date: Fri, 13 Jun 2008 09:15:53 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
Subject: Re: [xfs-masters] Re: XFS internal error xfs_trans_cancel at line
	1163 of file fs/xfs/xfs_trans.c
Message-ID: <20080613071553.GA3465@anita>
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <4851A20D.4070904@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4851A20D.4070904@sandeen.net>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com
List-ID: <xfs>

Now I got ksymoops output:

~/ > ksymoops -m /boot/System.map xfs_break1.txt
ksymoops 2.4.11 on x86_64 2.6.25-gentoo-r4.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.25-gentoo-r4/ (default)
     -m /boot/System.map (specified)

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Jun 12 07:23:40 zappa Pid: 2379, comm: procmail Not tainted 2.6.25-gentoo-r4 #3
Jun 12 07:23:40 zappa Call Trace:
Jun 12 07:23:40 zappa [<ffffffff802fa8f5>]
Jun 12 07:23:40 zappa [<ffffffff802f4d71>]
Jun 12 07:23:40 zappa [<ffffffff802fa8f5>]
Jun 12 07:23:40 zappa [<ffffffff803038bb>]
Jun 12 07:23:40 zappa [<ffffffff8025f1e1>]
Jun 12 07:23:40 zappa [<ffffffff80261899>]
Jun 12 07:23:40 zappa [<ffffffff8025ae00>]
Jun 12 07:23:40 zappa [<ffffffff80257010>]
Jun 12 07:23:40 zappa [<ffffffff80256d92>]
Jun 12 07:23:40 zappa [<ffffffff80257077>]
Jun 12 07:23:40 zappa [<ffffffff8020ad3b>]
Warning (Oops_read): Code line not seen, dumping what data is available


Trace; ffffffff802fa8f5 <xfs_create+44f/493>
Trace; ffffffff802f4d71 <xfs_trans_cancel+5c/f4>
Trace; ffffffff802fa8f5 <xfs_create+44f/493>
Trace; ffffffff803038bb <xfs_vn_mknod+15f/249>
Trace; ffffffff8025f1e1 <vfs_create+75/ba>
Trace; ffffffff80261899 <open_namei+19d/608>
Trace; ffffffff8025ae00 <vfs_lstat_fd+18/47>
Trace; ffffffff80257010 <do_filp_open+1c/3d>
Trace; ffffffff80256d92 <get_unused_fd_flags+6d/100>
Trace; ffffffff80257077 <do_sys_open+46/ca>
Trace; ffffffff8020ad3b <system_call_after_swapgs+7b/80>


1 warning and 1 error issued.  Results may not be reliable.





~/ > ksymoops -m /boot/System.map xfs_break2.txt
ksymoops 2.4.11 on x86_64 2.6.25-gentoo-r4.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.25-gentoo-r4/ (default)
     -m /boot/System.map (specified)

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Jun 12 08:15:58 zappa Pid: 2161, comm: procmail Not tainted 2.6.25-gentoo-r4 #3
Jun 12 08:15:58 zappa Call Trace:
Jun 12 08:15:58 zappa [<ffffffff802fa8f5>]
Jun 12 08:15:58 zappa [<ffffffff802f4d71>]
Jun 12 08:15:58 zappa [<ffffffff802fa8f5>]
Jun 12 08:15:58 zappa [<ffffffff803038bb>]
Jun 12 08:15:58 zappa [<ffffffff8025f1e1>]
Jun 12 08:15:58 zappa [<ffffffff80261899>]
Jun 12 08:15:58 zappa [<ffffffff8025ae00>]
Jun 12 08:15:58 zappa [<ffffffff80257010>]
Jun 12 08:15:58 zappa [<ffffffff80256d92>]
Jun 12 08:15:58 zappa [<ffffffff80257077>]
Jun 12 08:15:58 zappa [<ffffffff8020ad3b>]
Warning (Oops_read): Code line not seen, dumping what data is available


Trace; ffffffff802fa8f5 <xfs_create+44f/493>
Trace; ffffffff802f4d71 <xfs_trans_cancel+5c/f4>
Trace; ffffffff802fa8f5 <xfs_create+44f/493>
Trace; ffffffff803038bb <xfs_vn_mknod+15f/249>
Trace; ffffffff8025f1e1 <vfs_create+75/ba>
Trace; ffffffff80261899 <open_namei+19d/608>
Trace; ffffffff8025ae00 <vfs_lstat_fd+18/47>
Trace; ffffffff80257010 <do_filp_open+1c/3d>
Trace; ffffffff80256d92 <get_unused_fd_flags+6d/100>
Trace; ffffffff80257077 <do_sys_open+46/ca>
Trace; ffffffff8020ad3b <system_call_after_swapgs+7b/80>


1 warning and 1 error issued.  Results may not be reliable.


Regards, Konsti


PS.: The line xfs_check puttedt out was: "agi_freecount 1, counted 0 in ag17"
After xfs_repair'ing the message vanished, the result left no files in lost+found 
and seemed to have fixed this, the filesystem is up and running (for a
while :-) ) now.

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
