Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751906AbdLSQuv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Dec 2017 11:50:51 -0500
Date: Tue, 19 Dec 2017 17:50:48 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 00/11] fs: use freeze_fs on suspend/hibernate
Message-ID: <20171219165048.GE729@wotan.suse.de>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <7282138.2afjHhBgNp@aspire.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7282138.2afjHhBgNp@aspire.rjw.lan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Dec 13, 2017 at 02:09:49AM +0100, Rafael J. Wysocki wrote:
> I'm assuming an update of this to be posted due to the comments from Jan
> on patch [3/11] and patch [7/11] probably.
> 
> Is there anything else that needs to be addressed?

I was waiting on Jan Kara's feedback on how he'd like to proceed with the
unthawing on error given his point on that the device mapper API seems to match
the in kernel automatic freezing just that I didn't use that same interface.

0-day did come back with one RCU issue which I also have to address:

[  422.919958] kernel BUG at kernel/rcu/sync.c:228!                                                                                                                                           
[  422.920115] invalid opcode: 0000 [#1] SMP                                                                                                                                                  
[  422.920212] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver netconsole sr_mod cdrom sd_mod sg snd_hda_codec_idt snd_hda_codec_generic intel_rapl x86_pkg_temp_thermal    
+intel_powerclamp coretemp kvm irqbypass crct10dif_pclmul snd_hda_intel crc32_pclmul crc32c_intel snd_hda_codec snd_hda_core snd_hwdep i915 ghash_clmulni_intel cryptd snd_pcm pcspkr         
+drm_kms_helper snd_timer ahci libahci syscopyarea sysfillrect sysimgblt fb_sys_fops snd libata shpchp soundcore drm video ip_tables                                                          
[  422.921168] CPU: 2 PID: 237 Comm: kworker/2:3 Not tainted 4.15.0-rc1-00030-gf95c16a #1                                                                                                     
[  422.921347] Hardware name: Hewlett-Packard p6-1451cx/2ADA, BIOS 8.15 02/05/2013                                                                                                            
[  422.921515] Workqueue: events destroy_super_work                                                                                                                                           
[  422.921628] task: ffff8801bfcd0000 task.stack: ffffc90001128000                                                                                                                            
[  422.921768] RIP: 0010:rcu_sync_dtor+0x65/0x70                                                                                                                                              
[  422.921874] RSP: 0000:ffffc9000112be60 EFLAGS: 00010286                                                                                                                                    
[  422.921985] RAX: 0000000000080000 RBX: ffff8801c00793d8 RCX: 000000000001fece                                                                                                              
[  422.922133] RDX: 00000000fffffff6 RSI: 0000000000000282 RDI: ffff8801c00793d8                                                                                                              
[  422.922283] RBP: ffff880212f1b6c0 R08: 0000000000000000 R09: 000000000000009c                                                                                                              
[  422.922432] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880212f1f800                                                                                                              
[  422.922579] R13: 0000000000000000 R14: ffff8801c036db40 R15: ffff8801c00795b0                                                                                                              
[  422.922728] FS:  0000000000000000(0000) GS:ffff880212f00000(0000) knlGS:0000000000000000                                                                                                   
[  422.922931] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                                                                                              
[  422.923054] CR2: 00007ffe2f820ff8 CR3: 0000000001e09002 CR4: 00000000001606e0                                                                                                              
[  422.923203] Call Trace:                                                                                                                                                                    
[  422.923266]  percpu_free_rwsem+0x15/0x30                                                                                                                                                   
[  422.923357]  destroy_super_work+0x3d/0x50                                                                                                                                                  
[  422.923449]  process_one_work+0x18f/0x3e0                                                                                                                                                  
[  422.923540]  worker_thread+0x3a/0x3b0                                                                                                                                                      
[  422.923623]  ? process_one_work+0x3e0/0x3e0                                                                                                                                                
[  422.923716]  kthread+0x11c/0x140                                                                                                                                                           
[  422.923792]  ? kthread_create_worker_on_cpu+0x50/0x50                                                                                                                                      
[  422.923905]  ret_from_fork+0x1f/0x30                                                                                                                                                       
[  422.923986] Code: 00 fb 66 0f 1f 44 00 00 65 ff 0d 57 6c f2 7e 85 d2 74 15 8b 43 38 48 8d 04 40 ff 14 c5 f0 f5 a1 81 8b 43 20 85 c0 75 05 5b 5d c3 <0f> 0b 0f 0b 90 90 90 90 90 90 90 0f 1f
+44 00 00 8b 87 c8 c3 00                                                                                                                                                                      
[  422.924405] RIP: rcu_sync_dtor+0x65/0x70 RSP: ffffc9000112be60 

  Luis
