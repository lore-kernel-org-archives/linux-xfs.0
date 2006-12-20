Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 07:46:01 -0800 (PST)
Received: from mail.atipa.com (125.14.cm.sunflower.com [24.124.14.125])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBKFjuqw010469
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 07:45:58 -0800
Message-ID: <45895A80.4010402@atipa.com>
Date: Wed, 20 Dec 2006 09:45:04 -0600
From: Roger Heflin <rheflin@atipa.com>
MIME-Version: 1.0
Subject: Re: Issues with XFS on Sles9 sp2.
References: <45704570.7020209@atipa.com> <20061203224832.GY37654165@melbourne.sgi.com> <457431B1.20700@atipa.com> <20061204224208.GO33919298@melbourne.sgi.com> <4574AA4F.4030902@atipa.com> <20061205004416.GU33919298@melbourne.sgi.com>
In-Reply-To: <20061205004416.GU33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

David,

I have a bit more data on this hang up.

So far we have not been able to reproduce it with any test
other applications.

It so far will only duplicate with one certain application and
the trace from that application shows something interesting:

<Oct/27 07:40 am>acuSolve-gmpi D 00000000000493e0 0 14418 1 14419 16873 
(NOTLB)
<Oct/27 07:40 am>Call 
Trace:<ffffffff80165ad4>{wait_on_page_writeback_range_wq+324}
<Oct/27 07:40 am> <ffffffff8010f9c8>{__down+152} 
<ffffffff80135c50>{default_wake_function+0}
<Oct/27 07:40 am> <ffffffff80234447>{__down_failed+53} 
<ffffffff801949dc>{.text.lock.super+169}
<Oct/27 07:40 am> <ffffffff8018fcea>{do_sync+42} 
<ffffffff8018fd5e>{sys_sync+62}
<Oct/27 07:40 am> <ffffffff80110794>{system_call+124}

<Oct/27 07:40 am>acuSolve-gmpi D 00000000000493e0 0 14419 1 18864 14418 
(NOTLB)
<Oct/27 07:40 am>Call Trace:<ffffffff8010f9c8>{__down+152} 
<ffffffff80135c50>{default_wake_function+0}
<Oct/27 07:40 am> <ffffffff80234447>{__down_failed+53} 
<ffffffffa0141642>{:xfs:.text.lock.xfs_buf+15}
<Oct/27 07:40 am> <ffffffffa0126618>{:xfs:xfs_getsb+40} 
<ffffffffa012ecea>{:xfs:xfs_syncsub+2602}
<Oct/27 07:40 am> <ffffffffa013e468>{:xfs:vfs_sync+40} 
<ffffffffa013d434>{:xfs:linvfs_sync_super+68}
<Oct/27 07:40 am> <ffffffff80193cff>{sync_filesystems+223} 
<ffffffff8018fcf1>{do_sync+49}
<Oct/27 07:40 am> <ffffffff8018fd5e>{sys_sync+62} 
<ffffffff80110794>{system_call+124}

Both copies of the application appear to be calling sys_sync at the same 
time,
and each one is hung in a different part of the sys_sync call, I wonder 
if there
is a deadlock condition possible if one is doing this sort of thing?

All other processes are always running on the machines, these 2 process 
are the extra
ones that appear to be required to get the xfs lockup condition.  Other 
application
process have never reproduced the issue, so it is likely that something that
these 2 processes are doing is required to cause the deadlock condition.

Both processes are trying to get locks and failing, if I look at the 
other processes
that are working with locks I see:

<Oct/27 07:40 am>Call Trace:<ffffffffa0141832>{:xfs:kmem_zone_zalloc+50} 
<ffffffffa012a9c4>{:xfs:_xfs_trans_alloc+36}
<Oct/27 07:40 am> <ffffffff80231b35>{__down_write+117} 
<ffffffffa0116ead>{:xfs:xfs_ilock+93}
<Oct/27 07:40 am> <ffffffffa012eda3>{:xfs:xfs_syncsub+2787} 
<ffffffff80146970>{del_timer_sync+80}


