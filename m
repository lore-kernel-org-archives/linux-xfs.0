Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC46C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 23:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiFVXIo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 19:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345283AbiFVXIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 19:08:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09184163D
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 16:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C55361B40
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 23:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF13DC341CC
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 23:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655939321;
        bh=7qX2c+8TK8jdkBOFtPRmDidTDluCalBepMoeeBNlqCU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DzONw2x+ZzudtcsVSipe31FdQw62Xm1cIzb6IipklpnW9rPGrcC4vkX+EPlDe9Tif
         jxAajuDY+llR97s8MX8rZ83fdkqZuWSsEGq9WWbC7oTh4XsYaDdSeXt4eiFtGVX+UR
         szWlbHkGGXIsFgeuTX/FD3pa74tRzZHOhwjLl+Bs8j6ir1g6Z+6pmZMd2sTs0+s8KH
         Vs7O4OswdfZ+/spp1rSPZuJlT4oNaUIKOk21BHNFIawbIibKpnTRINQ6ZU2o6UjIBr
         SoOo0JFS6ldvgd6zWU9IarCBjBL548DYuOY4sUZDDhbr58FiU5KozXXobQ3qLVO3g6
         RIlQfX+89JEqg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BF32FCC13B5; Wed, 22 Jun 2022 23:08:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216110] rmdir sub directory cause i_nlink of parent directory
 down from 0 to 0xffffffff
Date:   Wed, 22 Jun 2022 23:08:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216110-201763-A3JCWhOM3a@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216110-201763@https.bugzilla.kernel.org/>
References: <bug-216110-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216110

--- Comment #4 from Darrick J. Wong (djwong@kernel.org) ---
On Fri, Jun 10, 2022 at 08:27:38AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216110
>=20
>             Bug ID: 216110
>            Summary: rmdir sub directory cause i_nlink of parent directory
>                     down from 0 to 0xffffffff
>            Product: File System
>            Version: 2.5
>     Kernel Version: linux-3.10.0-957.el7

Please contact your RHEL7   ^^^^^^^^^^^^^^ account representative for
assistance in triaging this bug.

--D

>           Hardware: Other
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: hexiaole1994@126.com
>         Regression: No
>=20
> 1. synptom
> when user executed mkdir command under parent directory, mkdir command
> prompted
> "Too many links".
>=20
>=20
> 2. basic analysis
> (1)use "getconf LINK_MAX ." under parent directory, the max i_nlink of the
> xfs(the filesystem that parent directory belongs) is 2147483647, but the
> i_nlink of the parent directory now is 4294967109, because the mkdir comm=
and
> will check if the i_nlink of the parent directory is lower than the LINK_=
MAX,
> in our environment this check failed, so mkdir command prompt "Too many
> links".
> (2)we "cd" into the parent directory, and execute "ls|wc" to accounting t=
he
> total files of the parent directory, the result is 308875
> (3)the i_nlink by definition is "the number of links to the inode from
> directories", a newly created directory has i_nlink of 2, and the i_nlink=
 of
> this newly created directory will plus 1 once there has a sub directory
> created
> under it(the sub directory's ".." points to parent directory cause the
> i_nlink
> of the parent directory plus 1), so the i_nlink of the parent directory c=
an
> also reflect the number of the sub directories(the number of sub director=
y =3D
> i_nlink of the parent - 2). the i_nlink of the parent directory now is
> 4294967109, if this i_nlink is valid, the number of the sub directoryes m=
ight
> be 4294967109, but like the (2) shows, the total files(include directorie=
s)
> under the parent directory is 308875. so we can assert the i_nlink metada=
ta
> of
> the parent direcotry was corrupted.
> (4)in the dmesg file of the sos_report, we saw an call trace that related=
 to