<Oct/27 07:40 am> <ffffffff80135c50>{default_wake_function+0} 
<ffffffff80234447>{__down_failed+53}
<Oct/27 07:40 am> <ffffffffa0141642>{:xfs:.text.lock.xfs_buf+15} 
<ffffffffa0126618>{:xfs:xfs_getsb+40}
<Oct/27 07:40 am> <ffffffffa012b8aa>{:xfs:xfs_trans_getsb+106} 
<ffffffffa012a10c>{:xfs:xfs_trans_commit+332}


<Oct/27 07:40 am> <ffffffffa012b37b>{:xfs:xfs_trans_log_buf+107} 
<ffffffff80234447>{__down_failed+53}
<Oct/27 07:40 am> <ffffffffa0141642>{:xfs:.text.lock.xfs_buf+15} 
<ffffffffa0126618>{:xfs:xfs_getsb+40}
<Oct/27 07:40 am> <ffffffffa012b8aa>{:xfs:xfs_trans_getsb+106} 
<ffffffffa012a10c>{:xfs:xfs_trans_commit+332}


<Oct/27 07:40 am> <ffffffffa013194f>{:xfs:xfs_create+1359} 
<ffffffffa013b429>{:xfs:linvfs_mknod+521}
<Oct/27 07:40 am> <ffffffffa0116d16>{:xfs:xfs_iunlock+102} 
<ffffffffa0133387>{:xfs:xfs_lookup+119}
<Oct/27 07:40 am> <ffffffffa013b704>{:xfs:linvfs_lookup+84} 
<ffffffff8019c49b>{real_lookup+123}


<Oct/27 07:40 am> <ffffffff8010f9c8>{__down+152} 
<ffffffff80135c50>{default_wake_function+0}
<Oct/27 07:40 am> <ffffffff80234447>{__down_failed+53} 
<ffffffff801949dc>{.text.lock.super+169}
<Oct/27 07:40 am> <ffffffff8018fcea>{do_sync+42} 
<ffffffff8018fd5e>{sys_sync+62}


<Oct/27 07:40 am>Call Trace:<ffffffff8010f9c8>{__down+152} 
<ffffffff80135c50>{default_wake_function+0}
<Oct/27 07:40 am> <ffffffff80234447>{__down_failed+53} 
<ffffffffa0141642>{:xfs:.text.lock.xfs_buf+15}
<Oct/27 07:40 am> <ffffffffa0126618>{:xfs:xfs_getsb+40} 
<ffffffffa012ecea>{:xfs:xfs_syncsub+2602}

It very much looks like a deadlock as almost everyone hung looks to be 
working/waiting for locks.

Is there a way to list the kernel locks and see who is holding what locks?

                                Roger

Full Trace follows:

<Oct/27 07:40 am>xfssyncd D 00000000000493e0 0 2760 1 3876 2755 (L-TLB)
<Oct/27 07:40 am>Call Trace:<ffffffffa0141832>{:xfs:kmem_zone_zalloc+50} 
<ffffffffa012a9c4>{:xfs:_xfs_trans_alloc+36}
<Oct/27 07:40 am> <ffffffff80231b35>{__down_write+117} 
<ffffffffa0116ead>{:xfs:xfs_ilock+93}
<Oct/27 07:40 am> <ffffffffa012eda3>{:xfs:xfs_syncsub+2787} 
<ffffffff80146970>{del_timer_sync+80}
<Oct/27 07:40 am> <ffffffff80146a55>{del_singleshot_timer_sync+21} 
<ffffffff80146d2e>{schedule_timeout+254}
<Oct/27 07:40 am> <ffffffffa013e468>{:xfs:vfs_sync+40} 
<ffffffffa013da79>{:xfs:vfs_sync_worker+25}
<Oct/27 07:40 am> <ffffffffa013dc1a>{:xfs:xfssyncd+378} 
<ffffffffa013d780>{:xfs:linvfs_fill_super+0}
<Oct/27 07:40 am> <ffffffff801112b7>{child_rip+8} 
<ffffffffa013d780>{:xfs:linvfs_fill_super+0}
<Oct/27 07:40 am> <ffffffffa013daa0>{:xfs:xfssyncd+0} 
<ffffffff801112af>{child_rip+0}
<Oct/27 07:40 am>

<Oct/27 07:40 am>res D 000000000000000a 0 16149 1 26319 16151 5825 (NOTLB)
<Oct/27 07:40 am>Call Trace:<ffffffff80231bcd>{__down_read+125} 
<ffffffffa01333dc>{:xfs:xfs_access+44}
<Oct/27 07:40 am> <ffffffffa013af44>{:xfs:linvfs_permission+20} 
<ffffffff8019c767>{permission+55}
<Oct/27 07:40 am> <ffffffff8019df1c>{link_path_walk+348} 
<ffffffff801a0706>{__user_walk_it+70}
<Oct/27 07:40 am> <ffffffff801974b0>{vfs_lstat+128} 
<ffffffff80122868>{do_page_fault+536}
<Oct/27 07:40 am> <ffffffff801975bf>{sys_newlstat+31} 
<ffffffff80111101>{error_exit+0}
<Oct/27 07:40 am> <ffffffff80110794>{system_call+124}



<Oct/27 07:40 am>sbatchd D 00000000000493e0 0 16151 1 12686 16149 (NOTLB)
<Oct/27 07:40 am>Call Trace:<ffffffff801a7b51>{dput+33} 
<ffffffff8019c2cd>{follow_mount+93}
<Oct/27 07:40 am> <ffffffff801a7b51>{dput+33} 
<ffffffff80231bcd>{__down_read+125}
<Oct/27 07:40 am> <ffffffffa01333dc>{:xfs:xfs_access+44} 
<ffffffffa013af44>{:xfs:linvfs_permission+20}
<Oct/27 07:40 am> <ffffffff8019c767>{permission+55} 
<ffffffff8018aeca>{sys_chdir+138}
<Oct/27 07:40 am> <ffffffff801a394c>{sys_select+1244} 
<ffffffff80110794>{system_call+124}
<Oct/27 07:40 am>