> this corrupted i_nlink of parent directory:
> ...
> [26038585.616782] ------------[ cut here ]------------
> [26038585.616794] WARNING: CPU: 22 PID: 21088 at fs/inode.c:284
> drop_nlink+0x3e/0x50
> [26038585.616796] Modules linked in: binfmt_misc tcp_diag inet_diag 8021q
> garp
> mrp stp llc bonding vfat fat ipmi_ssif amd64_edac_mod edac_mce_amd kvm jo=
ydev
> irqbypass ses enclosure pcspkr scsi_transport_sas sg ipmi_si ipmi_devintf
> ipmi_msghandler i2c_piix4 acpi_cpufreq ip_tables xfs libcrc32c sd_mod
> crc_t10dif crct10dif_generic crct10dif_common ast crc32c_intel drm_kms_he=
lper
> syscopyarea sysfillrect igb ixgbe sysimgblt fb_sys_fops ttm i2c_algo_bit =
mdio
> ptp drm pps_core megaraid_sas dca drm_panel_orientation_quirks ahci libah=
ci
> libata nfit libnvdimm dm_mirror dm_region_hash dm_log dm_mod
> [26038585.616850] CPU: 22 PID: 21088 Comm: gbased Not tainted
> 3.10.0-957.el7.hg.3.x86_64 #1
> [26038585.616851] Hardware name: Sugon H620-G30/65N32-US, BIOS 0QL1001207
> 03/03/2021
> [26038585.616853] Call Trace:
> [26038585.616861]  [<ffffffff86161de9>] dump_stack+0x19/0x1b
> [26038585.616866]  [<ffffffff85a976c8>] __warn+0xd8/0x100
> [26038585.616868]  [<ffffffff85a9780d>] warn_slowpath_null+0x1d/0x20
> [26038585.616870]  [<ffffffff85c5df5e>] drop_nlink+0x3e/0x50
> [26038585.616904]  [<ffffffffc03f5d08>] xfs_droplink+0x28/0x60 [xfs]
> [26038585.616927]  [<ffffffffc03f922f>] xfs_remove+0x29f/0x310 [xfs]
> [26038585.616930]  [<ffffffff85c595a0>] ? take_dentry_name_snapshot+0xf0/=
0xf0
> [26038585.616951]  [<ffffffffc03f3bb7>] xfs_vn_unlink+0x57/0xa0 [xfs]
> [26038585.616953]  [<ffffffff85c4dcac>] vfs_rmdir+0xdc/0x150
> [26038585.616956]  [<ffffffff85c53151>] do_rmdir+0x1f1/0x220
> [26038585.616959]  [<ffffffff85c436be>] ? ____fput+0xe/0x10
> [26038585.616964]  [<ffffffff85abe820>] ? task_work_run+0xc0/0xe0
> [26038585.616966]  [<ffffffff85c54386>] SyS_rmdir+0x16/0x20
> [26038585.616970]  [<ffffffff86174ddb>] system_call_fastpath+0x22/0x27
> [26038585.616972] ---[ end trace 23639deaf902c67e ]---
> ...
> (5)the call trace is from the "WARN_ON" function below:
> void drop_nlink(struct inode *inode)
> {
>         WARN_ON(inode->i_nlink =3D=3D 0);
>         inode->__i_nlink--;
>         if (!inode->i_nlink)
>                 atomic_long_inc(&inode->i_sb->s_remove_count);
> }
> (6)the call trace above shows at some time earlier, the i_nlink of the pa=
rent
> direcotry substracted from 0 by 1, because the i_nlink is 32-bit unsigned
> int,
> it became 0xffffffff, and from then, the parent direcory can only decreas=
ing
> the i_nlink rather than increasing due to the LINK_MAX.
>=20
>=20
> 3. the root cause of corrupted i_nlink of parent directory
> (1)we saw another call trace in dmesg file of the same process that cause=
 the