<Oct/27 07:40 am>gm_mapper D 000000000000000a 0 12686 1 16834 16151 (L-TLB)
<Oct/27 07:40 am>Call 
Trace:<ffffffffa012b37b>{:xfs:xfs_trans_log_buf+107} 
<ffffffff8010f9c8>{__down+152}
<Oct/27 07:40 am> <ffffffff80135c50>{default_wake_function+0} 
<ffffffff80234447>{__down_failed+53}
<Oct/27 07:40 am> <ffffffffa0141642>{:xfs:.text.lock.xfs_buf+15} 
<ffffffffa0126618>{:xfs:xfs_getsb+40}
<Oct/27 07:40 am> <ffffffffa012b8aa>{:xfs:xfs_trans_getsb+106} 
<ffffffffa012a10c>{:xfs:xfs_trans_commit+332}
<Oct/27 07:40 am> <ffffffffa00e7a9c>{:xfs:xfs_free_extent+204} 
<ffffffffa0111634>{:xfs:xfs_efd_init+68}
<Oct/27 07:40 am> <ffffffffa014179b>{:xfs:kmem_zone_alloc+75} 
<ffffffffa0141832>{:xfs:kmem_zone_zalloc+50}
<Oct/27 07:40 am> <ffffffffa011a9cd>{:xfs:xfs_itruncate_finish+557} 
<ffffffffa012aae9>{:xfs:xfs_trans_alloc+217}
<Oct/27 07:40 am> <ffffffff8011081d>{sysret_signal+28} 
<ffffffffa01300af>{:xfs:xfs_inactive+591}
<Oct/27 07:40 am> <ffffffff8011081d>{sysret_signal+28} 
<ffffffff80169f50>{__pagevec_free+32}
<Oct/27 07:40 am> <ffffffff8011081d>{sysret_signal+28} 
<ffffffffa013ebc8>{:xfs:vn_rele+72}
<Oct/27 07:40 am> <ffffffffa013d392>{:xfs:linvfs_clear_inode+18} 
<ffffffff801a9d3b>{clear_inode+155}
<Oct/27 07:40 am> <ffffffff801aa3f5>{generic_delete_inode+245} 
<ffffffff801a95ee>{iput+158}
<Oct/27 07:40 am> <ffffffff801a7cb5>{dput+389} 
<ffffffff8018d9de>{__fput+270}
<Oct/27 07:40 am> <ffffffff8018965e>{filp_close+126} 
<ffffffff8013f073>{put_files_struct+115}
<Oct/27 07:40 am> <ffffffff80140522>{do_exit+1010} 
<ffffffff801484b5>{__dequeue_signal+501}
<Oct/27 07:40 am> <ffffffff8011081d>{sysret_signal+28} 
<ffffffff80140fa8>{do_group_exit+232}
<Oct/27 07:40 am> <ffffffff8014ab37>{get_signal_to_deliver+1175} 
<ffffffff8011004b>{do_signal+1179}
<Oct/27 07:40 am> <ffffffff8010fc45>{do_signal+149} 
<ffffffffa02dbea0>{:gm:gm_linux_ioctl+0}
<Oct/27 07:40 am> <ffffffffa02dbf0a>{:gm:gm_linux_ioctl+106} 
<ffffffff801a2094>{sys_ioctl+1092}
<Oct/27 07:40 am> <ffffffff8011052d>{sys_rt_sigreturn+653} 
<ffffffff8011081d>{sysret_signal+28}
<Oct/27 07:40 am> <ffffffff80110adf>{ptregscall_common+103}


<Oct/27 07:40 am>lim D 000000000000000a 0 16834 1 16835 17594 12686 (NOTLB)
<Oct/27 07:40 am>Call Trace:<ffffffff80231bcd>{__down_read+125} 
<ffffffffa01333dc>{:xfs:xfs_access+44}
<Oct/27 07:40 am> <ffffffffa013af44>{:xfs:linvfs_permission+20} 
<ffffffff8019c767>{permission+55}
<Oct/27 07:40 am> <ffffffff8019df1c>{link_path_walk+348} 
<ffffffff801a0706>{__user_walk_it+70}
<Oct/27 07:40 am> <ffffffff801974b0>{vfs_lstat+128} 
<ffffffff80117ec4>{save_i387+148}
<Oct/27 07:40 am> <ffffffff8011018d>{do_signal+1501} 
<ffffffff801975bf>{sys_newlstat+31}
<Oct/27 07:40 am> <ffffffff80147d04>{sys_rt_sigaction+148} 
<ffffffff80110794>{system_call+124}
<Oct/27 07:40 am>