> call trace of "SyS_rmdir" above:
> ...
> [18317578.683304] gbased invoked oom-killer: gfp_mask=3D0x200da, order=3D=
0,
> oom_score_adj=3D0
> [18317578.683311] gbased cpuset=3D/ mems_allowed=3D0-7
> [18317578.683315] CPU: 11 PID: 17701 Comm: gbased Not tainted
> 3.10.0-957.el7.hg.3.x86_64 #1
> [18317578.683318] Hardware name: Sugon H620-G30/65N32-US, BIOS 0QL1001207
> 03/03/2021
> [18317578.683320] Call Trace:
> [18317578.683330]  [<ffffffff86161de9>] dump_stack+0x19/0x1b
> [18317578.683334]  [<ffffffff8615c812>] dump_header+0x90/0x229
> [18317578.683339]  [<ffffffff85bba2f4>] oom_kill_process+0x254/0x3d0
> [18317578.683342]  [<ffffffff85bb9d63>] ? oom_unkillable_task+0x93/0x120
> [18317578.683345]  [<ffffffff85bb9e46>] ? find_lock_task_mm+0x56/0xc0
> [18317578.683347]  [<ffffffff85bbab36>] out_of_memory+0x4b6/0x4f0
> [18317578.683350]  [<ffffffff8615d316>] __alloc_pages_slowpath+0x5d6/0x724
> [18317578.683353]  [<ffffffff85bc0f15>] __alloc_pages_nodemask+0x405/0x420
> [18317578.683357]  [<ffffffff85c11185>] alloc_pages_vma+0xb5/0x200
> [18317578.683361]  [<ffffffff85bce3d0>] shmem_alloc_page+0x70/0xc0
> [18317578.683366]  [<ffffffff85ac2dab>] ? autoremove_wake_function+0x2b/0=
x40
> [18317578.683369]  [<ffffffff85acbb1b>] ? __wake_up_common+0x5b/0x90
> [18317578.683374]  [<ffffffff85d7c6c4>] ? __radix_tree_lookup+0x84/0xf0
> [18317578.683377]  [<ffffffff85da00ea>] ? __percpu_counter_compare+0x2a/0=
x90
> [18317578.683379]  [<ffffffff85bd12e1>] shmem_getpage_gfp+0x451/0x840
> [18317578.683382]  [<ffffffff85bd19a4>] shmem_write_begin+0x54/0x80
> [18317578.683384]  [<ffffffff85bb5d94>]
> generic_file_buffered_write+0x124/0x2c0
> [18317578.683386]  [<ffffffff85bb86d2>] __generic_file_aio_write+0x1e2/0x=
400
> [18317578.683389]  [<ffffffff85bb8949>] generic_file_aio_write+0x59/0xa0
> [18317578.683392]  [<ffffffff85c40633>] do_sync_write+0x93/0xe0
> [18317578.683395]  [<ffffffff85c41120>] vfs_write+0xc0/0x1f0
> [18317578.683397]  [<ffffffff85c41f3f>] SyS_write+0x7f/0xf0
> [18317578.683401]  [<ffffffff86174ddb>] system_call_fastpath+0x22/0x27
> [18317578.683402] Mem-Info:
> [18317578.683486] active_anon:59939847 inactive_anon:3882578 isolated_ano=
n:0
> ...
> (2)the call trace shows this process was killed due to the "oom", we susp=
ect
> if
> at the time this process being kill, its other threads(other than the
> "SyS_write" thread that the call trace shows) was doing concurrent rmdir =
or
> mkdir under the parent direcotry, the kill will cause the corrupted i_nli=
nk
> of
> the parent directory, and we simulate this "oom" situation where multithr=
ead
> do
> concurrent mkdir and rmdir under parent directory, but the problem can not
> reproduce at all.
> (3)the dmesg file also shows an error related to "power saving mode":
> ...
> [23647870.874579] Uhhuh. NMI received for unknown reason 3d on CPU 56.
> [23647870.874624] Do you have a strange power saving mode enabled?
> [23647870.874650] Dazed and confused, but trying to continue
> ...
> (4)we are simulating this "power saving mode" error to determine if this =
can
> cause the corrupted i_nlink problem, this is in progressing.
> (5)the problematic environment now repaired by hand throught the xfs_db t=
ool,
> we manually modify the corrupted i_nlink of the parent directory to the
> correct
> value.
> (6)in short, by now we still confusing why the corrupted i_nlink of the
> parent
> can happen.
>=20
>=20
> 4. attachment descriptions
> (1)the screenshot of the problematic environment that shows the corrupted
> i_nlink of the parent directory.
> (2)the dmesg file.
>=20
>=20
> 5. other informations
> (1)the similar problem that caused on ext4 filesystem:
>
> https://lkml.kernel.org/lkml/4febf11b-31ea-82a1-bf08-b6bebe08bc75@huawei.=
com/T/
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