<Oct/27 07:40 am>pim D 00000000000493e0 0 16835 16834 16870 (NOTLB)
<Oct/27 07:40 am>Call 
Trace:<ffffffffa01412ad>{:xfs:xfs_buf_get_flags+877} 
<ffffffffa014179b>{:xfs:kmem_zone_alloc+75}
<Oct/27 07:40 am> <ffffffff8010f9c8>{__down+152} 
<ffffffff80135c50>{default_wake_function+0}
<Oct/27 07:40 am> <ffffffffa012b37b>{:xfs:xfs_trans_log_buf+107} 
<ffffffff80234447>{__down_failed+53}
<Oct/27 07:40 am> <ffffffffa0141642>{:xfs:.text.lock.xfs_buf+15} 
<ffffffffa0126618>{:xfs:xfs_getsb+40}
<Oct/27 07:40 am> <ffffffffa012b8aa>{:xfs:xfs_trans_getsb+106} 
<ffffffffa012a10c>{:xfs:xfs_trans_commit+332}
<Oct/27 07:40 am> <ffffffffa0104d26>{:xfs:xfs_dir2_createname+278} 
<ffffffffa0117d3d>{:xfs:xfs_ichgtime+301}
<Oct/27 07:40 am> <ffffffffa013194f>{:xfs:xfs_create+1359} 
<ffffffffa013b429>{:xfs:linvfs_mknod+521}
<Oct/27 07:40 am> <ffffffffa0116d16>{:xfs:xfs_iunlock+102} 
<ffffffffa0133387>{:xfs:xfs_lookup+119}
<Oct/27 07:40 am> <ffffffffa013b704>{:xfs:linvfs_lookup+84} 
<ffffffff8019c49b>{real_lookup+123}
<Oct/27 07:40 am> <ffffffff8019cedb>{vfs_create+251} 
<ffffffff8019f3a0>{open_namei+464}
<Oct/27 07:40 am> <ffffffff80189cc7>{filp_open+87} 
<ffffffff80189d8f>{sys_open+159}
<Oct/27 07:40 am> <ffffffff80189765>{sys_close+229} 
<ffffffff80110794>{system_call+124}
<Oct/27 07:40 am>

<Oct/27 07:40 am>elim.uptime D 00000000000493e0 0 16873 1 14418 18756 
(NOTLB)
<Oct/27 07:40 am>Call Trace:<ffffffff80231bcd>{__down_read+125} 
<ffffffffa01333dc>{:xfs:xfs_access+44}
<Oct/27 07:40 am> <ffffffffa013af44>{:xfs:linvfs_permission+20} 
<ffffffff8019c767>{permission+55}
<Oct/27 07:40 am> <ffffffff8019df1c>{link_path_walk+348} 
<ffffffff8019f2a1>{open_namei+209}
<Oct/27 07:40 am> <ffffffff80189cc7>{filp_open+87} 
<ffffffff80189d8f>{sys_open+159}
<Oct/27 07:40 am> <ffffffff80111101>{error_exit+0} 
<ffffffff80110794>{system_call+124}
<Oct/27 07:40 am>

<Oct/27 07:40 am>res D 00000000000493e0 0 14323 16149 26319 (NOTLB)
<Oct/27 07:40 am>Call Trace:<ffffffff80301c83>{inet_recvmsg+51} 
<ffffffff802b520a>{sock_aio_read+346}
<Oct/27 07:40 am> <ffffffff80231bcd>{__down_read+125} 
<ffffffffa01333dc>{:xfs:xfs_access+44}
<Oct/27 07:40 am> <ffffffffa013af44>{:xfs:linvfs_permission+20} 
<ffffffff8019c767>{permission+55}
<Oct/27 07:40 am> <ffffffff8019df1c>{link_path_walk+348} 
<ffffffff8019f27f>{open_namei+175}
<Oct/27 07:40 am> <ffffffff80189cc7>{filp_open+87} 
<ffffffff80189d8f>{sys_open+159}
<Oct/27 07:40 am> <ffffffff802b58a8>{sys_socket+104} 
<ffffffff80110794>{system_call+124}
<Oct/27 07:40 am>

<Oct/27 07:40 am>acuSolve-gmpi D 00000000000493e0 0 14418 1 14419 16873 
(NOTLB)
<Oct/27 07:40 am>Call 
Trace:<ffffffff80165ad4>{wait_on_page_writeback_range_wq+324}
<Oct/27 07:40 am> <ffffffff8010f9c8>{__down+152} 
<ffffffff80135c50>{default_wake_function+0}
<Oct/27 07:40 am> <ffffffff80234447>{__down_failed+53} 
<ffffffff801949dc>{.text.lock.super+169}
<Oct/27 07:40 am> <ffffffff8018fcea>{do_sync+42} 
<ffffffff8018fd5e>{sys_sync+62}
<Oct/27 07:40 am> <ffffffff80110794>{system_call+124}

<Oct/27 07:40 am>acuSolve-gmpi D 00000000000493e0 0 14419 1 18864 14418 
(NOTLB)
<Oct/27 07:40 am>Call Trace:<ffffffff8010f9c8>{__down+152} 
<ffffffff80135c50>{default_wake_function+0}
<Oct/27 07:40 am> <ffffffff80234447>{__down_failed+53} 
<ffffffffa0141642>{:xfs:.text.lock.xfs_buf+15}
<Oct/27 07:40 am> <ffffffffa0126618>{:xfs:xfs_getsb+40} 
<ffffffffa012ecea>{:xfs:xfs_syncsub+2602}
<Oct/27 07:40 am> <ffffffffa013e468>{:xfs:vfs_sync+40} 
<ffffffffa013d434>{:xfs:linvfs_sync_super+68}
<Oct/27 07:40 am> <ffffffff80193cff>{sync_filesystems+223} 
<ffffffff8018fcf1>{do_sync+49}
<Oct/27 07:40 am> <ffffffff8018fd5e>{sys_sync+62} 
<ffffffff80110794>{system_call+124}
<Oct/27 07:40 am>
<Oct/27 07:40 am>mktemp D 00000000000493e0 0 17594 1 17656 16834 (NOTLB)
<Oct/27 07:40 am>Call Trace:<ffffffff8025bbe9>{SHATransform+25} 
<ffffffff8019c2cd>{follow_mount+93}
<Oct/27 07:40 am> <ffffffff801a7b51>{dput+33} 
<ffffffff80231bcd>{__down_read+125}
<Oct/27 07:40 am> <ffffffffa01333dc>{:xfs:xfs_access+44} 
<ffffffffa013af44>{:xfs:linvfs_permission+20}
<Oct/27 07:40 am> <ffffffff8019c767>{permission+55} 
<ffffffff8019df1c>{link_path_walk+348}
<Oct/27 07:40 am> <ffffffff801a02ac>{sys_mkdir+220} 
<ffffffff80110794>{system_call+124}
<Oct/27 07:40 am>
<Oct/27 07:40 am>check_EWNstag D 00000000000493e0 0 17620 1 17751 17656 
(NOTLB)
<Oct/27 07:40 am>Call Trace:<ffffffff8018cbbd>{do_sync_write+173} 
<ffffffff80231bcd>{__down_read+125}
<Oct/27 07:40 am> <ffffffffa01333dc>{:xfs:xfs_access+44} 
<ffffffffa013af44>{:xfs:linvfs_permission+20}
<Oct/27 07:40 am> <ffffffff8019c767>{permission+55} 
<ffffffff8019df1c>{link_path_walk+348}
<Oct/27 07:40 am> <ffffffff8019f2a1>{open_namei+209} 
<ffffffff80189cc7>{filp_open+87}
<Oct/27 07:40 am> <ffffffff80189d8f>{sys_open+159} 
<ffffffff80111101>{error_exit+0}
<Oct/27 07:40 am> <ffffffff80110794>{system_call+124} <Oct/27 07:40 am>
<Oct/27 07:40 am>
<Oct/27 07:40 am>sh D 00000000000493e0 0 17959 1 17793 17858 (NOTLB)
<Oct/27 07:40 am>Call Trace:<ffffffff80231bcd>{__down_read+125} 
<ffffffffa01333dc>{:xfs:xfs_access+44}
<Oct/27 07:40 am> <ffffffffa013af44>{:xfs:linvfs_permission+20} 
<ffffffff8019c767>{permission+55}
<Oct/27 07:40 am> <ffffffff8019df1c>{link_path_walk+348} 
<ffffffff8019f2a1>{open_namei+209}
<Oct/27 07:40 am> <ffffffff80189cc7>{filp_open+87} 
<ffffffff80189d8f>{sys_open+159}
<Oct/27 07:40 am> <ffffffff80111101>{error_exit+0} 
<ffffffff80110794>{system_call+124}
<Oct/27 07:40 am>
