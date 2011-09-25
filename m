Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8PAd0vr056145 for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 05:39:00 -0500
Received: from mail.uscreen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF1FE18C19F
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 03:38:57 -0700 (PDT)
Received: from mail.uscreen.net (mail.uscreen.net [62.67.233.10]) by
	cuda.sgi.com with ESMTP id ch7xUixfQQu1nEIg for
	<xfs@oss.sgi.com>; Sun, 25 Sep 2011 03:38:57 -0700 (PDT)
Message-ID: <4E7F04B7.4020002@u-club.de>
Date: Sun, 25 Sep 2011 12:38:47 +0200
From: Christoph <cr2005@u-club.de>
MIME-Version: 1.0
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
	(v2)
References: <4E1C70AD.1010101@u-club.de> <201108062317.19033.rjw@sisk.pl>
	<20110807001446.GI3162@dastard> <201109250056.12545.rjw@sisk.pl>
In-Reply-To: <201109250056.12545.rjw@sisk.pl>
Content-Type: multipart/mixed; boundary="------------050608060105090001070707"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, linux-ext4@vger.kernel.org

This is a multi-part message in MIME format.
--------------050608060105090001070707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

test results of the patch below:

1. real machine

suspends fine but on wakeup, after loading image: hard reset.
nvidia gpu => disabled compitz  => wakeup worked two times.


2. virtualbox / stress test / xfs and ext4

on 3rd resume, it booted up "normal" like this:

[    3.351813] Freeing unused kernel memory: 568k freed
[    3.460973] Freeing unused kernel memory: 284k freed

[   17.328356] PM: Preparing processes for restore.

[   17.328357] Freezing user space processes ...
[   37.345414] Freezing of tasks failed after 20.01 seconds (1 tasks
refusing to freeze, wq_busy=0):
[   37.475244]  ffff88001f06fd68 0000000000000086 0000000000000000
0000000000000000
[   37.526163]  ffff88001f06e010 ffff88001f4c4410 0000000000012ec0
ffff88001f06ffd8
[   37.580110]  ffff88001f06ffd8 0000000000012ec0 ffffffff8160d020
ffff88001f4c4410
[   37.626167] Call Trace:
[   37.626769]  [<ffffffff81049944>] schedule+0x55/0x57
[   37.674925]  [<ffffffff81360dbe>] __mutex_lock_common+0x117/0x178
[   37.792559]  [<ffffffff81113ef2>] ? user_path_at+0x61/0x90
[   37.888501]  [<ffffffff81360e35>] __mutex_lock_slowpath+0x16/0x18
[   37.986966]  [<ffffffff81360efb>] mutex_lock+0x1e/0x32
[   38.086931]  [<ffffffffa00a4d43>] show_manufacturer+0x23/0x51 [usbcore]
[   38.212500]  [<ffffffff8125cd44>] dev_attr_show+0x22/0x49
[   38.282319]  [<ffffffff810c6f8c>] ? __get_free_pages+0x9/0x38
[   38.397449]  [<ffffffff8115febb>] sysfs_read_file+0xa9/0x12b
[   38.491607]  [<ffffffff81107ff6>] vfs_read+0xa6/0x102
[   38.541994]  [<ffffffff81105ebf>] ? do_sys_open+0xee/0x100
[   38.564907]  [<ffffffff8110810b>] sys_read+0x45/0x6c
[   38.578397]  [<ffffffff81368412>] system_call_fastpath+0x16/0x1b
[   38.590083]
[   38.598046] Restarting tasks ... done.
[   38.660448] XFS (sda3): Mounting Filesystem

restarted the test runs, increased delay between awake and sleep from 20
to 25 sec:

36 time successful hibernate+resume so far.


chris



On 25.09.2011 00:56, Rafael J. Wysocki wrote:
> On Sunday, August 07, 2011, Dave Chinner wrote:
>> On Sat, Aug 06, 2011 at 11:17:18PM +0200, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>
>>> Freeze all filesystems during the freezing of tasks by calling
>>> freeze_bdev() for each of them and thaw them during the thawing
>>> of tasks with the help of thaw_bdev().
>>>
>>> This is needed by hibernation, because some filesystems (e.g. XFS)
>>> deadlock with the preallocation of memory used by it if the memory
>>> pressure caused by it is too heavy.
>>>
>>> The additional benefit of this change is that, if something goes
>>> wrong after filesystems have been frozen, they will stay in a
>>> consistent state and journal replays won't be necessary (e.g. after
>>> a failing suspend or resume).  In particular, this should help to
>>> solve a long-standing issue that in some cases during resume from
>>> hibernation the boot loader causes the journal to be replied for the
>>> filesystem containing the kernel image and initrd causing it to
>>> become inconsistent with the information stored in the hibernation
>>> image.
>>>
>>> This change is based on earlier work by Nigel Cunningham.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>> ---
> 
> Below is an alternative fix, the changelog pretty much explains the idea.
> 
> I've tested it on Toshiba Portege R500, but I don't have an XFS partition
> to verify that it really helps, so I'd appreciate it if someone able to
> reproduce the original issue could test it and report back.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Hibernate: Freeze kernel threads after preallocating memory
> 
> There is a problem with the current ordering of hibernate code which
> leads to deadlocks in some filesystems' memory shrinkers.  Namely,
> some filesystems use freezable kernel threads that are inactive when
> the hibernate memory preallocation is carried out.  Those same
> filesystems use memory shrinkers that may be triggered by the
> hibernate memory preallocation.  If those memory shrinkers wait for
> the frozen kernel threads, the hibernate process deadlocks (this
> happens with XFS, for one example).
> 
> Apparently, it is not technically viable to redesign the filesystems
> in question to avoid the situation described above, so the only
> possible solution of this issue is to defer the freezing of kernel
> threads until the hibernate memory preallocation is done, which is
> implemented by this change.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  include/linux/freezer.h  |    4 +++-
>  kernel/power/hibernate.c |   12 ++++++++----
>  kernel/power/power.h     |    3 ++-
>  kernel/power/process.c   |   30 ++++++++++++++++++++----------
>  4 files changed, 33 insertions(+), 16 deletions(-)
> 
> Index: linux/kernel/power/process.c
> ===================================================================
> --- linux.orig/kernel/power/process.c
> +++ linux/kernel/power/process.c
> @@ -135,7 +135,7 @@ static int try_to_freeze_tasks(bool sig_
>  }
>  
>  /**
> - *	freeze_processes - tell processes to enter the refrigerator
> + * freeze_processes - Signal user space processes to enter the refrigerator.
>   */
>  int freeze_processes(void)
>  {
> @@ -143,20 +143,30 @@ int freeze_processes(void)
>  
>  	printk("Freezing user space processes ... ");
>  	error = try_to_freeze_tasks(true);
> -	if (error)
> -		goto Exit;
> -	printk("done.\n");
> +	if (!error) {
> +		printk("done.");
> +		oom_killer_disable();
> +	}
> +	printk("\n");
> +	BUG_ON(in_atomic());
> +
> +	return error;
> +}
> +
> +/**
> + * freeze_kernel_threads - Make freezable kernel threads go to the refrigerator.
> + */
> +int freeze_kernel_threads(void)
> +{
> +	int error;
>  
>  	printk("Freezing remaining freezable tasks ... ");
>  	error = try_to_freeze_tasks(false);
> -	if (error)
> -		goto Exit;
> -	printk("done.");
> +	if (!error)
> +		printk("done.");
>  
> -	oom_killer_disable();
> - Exit:
> -	BUG_ON(in_atomic());
>  	printk("\n");
> +	BUG_ON(in_atomic());
>  
>  	return error;
>  }
> Index: linux/include/linux/freezer.h
> ===================================================================
> --- linux.orig/include/linux/freezer.h
> +++ linux/include/linux/freezer.h
> @@ -49,6 +49,7 @@ extern int thaw_process(struct task_stru
>  
>  extern void refrigerator(void);
>  extern int freeze_processes(void);
> +extern int freeze_kernel_threads(void);
>  extern void thaw_processes(void);
>  
>  static inline int try_to_freeze(void)
> @@ -171,7 +172,8 @@ static inline void clear_freeze_flag(str
>  static inline int thaw_process(struct task_struct *p) { return 1; }
>  
>  static inline void refrigerator(void) {}
> -static inline int freeze_processes(void) { BUG(); return 0; }
> +static inline int freeze_processes(void) { return -ENOSYS; }
> +static inline int freeze_kernel_threads(void) { return -ENOSYS; }
>  static inline void thaw_processes(void) {}
>  
>  static inline int try_to_freeze(void) { return 0; }
> Index: linux/kernel/power/power.h
> ===================================================================
> --- linux.orig/kernel/power/power.h
> +++ linux/kernel/power/power.h
> @@ -228,7 +228,8 @@ extern int pm_test_level;
>  #ifdef CONFIG_SUSPEND_FREEZER
>  static inline int suspend_freeze_processes(void)
>  {
> -	return freeze_processes();
> +	int error = freeze_processes();
> +	return error ? : freeze_kernel_threads();
>  }
>  
>  static inline void suspend_thaw_processes(void)
> Index: linux/kernel/power/hibernate.c
> ===================================================================
> --- linux.orig/kernel/power/hibernate.c
> +++ linux/kernel/power/hibernate.c
> @@ -334,13 +334,17 @@ int hibernation_snapshot(int platform_mo
>  	if (error)
>  		goto Close;
>  
> -	error = dpm_prepare(PMSG_FREEZE);
> -	if (error)
> -		goto Complete_devices;
> -
>  	/* Preallocate image memory before shutting down devices. */
>  	error = hibernate_preallocate_memory();
>  	if (error)
> +		goto Close;
> +
> +	error = freeze_kernel_threads();
> +	if (error)
> +		goto Close;
> +
> +	error = dpm_prepare(PMSG_FREEZE);
> +	if (error)
>  		goto Complete_devices;
>  
>  	suspend_console();

--------------050608060105090001070707
Content-Type: application/octet-stream;
 name="run1-v3.1-p1.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="run1-v3.1-p1.bz2"

QlpoOTFBWSZTWfoTBwABINzfgH/2ev/////v//6////0YID+AgANPk4dogd0RKoEiIApRRAg
ChSQoSICJKi+ANZkkAVUqA8W8W6e7CE97OYDQqnthdHudwVQFSMtGQBChSyYw3t3AB2GhILs
ygSgKAqSGsoAoCCAAAWmpQABCAAFCIAAE1qAABCAAQ0UABVCoUFFAFUSCSdYmAAAAM872QAA
AAG4ieQaCiSqVIAKtlGgJ0aqgJY2qoEEABbNUdaUUVIJFBQVS0xSqUFsAADQKKCSmQABo+93
SooABUCAkAAKAiDU9CAEBCMhMSn6TU/0m1KYJ6jygaA0aA9RoPSeQASmgJpEkImp6FJnpGpp
+lPKN6kaBo0DQAAAADIRCmR+qAAAAAGgAAAAAAAAAEnqqRApoaho09Jso2oZNDJ6mjamCDT0
IMQMQyAGgUpJAjIBABNGgmjQ0AEanpkaankGpqPTKYmgPQKkhAQIAmQTARomTSeoybQSnsg1
RtJ6jaR6jQaaHtlP6OsmlDCTGAsk0YDuhRNmg1SYyqmMpDGSMYK2VMGkpaK02aNGwGmFaRgx
MTGloY0NTTItDAwwLGRRNMBaYMmqsNITDSpoYrJpkrGEWxFG95JFuHfLeZFQNNFPq/29o0Zk
9retNOxz3EYNH1/R71UOmZ/T2OEv7QUD2TR1xNB5yONUDYcF3cvXo023W/jBz4c4vy93ZTyf
Zapppuu9LAl74MvwQTKsGgPoTblujwlIQFMJvUV1h9J9xmDwplSqpaDBUQom+yX/bCqgb8oL
7DCiq4R8RIJdchPQ5fmLXIdmYuAJr2oBdaVvkNjHaL8zSsHVLiQCSXEkuRJo9nZOIAR4DERt
DN7zKK+ksCfkzfQ0sJ4dk219UcKXWPSRTL5ZZq/D/wi6Hs8tmw4wGFanr2pLPUhIMQz/nWXC
H/44SJql23l803Vbz42glJaptZ/T9irXWAdHhnaONdsTTEKI2svT1Zros+maY0WLEk483PiO
heKjE7CN+7ury1uh48T3ZuEt0FA7Zo64mg4kbooGw5Ls05aNNui3GDnw6xs5vLypw5Wqaaa3
elgS98GXrgmVYNAfgTblujwlIQFMJvUV1h4zyMweFMqVVLQYKiFE32S/KFVA35QXwMKKrhHx
Egl1yE7nLyLXIdmYuAJr21AutbXyGxjtw/V+fBviZIEkmSSZ31+XTMKglGefj5VLcjkWBPmz
fQ0sJ4dk215RwpdY9JFMuMs2w/CIqH+Hls2HGAwvM9e2WepCQgQz+9ZcOUMIk1S7by+SbqN4
Y4QSktUvj1ff4yZefV+HDV0bPB9T63Yu8HybP2PscGHqXXU974Pcu9zDJ6F3BxclKec8HTXy
cuFZPf6fV7uG9baISTS/f4zi7JvMuR6ujZao9U5YZda+LPnOAqCg29gv86PVVYT6lhdJJ8EG
ZFo5zP5+ox2Q4ZcHzsMs22Y4bNi1gs+zuzS+ldi8y7V+FcF4qty3LQvrXktF4rEbhxzM0XFc
lpb10Wl4LS9K+/d9W5b13rvbmZ0XivvLZfKt60sLiuS2XYuRdyxb13LF8Vi+C43cutclstl9
o0t4ytC8G4SYPQoRC/H3p7/apr+UeqHqLu4cz0K7VUEIKVpVQqlUJ5oKFVVCqqgkqnCyX/lf
kM8p8jM+8FcX+fzYZ1svGYPU0p19ubm9/lc9TGI/kvFCOY42bcWXzj/jLp9iVH5H3g2e9jZO
7EOrjm5GZ+6B6uXs9Rf6NXoSjHi3xeY4i9VCJAlk7SgeGQBCJEJEp5yNqoYTWKkpMvBwSdqK
k79DWfr5qYW5Lisw8r4xdIMIZVQwwfgXl90vjjXC5KSFrWo1axsX4GrMrF3g2b0q93ON45Dx
jAKLhQpz3bV8Gf5lpjliIY46sIKM9o2DvCB+AUKHiL11QJKXeoUKsy0VL1e/RmbdAdBhvbjJ
5k9ku/7rrEJoXgqGgLZI/FVeIplBJSyVZqrYSGMUxxjZsbX0t66tl44xTwEkkTyFP7+z6/y1
68ZVllls1aZ2VbNciVUv/FCo84/0aKL2evUQ8VSDJUkT9KpOxs3e5YNttLcV3teJmeD4DTlq
u0v645P+rg0Z55Lto6AypCurRz1yti90STkiPSJNicB0jEYHi7o/5Cbj7JDc3VLGTqzTIljA
1GmtVKaOrDOycAt6W0wNnnTQrcUwmC754zbMxli9w+41G03cXW49UfB1x3qKVP/GLRbo1Zr7
Csn9q/gr2DEfeODxHaR+sXWHJwTmJ8XSqddlsxrsujkXzT/cPrfxG+V/u2nCe2djfM8h6R0G
Y9sfROidZ/WP944R3avhHyRuMme1mMsWpufn+f8/9Nttttlstl5dJfbLjS4xn6tbWtZLJTqH
aOYoOYnYY+I7xu2ie6TbtcBgcRZFqVKD7UWQsP4sLo+54nvfeOL613xs0iGgdA/5PIllRPxp
6Iv7vzYD7nJxUpT/VQZF7Pl/p0xhjGLpeXlmBwVZtJFkUHtWQ//EZjuiou9Tuio/aPvGcmHO
PB+lycoMSWHXP7VwoxhhjBkYsbGir+1jGP+tiXF1zTDGby7BP+37/rz9+2ts22WkulJdP3Dv
vVUlJYN0WGYwMxcZigzRmK0VEWFOR8y8i4qRSFI2FhYLnyPauj8DS3pta1kpaXpfUNw/bgXR
zPwFP0MPJP2tLJpOAwn3x/VPuNJSr9R7HsJ9fD/+dpPzDyDB2K6GhiNGNDcP3ML3ngZTazWK
faMjYzzV/KM7MxoLyTL/9HMbxkKJ8UbyTRdZZZFiWUbDIbxeS5/b931/T78YxjGGKxaqryZH
FyipH8ZxbuQ5ro3j2Ife4v93PpVKn7iPe3I4Se1P4+JPaJGbvk0Tv5x1Rkx+DtTtR7WjRo0Z
NajDDDgl137uuqpKlmXdWiPRG4qMH4xpGi40kOF360vxT+KfRMnqZOT635Tw7G7IfaP9361+
uqP4Os7o2HvnsjB0ajzj3McY7hZ3KOjYaj+Qf1jrjyjkyHi7j0LsXYaNGni4tPKcHzKUGzvn
XVpzeqSa6jC1KyS678DznNvHAeDWP8oqN32xaOA5NUpHvYcnzS0dBd/2dcuNvkyauE3TJ5m5
wYuUx2CYyU72nRsTRuzdcm8ZM2aoNVu6qmzKS8Zx+azDBRSlKYFLUfqehU92M7MlhcfJxX5V
XiRdLsnU6al8RY/zi7lFCSXUKdtMxpaN62bSMZaW4arZ1tN1WxiUc57KKqXXZxZZUUNIzXjZ
hNFI3oy62azWMNY+gsujKyo0WPKkVvNnyiUG7JCuMWZp3I4vB90djgG8Y+nqX1upObsnwHxi
8XyXte8bMnKaTZW0/VO6fnnBKrafhmnoDk8p4tD7D9x8hoTpN0e5vn5GxOt75q0MGMHxcHM8
4W8byYyMnefJ13783t8nzTJc3tYx5P4PqfkHJ9Q6T11OtXbN9T9E2qefvzMWXcMHGeQ/E3uE
jk/I0PzrqHdGTuio+EelaeKShRNUaOTA72EfW8t1UqlUqmSw1jKQXio3OTgnocH8Hm1dc5b3
FFH6HKLR+174sHUoziax4J8IukPUnrYHpD3p6nm3HseL4PSexkHKOAsFh7T+haPqjrjt8Kqq
qqrR3GyTaE6BgMxQyjaJpHJ2BnG0aJUVIzkSe5ZJukbxgexhE2aHIj4JhnE5S0PU2jh+3x+3
x/h9efnp6ddazqzXK5JwH/GNdK1tyjKSdUeweDrP2j6TMvFHFLRZQw840WptwbD6nk1F0WVP
rHqqchcWFC01KFhKjnE+scBoMR4xm+WQ9AyIjUZQi0c4sOwewLSPmn5TSNBiBOkfMaij0KZR
0fQsjpNYuvHAPgsJgfuFoaLncLx755TRh4PvWG4cBg3wNTJleTc+MdbqjeNBq7U6No3diVIZ
mB6BkMDCKji9A7l4w6jWLHa+KzIqT2CmkMWReE/PNTunjMfWbT0DyPwzqXt8syY4JsNPwLvM
Nnz33GjhXYsGqntHoDIUJYXOQkyjgPSw9Sv+jIliomJ51Li4pIA2/mLOIoTdEbvBtH4EeuMR
ctP6kaKj4AsuNEfe2YO57+6VUsl0KVJqUSdP0SqmEuxjHVVo3mQ6MJzlxvGr0k5z/veanbHC
PWM/i7xYcI4nFrFhsMR8B7zmLmBSalD1xowkqOLYU9EfY+sdr15Bw/2izoobu+Pqiw9jY8No
63NTpHB1PXGB3uTaMoqOBzGUco0Rmj+ccptNkfcuuanB6h2ftfwqeI8Z4naPsPGfcrr3p4vy
T559k7541yHGeV0mztdJxHWOyNw9iSZPklKSofvP3v1R73m+9zcEbx6Qyidw+FVT2vxteqpd
eyXqqqqpde666lLsmad8eMarSdy4+UcFl3rj0wj65526cy9ixc1+Oc5wc3Kf2TyGwwds+7Pk
Vxds+ke8am6cl3y7w6B2J3TpPncm+/u5P1zzT/icB0HetT+txTQ3TDm756/LM/F7U/ueLiz3
D6x71unhPNapfU/e757JeFebMtnlcmpyn5Hzl2q4HL+vMyy/Ur2vCfF5OM84+ZOz7Mz4tLK8
qnnLtfQ1O/pmN55OU/NeecXqT9Y/OzMzMzpPwH09WeZdeTOOkfnHhF2I5xgeEkOIuWGgU/SK
euZdi68veWXhQuqryyXBmcx+Y3iJ1vlGF2R2qGi5J5R9q0bxoa3ReVV2juMMLXafpc3rm9xn
kOK9s7J+dP/I534JwS7ndOWfv21tm22y2Lw7p4i6ZR5CpUk3l5lO4yk9EVGJ8mzQ7o32O4fv
GSOjYaxzfYNhhG0kWj6Ron0jfPbmZmZmZJwcKd9zug3DUy7BnGb1RSNFH2OjzjVGI9g0Fk1U
p/0ni6TFcXufKPTPKe11Npf93Ieqe0adid7bo+rWmtWl62TuLLgH/BoaR7pwfSdj0TgPVPQ5
VbMfmq7jZ7GOM8nNeE7TQX8ftqqrNovelKrap+OY4vQiaw2EVV29dWvJ7Lsu94OXLlyAAAAA
AAAAAABIAAAAACQAAAABIAAJAAAAAAAEkmIIxhjGmmllm2zI0WMbFIaCiYDJJo1NNY2izKoN
albKs0IlYRQCDINYESNpWVlGYGZWVMwGYmUls6bC8Kta6PB6nXyXXtren13HV0dEgABKtrVW
McI8nUJ4Sh4S48XdGGcH9Qs7w0PxSo5x4dKVT7HJbxEp9kT6MByVxdV9o4Pa/BMuDudztHVU
4Mo2Ltcz81b3bK8JpG6fFqdz3zsHY/NU7V5X6ej7s/NP2x9I7fjHfFe59VrPVflbrYzjrarT
/m83KPanejyajVZSoo+UXm4e0eDtFPAbD0zXWLY62p+46VPVTN0xegPMPJ9Q6N7jWV7p962G
Y2nQxk2Xnn1er+vfmXMvAdzeSN+A2M5oPfFMoqST97jH7Dxbj0fJPRH+j+9/ZGfud9SvOq7f
e9J6VrZU8HtG00FeTvHoaYliRKj80WD2KHuUeEd21ng7Gapu6nRqNomUZx5tzCROSKR4P7Y/
wjR3OUdselvH8/lVeU5so9TtHSNnUPQ+kemLj8h4QnnH4x2ItE3DM/cKUPrdzknV13nQWNgY
/D5/OuH6cssZVlliXYpiy1sWtZ/lHyjxg2J1Rm4Ov5Pe8eqe9o2fvj0RZ+ccTj41RaPIXZIZ
x+I2dTD617Rt5zzkxXeG998O6eL2/yzMsutwndPCrvnc+sb31ej5vfb9erdue2Sd9hN2z4vu
d9rn2L/UvJ+h5zzXjc6tPbPU1emdo+Vktn9Q4j2TL6G58VI7GIPdHOOD0OMnMeBo5pzWPi4j
C4vWNHHH1zHjVcD6omr6HF2dG5+ap/e8X3J3y7pyGNX2yXYybNWT757jhOb6nWzSYHW/zi8Z
D2x6Y19jR1Ro8hlJvJHaq0Mm6bXJo2cZ7Juc3ZPbNTxFvjxknBePsRSaGDaO+LxxQwNI6C0n
F/idTdE4/mS0LyukdRc79fhXX7bV9drW5GsdQ/kdcdI7Heomx4RrH5dcfzZx2RyizkZCz9r/
EZrvrHoeKHR1rj756Y1dT5SR2OqOLBHl9r9NrLXj9k0fZ3Q+s7BvRoPI/encPaPL1VXXHJp1
97+h1KfjFKj7ooSoqSe9xavsav6nycH6nzbNmzZs2bNmzZs2aaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabNmzY9vR1uUUXWkj3LLKq
lJPZFRIZP/potJ+KNL1zKTtsJOvJtiJwB8lUOowMlJCqIdvP0ywkNzx6XhDgsYAM4A0ARzoO
3EMeam3MW/JtEV0FZM5NaobjUxUkKo11lnKkhm8aPCHVYwAZwBLnPdAhTrJtBlpoI5iklcpH
N6efXpnFeS7FpYvEvJYutbI0XkvJOKcU0Tkmqap1ejs1Tt5LVbuqy9Xvwq8a5WxzXcwkrp2e
2xDo/JNCPUPLtMzMzP6HwJK4OxeXuvfPrFDqH7wxLu9yfSPQUdTiNI9kf/D/If3x4u6OA0qe
xuT744R9kdybNpb3fa59fe444ONxuMAq7V71dzbcpt36no0/8tkd5+tfnvdfivK6HvPRbW1y
v+SfCbx80/5vwjR3DyknAcB5RyjxjQdkfQco3jxR639jUUn5D7Ruk1i8UcQ+g0izZTdxGrm0
oav2ktJq/VH9rRg3WmrwDy5O0cXeKlx3u3gbxTKU6RaaxUeEXjsHA6tPDMNVeE9M1OninwVV
5f9BcU86dadbantn2rmvcaMai+2rGmGMYx/qXtWmVo03jGL/VX5+7My/Qyc/k3NVcX5W2hqY
P7AxNn1viNVD0vnPufdHY/m/AZD8n9x7Y649T7BTjGIqKPlHufiE7ZPU/2b/gPtZPNvHJR9q
UMm4zODlHoHIcwA7nKzpTQZr8y56P8Mh4SkZlBNHX9Cq9BsXHnleeHnGOLU5ozniPICTjljW
1jUNpOCcJwl5tLTg0qkaTeUfhtdde9108XEWJsxYSWikLZ9fde97/UwmJZDPvlln5y0XX9/M
y5MeptTZtMqvi2df4joVE30ymME+JmZW/bV+DGzJuNNNGVva0OCY0RGDsaJrYEzNYjiGpRxy
5HgRjQ1kDyQif49d3d3d3okDghuMySEixixixjAwosu0rP8Zhw8OBLDnCSRyBxCfnOTOjjDJ
HWEeCEJxwyAg47DseuOISZdJHTCPS2dnlTs8IuGUuSw1IcTvebYYRMRaHPWYXqSayejkMa5B
Lgm6cYTMiSLE0EvJeipkSKSehHFJawzarGEaKG1S+W0qVpjAxM1lbojk0P29xG2AlPRxjDBM
RyQXZeWyy20RmZwHtWYZeG8CzgcaxEiZMsZ+kMcB6AF2TTWHOCZjOjlnBzE0CYg6z9QKUz8e
GmcFadHMGdktFIhNI7O9nG1ZYUUrdJsNGosMoyrDF1ypUVNuOxHR3E1pqBFYON1huDs4i1hb
OAdUMlSLymKYxZMqTKZLTUovQvaZaYaLcduA6QEluOJrTGAcw0nIbCDgmkt2MYEw4mZQPo5E
YRVQKWdoZ6H0jdujo3I3Oa6c2XTXHY263TjNEXU4uzOLqNKNai7SlpRay01Kl6GVLUVqK3Ih
2dn4PYpKKgRdO/CTlOcRkch0RIkUDxN0oLbEOzaI1iDgQw6Fw45yiynLYpEVOiwo1FiGGJRO
OzMQhkW2PxQvHamYJEDGQWOdxMEDl6u4WhO0vKaaz/+dkWfzdPJ6n9j+T8GnU5tZ1S06FkvL
zdd1314L76/mfEaTnP7H1FwXxH332TgfKWk3j8Qujg9S4UHzU+B2vjJmycZwRyur63qtUkzU
yeKlOWyoalBxJY7Iij/ZCx4yf4upkzD30auIYfvcoIc4O6D1S8hafkaAVxCjuX3V2bYwogzl
vlF4vFLJeV2eQyIPI+d+eZfXPnPlh6UOvnrjobg3wZwsZxuMHUl8d3Pnzx3d3ds4/nxeH94/
kSx6NgzYyxR0aDQdJlL7KbG4do+ccw4jIfEXGa8mp/UvOCa5/JtoZyRSa0WHximsax7mUYSG
sfoDuOs3LHFmGjLaMVd0FSZR97WeiNWTKP4KXeL+i7Rhu4Ob4O93N3ExR4Uczd+UcouKjvUM
tJJeN27tWdrOSbqHUs6lxuOA1DrK87U/VUicThWkTlgtZmVlPjFJzlHPtWJfKFojdWyouxSy
U5TSccGZVcWEtYhcGUG9haUJiUkRsqB9GO6KPyjhYzKIiROlrcMWjGLYxuvErG/77Wt2jIlK
FChkKGioSyy0hZopM7rHftVRcLtlk8imsGI0dFPdDKCJEx/FrnfuwxizCYLjj4SMo5zOBgpG
kYb6RxRsZLNmVZ1FULKSyUShQ0bCyJdGg7l3KSUsyGR0IcOlKq72SNYdUyRPt+jSXZ2ZndrW
ZrQYsRo9zsDEdTiwvJk5jCMx2RUJcNhFC9SJ4o4PFNG8DB1jmOKv9xvHaLKi8GQp7WN5zxND
y01FT0WFhQp3hThOCMDZkTjKRroTwO1YWNsYZ0nqsq2Wwzy7SFzAp1oszdHhcXVrTS7jcdMW
hm75LDYU6mFmko9cDp8wAcqyLCwPsICxyDkmEMUX+wwsAwcyj5g1IXoxQHDApoE1aLbS9XVk
pq4N8s2J2OcUuWkLJZLDiw71MDEyqwwYmQylisqQkuM5ROvFNumI4BSOOa3G9jslGSlMOkvV
bdOmWMYxjGJ3vUI4DrkdaM3Nh4nFM2SMBT9jrWqqSaU5Oy2ck7xUUx+f2R1jmaLYPwS0Y40n
NNgaNYG38Gc1x2Wkls/w4ONMEc0ogznCTljm/sAxB9wsPGMS1o578+XcM97DW3GqZ9GaEspF
52hrxRyRxpPAzU2WNXa3Oub04slt6Xi8tyU6WhVWVhgYG3aM4vVdumkasdrg3a58ORwGE1pi
zLO7ok7UbOOXaOmrncb3XcnIbO/WqPDXK1rXcuO3ci8kmOHBydsmFp2OyG/AWjj0tupy1yu7
WGd5NBWinW3U2hvhwsqs2M+Y/UOoY5xwiw7Ua8+CzkKOdd/ZVaw63STvFux4C6OwYzDudTSX
Uru6Uu1DHLLg6mczmVXZt4NFRhI5+RRXGshru5Ka6eGoJexxoEJjiKKNwoYllM2FW2QEejEA
YZOkk8Pv+bHGA71HjBuHSuLxW2I8YBFg4jJFz4BA7BIcMZekMhHLg1Hwk9GaTwJ9KsfzZbQy
pVSU17WQwKHHJSkopZrxtR6A0cYigLanGkdFljkIlqI0UGsNDgeFlHwAk3w4NAxw+DDgeiH6
54Lz4iiRPdN6hCK/Mv3kE0MkY3WcKH6deQ1jrfCBmRKOFFltrQcB9Iq7luaz0Yz0su1zwuqa
xGShrwMjKV0JIkmZZZRpDITfatXkSeAfZhz34M2GfAVeeP0iqESWL0oZnw8ovrauW8k6cYwe
JBv7ZICfIPrjRkqSh3qWdr/GNV2EJUlH5UTQ8jrYxo0uJPbOuehvXExWljUmGPQZPKbVI4lN
ymnoMhTZSkl6EOoSYjOPEd+g8I71pqWfyfCPayeY0ebad2845Xl9C1JS3OX82TByYsg0NMK4
k1IeJLKOAgrQRSbjb/WBAH9IE22+UA6BCGRq19rzhCcrwXHE9vKurVzbxnFMVukfAD9BqD8C
ZHGcZxDtsXQbMsc1q031hzHlVfUMH9gwDzmMYrGGOYaaaBppoaaWMYr57GX+Bli02bJqfwm6
03MDSx0Hraj6pxv5MsbQ4Wyww1Vo2qXl0jSNVhlMFJmXTYzRZSlKUas2yySkkkkkrnuLcq5U
0xjH+zRphjBsMJqsMI9Hlx8+9fydlgPUx+P4f3H73O7vXZdB6mOb1+fzbEdG0ayYm83lpvDV
Zqta1j2s10uZJ/MRyOSajQRpm9M4Pk/GMxlIsHJaOKp8zju9frqvq2DR9G8Wa933OUj0nrzR
k5NHJ2Obm1e5eNSpBRoon6Yd0c8PJyRTwWjqRrJY9lJK6ni9zC70olnG/FGzOdu6xmaPuvJM
SkM1Va0WpnKQ7qdZ+Hjmdj9K/CNm9pZa0T4hcuLydWp5y6yiPXPvFzvToyZqiwd8JZMH/yz/
qqj/eyWE+A0RwYDy7+b6uvyZruxj26XbS7odWW8bNLLe3zmpi9mpV+KmCmX/DlybzdDO0UmP
mzzZJl46cyEwZPThSlldG732v2c6pLDPZ/31QBjFy24t3biryLqufVuellK5y47caylA8FdP
Q4wj7nKbjZz9gQQggRX4OHln9XiX2HdJL1hi3HP2Gw3jUI+eng5bPy/T0+vwLTjeDcOi8f6F
cmFmBqaJwxsZLyCiDdBvSzaOtRBJdu7u/2b94HMBMI8PduPRwUiubnxm62bTwRTo49GrjsxG
bHDkjdN57xr3qIEOaLG8uSH4KiRB4fzDsIG8IPBHlmdODuTfoTbMz/QkJmii/Con4PxNwlfO
Hg21Ae+9Sfl4aj+gB4EdEZ8kk8pyYk/m+FYX0i8FP2Llj4iSD6SHiW+MzdE7ExCcm7pL8TEb
c7uDCxwlnGuFTSxJUUWjWdcXi+HBlYacrOm/LCLow4r44010ejZafGAID6NPeHVxiDSQMFB2
gqc4TuHshEHT200H2ID4hp+P81s0k4wFh89FPG8KPnPMiDMLIarPgvHD5HDyy86hqHTY7uEA
3ohMB+PseVu8PPZsZiSvnwwqSK94Lk2QFjy2EkfGwk4ITbJ+00/nP1EIKZqWe8WYYTCvrWUu
WXLMK4zGpN2WQlfjn6ZyDg8Na1o78uN4NLNnduzHhR1qZ7StqJMD9EQEfkif6WOAQhZbPAGc
bYinbuFvmFxmiLvhnSyOc/iwv2tJ8HGP3rvKC8swLpJLriUuLE+L/MLrjAvO6pVEMMLAUTyW
bdnDN4dH3WzzzsmyjTJn59/mzPBoNWOU6ZIncLEoAc5v3XaRsnbGndVemT4BiMo4RxDujkRi
R9xyXvG0cHEObqnrcMmX7Gpc0sw8mHRk63J5ObNpT9EN4nW5Iw4ua8ZKi76LSUtRei1aqLxS
hSclJLNLGTKc5PBomp05m66Ue5YepTnFMPMUPIodswcPB6l3VJzc+To1ZdL9o4OImikaO1Xe
ZzD8zwX6ks+/R9DmS7tnejn0XwiDn0rxmFByRzhZ7G+S1MxfXOVvhW4U3SjhR3UWfNe2AnEt
mmbjVZ3ql1CsqqRylORffX308PIxiHCSGz4YOSeHpo5bM1imtn9BjlaTeigenPDh8ZgYZss7
5xfD8fR+bIyvfnR2ZCEV86wQBBJH0/B84JwKtGfSHog+dUjv2Qzes9+58HdxxnZwoZMfGND3
rOCQ+jgeuPPXINfdcrPIpM3NNS2jBN9j4AfXpwjho4EhCo5EnoizRJP9jXm2BrdeFEP6USYD
hxyKos+NM6/RWebfh5DS8y03ZuK0a5aN9HAcxqOigiSpQAzB1mY9Y8bXYUZ6/gqxj0u3cX+4
17oaVxmb6Aq+5Ztn19qB24VntS1sN0o6MA4mG0jwRAeB4WzNTxo59sMLHM9M9NCrcy+nrICk
NxDeNRv2PhBvyxzw9Xlq+/BjGwQzBDY45EcPnvBGuzNJWv/nc4qNcOHphF71xMijp4AYIbiZ
wPghxY78K6QJvDStQxyR7f5KobT1zfTCYiPGZtJciQ+VMrsVZbVVmHEQkvsu2U3ZtFt04Ud9
Hafqr0cRRX9f3bZK+HsaOTP0AXp32lZsXjksoUFFcyqlODNIB8I+Mfkc50fKNlRoxvVHKo48
3FZMmGSymWGOlVBhlx9lJJ4TSccijjUfkBDiJJ1mNx6QFxyzr1y+IpdIir23qKLjirKRyxcb
l5M1Ch3RTMaih8hpwZKbvT2/LPJmpmzzzviGUtKSxzHDj1yTPo0aJdiNGO8cWIy4hlniTZqz
aObN0cHUw9tTeOMSo8x7ScVxz06rIuPZFMspGJJLo0C4vLZpp26TflHewu9lZngyuq3DfznY
m65SZN+vbqmUZYqqV2VluK5Usxsxa0akfkSZoG0Y310zz9PgDNjNTd+OSQQPzw/gWOd8IEbJ
9d6KIsY9IAXK+p8v6bh8ZmsPC+cv+x1KSqHFhuuU36K3duHU6pbpbowvp1N4e/eXG+wGOLgi
SE6yOcf7x+KuW9ZmzDEMe0bX0MwAGHDh5UYICUe2aaBoFkdA2z5XguFT6qaTLvmE53LboeEo
n1u2VmNfphuu0++nh5J2i3mnIvgRb/2fjYlZTVpypnpWjlJc5l248WeGm/YCx24LohhFfSJ1
wHqiDzx6JZFXAOHjCP7P7m8Cr8wnSI+1Hk+PbF/Q7cODj/p9TYxJ9SccUHh3H9574WdJZzrP
fSSw1CqCfWZmPAJZYhHm5kkGpRB4wYeVH6FthwRgj5um5hojhDPPhwcs3GUNuza05ySOHu4Z
R0bsl+bnckzX8V9jOHB6Iag+tvD8Hw+HDfN+x70qTw89nxg8HQzFI8DuGHmk+EhWv9cK4fRz
lMYvjQOepVdWc8KORY/k8qQCBMwSyAcTHGuxoYphGFk1XKSHMbrZbU3A0rhxQcNWJcEZHAKN
LNmMvZHtqK3DZuN5gt5zl8RXB32pfm8vdCzDiwd4aD0QfY7xCX6jCGb0b+Fv9KuP/YWMjMzM
/MvizpqD6GJA8D+YyG3S05KF00jRiLdJVSkqF5Jn10yJ0jqcBnrVZ5v2e9wjijPTXpODNsw3
cnJq5N3arStLWlshfeWjnwdjmKhW666SaqSwclltQs+9dzvGedXq7gxptoqlJhFDmN8PCoYZ
5nb1TCw2tOHGdHCpmPuWGnzpzpXbbwo6apvaegQUUCkwkAonCHs8CuejNjFGYOI4d68co00a
wIrp00OzA5p0gzrUTQ7aOxRZJZRhAkilbPBCEQa/h1UMeCZv9kvxujsYenvffEB3TmVBRpth
722yMZmg5nNk7kMShQk5RwclCynkk9D9/sVvN6x5idOhUmUD+zK41Hs57mfsbjE9HHFwxzmQ
zN8CenfTjc/oAkg0w+ZB4vJ6cx2jo7URCNRW1z2Z5xx4agzC3a/jeBYYG5lU3Bvh926Qmv5h
B6HK4BELoVkN8Msioa/JjY92ThEOLhA8SeOLwoSDQ7ddnbPDr4qeGp+LuqXlKySId4jiktsb
wWt1C6Z3jQVp3w4bdmGtn+Y7orDPKbh1oga02UesHpfmkk7zHpxWQWPfbA/gP8IEGocXr3w0
HEeNg51swiYIhEDeAvfCR4HRRL+fjrg+qcPDnnk43luD/ZvzZmG8PJ63j+bDH0mb4mcPH0Bx
5OfRTEcJjRz5BuwEjsh8O8JHNL6xghBIIRZA0ClmcC9SwJG7pwWFG9IoqdHBDh9Qp4kYobTC
2RblG09DzPMw1VBt3qSwRZuqSKpHJmuQLIK4nQ5G3w2PoNXN8B75s51VRoOMJoLcN83pxjGG
MJ05ZzvHCt9KgyXH+qbnDr3rw6lVVubNedmOzDZu0c2rm3cGzE+MbDgODg8ukG1hlFYUUvsq
y9FSU5VDS25ynJaMMoa3DR4brppBx2D9SPqPKYPDwc8Ch41z+CtBtiNBZotr4TlNGrPLEeAU
thVTVXEbuPBP0X97rOjcm4IyDC+GaUQ7FElLS/ojeDmll/B554cOlb4RH9ACP4jEseGBesSR
qcbSSNTdx205ZwjdyC0NYw2bUIRCPJ5yNYOgdKYdtOqzIUjklHdONRTjsM9s0NDb0NelBaK1
Mutby/1pAFt6vUdDrsm6hvVDC4/hD+pm45025NOrh0telc30ZmZmbnp432D1j0odicb4ToHx
oEWw9Rnz3fmNSOi96RD2Fo8Eg05DHghjCD4xnQJbisZyZ2nod4f00qAtN6WmWTHKbiPSxqfn
jaKV0Pge8O9pM3uimPg3w99JG1mfJgYJZA3uSeARwQaTHDrk/IIbp06mdgtFAtCjSAqbSTJm
a0GvBQQo5BwzjkmvKHhU5pwPBAp76WVvg+n9bmsmdzfEHC9nVrqaGZHvjIHzm2Vwko01co1L
BwRAWWXws2HH5qSTs/FBYi8KFu1zZXEaczH0nawmSIOSFlrcbctlVyjJ1cFpWGiXNepgovWT
S3+aO667/4Pr90Sqd6rp5I1DWya2mpPEMJiGPgf9rHwo/4I3aYzFoyaUc4mdunrcD0tsuTdF
+jo4OLg1cnBq2a8mjeSWGm9UTzFKknC0LVLKncaa3ZR/hHC0MYLUWssXqWS1KqLKpT2TCZnB
z9EkqOZzDNIvs0s45dLZy59H20wCRFEA8DTZZgiGUj7nCDC7FLQVXNbZ4Gn1e9QIY09P6QGP
gX4adjofD4I789PgfBkXw03a6EQU/hIOeGFYWjxYRFst5p07q52jeeN4zNM+O/GK2RJFQJPA
3EDjnkOIjuHJFMCidUs+53+2AjPRdNc1mhur7odL4d8PeFHwlOoCzB4KOnZMBmuyGXpIc5EX
Cb0ITJCFwBH0zMi0f1AJjrFC+Dvxi3aVxHelQvgpklikOc5VNzGxm9Eyhn+OQYcG06OaOtcX
h+0BHDwlC8PZk6aMYxDdUpw50hsOGt7cmM6UC/qMPnh4RSBu+HvZ4JoEFEeueT6cFg8BLkkE
J261YRf856YNAmaV1Bn4caE1BQ9dePhEDkIkaz4XnmXFIshymP1BDHhZqO9E3SWcScVi6p+G
ZK6Xkn0ylss9JJHgmSRrdo6LCMJ7i4N4dk0OJOGNwYql19DDem8GESg1nYtNiYKFaC9Yo4M2
bdtfGVrLFPtVI5Bk0pDynKzW98F02C+DkuO0smon4yHLg4ep+bRQjkmkW2EOr4KDKWcaZRZw
fYtqxIlsh1U8d5jXnnB5IULKLSKarHWWB4cP2Mg/usgb0NdJx2R6d337sV6xAFHxX9Cw0sws
1bNHNu6+fLmico5DLVzZr85VkswvVhaS2bMYpHMtIxZLWsGULXLl0sqlQqXuWVLby6lLzIoZ
tF3XGlXHAFtC+VRPKR/ACRgwCgwx7ZBHX+5hDR0jqTKvsvvNfDG0Pg44pPbEZOx4QHluFFXh
h4XwkgsqIZ3PDrIfD2ThFmajsSDkkxbueTamxTfM2W1yyt54PQHhnede5fss6kTcuIbweC5b
piPMxuEC0vllS29NM65IhJmcQ3UDq/B2luPCOneEMXx2pg0c8upDmnd7D+HWOChPoyK7pzw4
HIMEFwcqTDKXfKdENZ4d0o6h92lj9FYjzPCoZmkzYcKskgcbkVDZEeRng5PbQ0d8XCjgOi15
RLeX2DPqeHcQj08J9j3ahqxWhw4/h4QcGakHkkHuGnvsnGf32WpLKjht4WRTSCbaLONnCK8n
0w8BuLTe8npQS49EmX3j8ylv93T0tuFzvGt9H8OHgG+zPsREVI1Nxw+54US4qKH6QaUHhZjE
qBODlmHhChsCI4I85fCSyx4Typ5Yptx75mYnM5F3M7byWuEki4at5ORS4XPEcwSIuWoqUchk
EWN/fYoyUqGPsLUvzJPSz33BsGwwzPDL/I+mOgSxbBoOGyY0JKVMqisbWmXR0Uw5smTJo0au
LQO4bxkcXNxZv5OpJnzmUF7ymSt1MpV5TFLXl7Wya2tbbGtrWtRtlrJtka200tmTTCznx5Wt
bnm0HZzcmec1PcOyNc1U3SRtnscKgcaO9bhNFnj/xGYdumGn02nhp9nGwz7EbZtNOcarNF3m
hQ2bs/Rm0mzO93Vbf1PA+gPwjw/iGeM4BR+TtFHp3KZYOw3rVNnpJGWFDbyjSx+jH+IY/3z8
vSdOEnp1yY7Z+gSeGjhAA1E8cfSiyW+rmiiPiJNY/xsfnmubZJw2+FWNfXYwXzCr3wc51GZN
kHTRrTagSbOjtyR2rk2SISGr4+eCDhaC+tLtmHkOYpl5I2WZjo/hDHCOngQztIojghGeYP5V
GN4uozLCnLOdcd4w6WhJmQIDNHZzrZzIHNcVGoO5XklHHOYLwuaNOv1FYI/wh+gEe/DgefPS
ujt5dnwk9Kl8o/b/a9g+xwzh5R745SXhARxqZMMcLIRftHSXA+Czwrp4Q54dHBmkQyJdjsue
R5jVo449yayOlvBp3kWSB1M3hB8GZj0JK9O99GPRM3PjjQIDlQfGgdu1XwrpNOztUgVHnjZn
ooi6jrsfDyANnwRjaSaQT5wPLcUkGDePr+VYWPNHTtpBs+QKWwd/Dg3h+p6zjDMMzI98CH9h
KEh0b6ogPDSssjrcw4cTtQgR4U1mTWwSRZiKUxVaciSCaLqS3oxcyLK4lRDOqMYyviZPSNWq
UNXZCa51WyrS1ocYn9UnAdHJkvkGyQSaSRKn5Lsl2TJzcmrg6LZ1ZzjaDCsLdilKkuvaqzqW
ipWLKWZPnO4zUpK2xyUnQZUnBRkocZU43s013BqPoc+uEqyv3wVXXbkOr+0ScO4ORMp7PTxy
TSzrnvhs2HW2zyRyp6HVAMc8IYLOmCO6NvDtnGokExVGZbdBzkc5EdKJ8bvsAed4ve5sDCqH
Y0PUzP6cLOZco9PzbpF93j6SOqJY2yvI8RBEaLRE42GRC4R4enDhzDzhECgVS9DcmSh2RPg5
EviFJT9ORwm2ITGDHRw/sBR4/vN6/kHOsbLmnpBJuFtpA7IRl+4cd9KOPmHPS2OBYjLa5nkc
FdNLHl2xxuVnOiuPDHuSHaRDnDO5LP0yzp/cGk9MJbp2f186eaez7w8+SVMND++6esbh2Rb4
Iqzo5zPIOZUDrj0FNXR7IXbFUxBTZhwizOHmKUAaxbWHGdJHbJbCiR703huBhFuo4n1Kyx32
lhKscxoIDCjHOFTByMwt+Rx9B4jk8K1yVpno9622cy04j4MHzH7EkwMCz/D7vhX1/6Xve/+T
4TJMkxMMH996qpZh8nzdCYfVGy6v5RszbnFYP8kdT4uDBuJvOYuuL4YC4soaig+6PvHWMh/B
sizZHVMTT/EeLePIb6nBc5+ub5+xxnCdI3fofixGznwHg0ZRcnCSfcmGJLxottGjdiLR7lC8
XfYuR/Sf4jCPm4BiTJhS8kXXXi0uLC790Wf3D1lojzP6DQdc6qdbah0bHXG0r6ng0f5t9qo0
LGHYcY/gMTIZxb9HCqnAlu2qsWoykSkk8YsMRzj90dkfRhwbNn2vue1HByc44RsYHmmTIT2w
m8ZijMexdZm+tpO48Fk9ad8b6KfU9reSZu9s09bdmOpIA0d7gjop4KFFLHguYMHxj1rF1FLN
F3N6GzNdgWZqWXk7FiPU5PePmxH2PQLR3v0Rojkw+IpOA/xjaPNrGHKPE1NUel4OMZTqMSRq
zHfOSPQ4Z1VSp5xu6u4e0drwdTqnRo7I2eSdacs2zQwpnJaMRKNlGSllFKUyUdpPBkwyKy8r
Wta1rWtxWwwecd75sjIa2tnnHYlsVVVunFu0jrcndGy66P+Md7dmwrye99Gb9fE/1PCP9PNl
HUqKJ6BaQJ7lxYxLDbVDRkLWSTxdr1sG3g3a9GFnYwwT8jKCygTeMl5ZCJL5ivyy00w3CK0H
IaW/apeLbVX+bckA/AVfrbTPVwGV6kielgai3IgHQYHJbmpHesfyFPa5x84/NEVJJ7HzfNo5
I8w4B7XbH1HWLjBULVVUnmssKZRhrGBhduLP+Ucn5s5JoDwD783P3VD1zsv2Xgcj133L42Hs
tLfe26I9CpLqHUPucvxqqnzH4v2NAsLLk2jZNL/qNNBvGE/Q9w4T+QYD9oxRGh8WnAbpgaR+
EmT+/H4XM/2F/Mf6jeTUuwcTZF/UNn7niPwJvp+2fFpFsfSxTvnZPpeltF6hhoO9vH3HYMEH
e61g/6pJJnHJeC/je4aR2GD0z7QfuH0D6RsL+TF2MOZMne0THyjrXOpgwN8/n71yQsMKt7qu
yeLkTYOc3RaVE3qjzTEcBidQ8w0k+DgOVXAOg803Ng4SW9ZE5v6OPewfCZ1x4nel0YOY4HFi
R1PaPqOQ5j6il7gxV4DSab2Jsh1D/Fs8p8R77aVOxWLleFTB8Nnn0Gh8H0dTa7J3z2jrGSvV
S5uDB3zQf9mV/B1jRZuM4j1DAcAyI4CdR5RmR6Y0Tz4ZmojhPqDKt42cu4Oc8VoPTN4X2P/0
7lsb3uPVmZs7xiD0zapk9Ux4F0HUxbDE2NhWNyyrSjJssUxkyYmhpuqYTRjaY4TatpsyRpiJ
kyJlWFWTJkyLc0GpV2rI3zB82DNJ5rHvYj0HnJwt4fJN8V1zBuVknwEZNkyo3jJ6ye4uE9d2
zeUu4+9MHfNplWJoToHObC1MPNYfEjyGZsoYJGUdkWkYm/GqP7Y9B4pg6TTyN9RbHgXxGJPI
eQdFXQqSPIUO0jZxGcYR82w75IppH6k4zhF1iwYPO0rrnjNQuDK7JlT1C8DztnhMi3vJTpsv
WTFL1zpUaDc8orQbxiJ9a9U75vl2mr3F5B3jU5LSRgapHUGYhykGUcw3i4ZJJJ+sbyfFUNg8
RhNT0hk+AaGk3TJ0nm2m4diGDfNTkPJil3jFH+D4TSpsyXyysFvenlmRhhCZEbU7JivbMJXK
Yj/SZOxi8nemp/Fk/zTnCnyupuq97ITvmTJivyGLqri9oPUqBifYHYLmsPlGRHzda4/6jA7g
1M25zHKA+ZNBhSeYVJIchtPll63zDxGNrGdjRq3zQrC4z/kk0mpun+I+UbJiXtdicqsq1MRH
EdzyDiLDEj1ic5JsR7TrdhO8Ru9LYkXjkHFdHknkP+xqYkn4LVtsa1RmtXTZat430BnULLdo
sLCgyHKE4xMDAs2XSSyLhPqnVFufPOQfrnbOZ4Fxi87yk4hsvcMU9iLhPQGpD2PcN6XEcp6e
A3JYMnjMhpJkU/oxK7yomYdj3H/oxJ6acjY+YuHX2VUbgdBT9CjyigZkUGHmLiyc2Febvq10
Wu7ZLJZLKlllkssslkslksllLJZLJZLJZLJZLKlkslllkslkslksllLJZLLLJZLJZhJZLJks
lkslkslkssslksllKyWUslkslksliiSyWSyWSyWTLLJZSyyypZLEKVKWIiCAiAgIAgwRBEAE
QABiBABAA0AAAABSaCgxiCbMDIYjYwY0mkAxgKACEABERAYGiNoTUaNGMGSgAYwUQUCgAACt
iArYgNQAAGJCYIIIVhBEAWgMBARBMNiCAAgEAwYiCIEMtEgogmwAAAASwAg1rUWoGYqKo2pM
lJJJJJMiIiIiIiIi0BG0G2Ni8TwrkAAERBEQGAQCQoIlkJIWCAzMzGUyzMCxPcPYPOK2H9Qx
+Y/yfzGGynFhSPsYJ639j+fbr9uGv1ZmrvI6wPT+fYzk6UEm1+Vlf6r/WSST3CAWaYkBMSUd
iRiBjjdnJdBJscWV+N8SSSdRkIh0YxREREf7wAs/zV/Krhy05/0wiM86rnciYkymiWk6p/gb
NrUzthocDGJXr63E/P9v+tJN/ofzpJQ7u7vIbAPkDhVzlUcEQJAf6FG5sETJEZEZEZEZmRER
ExmVSg/qCHD2hw0Y6JLaURmkQabABFSDCJVHxLvWKXFDoWAZlt+ikZmbkqngGBdUPheKDPVB
uJq6ozLUv0COuAcvurXoC2IWWI683YHohjbPHfEr8NLa8AVrrwA5HR4AWLx7FnGlQoeOrX4F
2hNrO0hIwFcWPA2EO5mPAyGmSSGdzb5wd8wOMNzGWPx3Emx7loeAo2QrV14SNAXCXgDJFj9T
vIChU8AViRxLH71IdpVgPSl4A2jjwDRqUuJyALkR4S6RIHlMuUO+wtc0l76KFSRmy7uLy6l3
H3OjDCuXVvbapno9woJSd31S+dTSi9AO13GOPpW3QpKjdM4VyHHRfC+Ah7NAaZIlLMnlEc1o
ay5/BMJHQJLmAN4cfy7IFMri49+FNoBsqX84Q/oZIlXjvURkTGO6eanxW/Buya86Jjijw679
OvmJXg5HMLe6OPzFhj+Adsx8PA3rS9WkoSUwlgHxmgDoHvovPfCIhX2L/wMfuGMz3W+CTguR
xNSrq8f4BBOdYlhv3HOluvDr/TLv18r1U7j1xlF/BQ0Xa2MVPWSk1P6DRZqQIaU7u7jOM4yA
u7Af7gfTG4hLFh3hPF11K68+fI5Z14mu7iroxcdsd9L0iJji7dpEZbTeJP0h70h8o13zpIDg
dAgCqvGxnQkQ7jITPq7cXUW3LmcnZxzHViPjdJvd6o0mV8P3enz45888XjT4pa+0WY/kQ5nM
gRnFx6FEREBwdcduKHqnEptQ/K4+8lS8VhyNlct346Ljm7cbPN16e3x6eXFtc56D8Qis3JSl
doXZJqN5imJIWVznc3nMyKnNzbgnk5u1txHLSvmCmuJ34ZqziipiaWbQ78q3/mYtpRR17JR9
B3sdzjx2Lta9rHkyotzHtnU4Y/oGtnd6XyZH2z2uyIk0ZVyRPLfc9Efc4QdJJPR0LDmN7keR
RW+57PB+8H5G2/Mx2w2luVW+tziFCQucXH+AVEvvxL9mwNDRCqq5R/q13qtBz540rhWvm7I/
j+I+8e6P0yguNp9ND5A/S/4bTgHLSexX2H7hj/offv5j/AYH/yY33oXjP8quB/gG0/I/6B2V
/e/xvx3C/dfpdpPzuwNDBgwYnUP9hrI1TQbChQ4IzdyP1yw5DWPkmw5yajJG80lzJ0FDwGST
icx3Gk1cVO2fE7I2UmAqO6atmkYZOL5vKcXFutpmRiPpXqmP+qXnOo2f72zvuKMPvjKra9a3
LZT/arTzzo9DQ2nylarjt3yb+F36u5W3BYixJplmbZKUlbZjFqZbKWWlMcK4mltjGZsnEdQ9
6yXwnvn2ywZPkL0D2vqZE63tOM6n8hZFypaV1V1Sbp0noOw2BxPhDzqkHFvGQ9K7XFHa63Yd
p4sl4MbLB42qLjODA7ZXmjwq+dvnJG+ZO1879g5sDoc1SR5MRihiW6C8XYRQpOAds416VppN
Syf5je5QypxDKLecKuF2P4mzJ67ut7o3pwVIN14zU5sTxi8y06DqP13hPU5w0GJwbPO0pieV
TU89k4LiYbMGPeNDkVxFqplepyd71Vf1VewdB7S7arsIainFdwnctG7pDiQyjzaxk/pPFak8
ZgmrLTzzDoHCc03zTaY7KPxuhoOEl/Ke9vr0S6pO4XW+Seyq2GXOp7npcKUw6PXdrA3IxaO6
pxebhMm8clnkueiKZyM4wKixUQQd5NVxiJlLS490YHrCgqkb1mYsqtPRNTaeZ2vC77i3rSeQ
eVqnpVdQ8xnYp4SvKZXo4e7WvzvzN2tbbjFbpYsT5K+SonjH0cZJk6pnO6c3DjVbup7gqp2s
HimQ84+LRs77inFuL9c8xroP5LIsTaCpaTVOhsWHdG8S5kjR//zU+qfaxqu4f8xoeCdkyCmq
vx16ppxHxXbtP8Q00H+Y+xdZWxRuHjHU7IQwfwVJtMg/yg6zwKJZVvqNHXal3MfnmVLzdWZ8
GZn1uM8mPoiidTA/a+elV1PFpoNVFRkPU+ESLB9UJcxGaOYvNUTxTNGz3rSzip7pvV1g3TF8
s0eS86ZMmT3sPS/tfFzOqpvmmVb7Z1Nm6XiZT0Pujc8JfxfCan3Q7n9lo04OhehHjNVxmTGM
m00ZNLRgwyZBhfLU2NzoN+2MwyxLBiNV2ztTUyU9Q2HUqdQ85yGngqQbVNRN1YaqbUbhsbT2
jnTte9KYYwwsMJjKmExPftdBdoyTpMrB1TVGnSV9EwPQsjCZOe6loZN8Wh1G2pbzKP+e1Gqj
sGSwYDdJir7tZMu81NmTeOZWlPaPPOo5SR2DUZwUKHWqRvNmI3Iucnmmw9JYU5HFVeBtVquq
fZNksh3CoxF7SlUqh9VBtey2Vl6KlKRVzVXPlxcNuFrhcVllllmWyptmZmKW2S3PQaVvxS3J
0JyGybphOAxNTK7WtLAxgxVzU1y0rXalt3LsuNqrpAG2yq6JqDlMm2QZNpqaZUsY9rJdMLMk
ZYjksi3GLGq1rLWZmsGsrVg63rPzptKxNGG0xdyY0+a6Sx7yg3WGq4pMFuC6Luchh1qA3Oy7
KbTZ4FXYfS+DUXnMngeEXOXIcCc0xgnmiYZRdGCdKzLGLwYNI66H+k4J9BW8arq2mt5657Wp
ymS9jfKQcmxwY4z1QOMthyR1T0D2Lde1lUbwyeT4j2Hnq3B2wnW7Hc8je8GJPCYl15mXR2px
HWpyam96WVeipidU+418uJmJz6toHtVGI6hxoFoHrVJgMBo8CYiosVFSS0eMknQlhn+Pt3zr
G711nj8f2uSp4uYcVzznHwoahuDJobOISSLIZClcGUbR9W4szmLFI6UNWyFmcZIwxIyfi9a2
EsoZxoVGBeOMXjkNxksUzaRvnJFRrFGSSlmQ0ZC8ZzhXpm02jfOVLlOI7Z18a2SsaKyZ5GgX
MNpymgyYGsZRRGcMnvWbRqbrk43Wln+EycTsu1czVVwOfC7qmgzbpmpm5xTis1/NpG6dFcWU
No0HM3uu3qu+adx0nCbN8WDnNatrjHZJtiYmIYkxgmEwqqUlkXma0mTAySbutynKGsZw1jQn
97eYnCima69Eqwt8IK3lphOUe0/eMjzMmEfoKIsnokFLO0fCbtBmfEJ1OlKebUsUOiJiSKHY
MjrJ5Lo5u473YeDRpGgO85RyGbOcXk7XY+tknWUaxq6h1qHScHFzDV7TuFkmxUaxROtSasiT
4jkeS/DYsYuCvTPG+y1fzG66XivyjiG47JoeVXAHq5XIOIwng0u3T/atZaWsqVFShuoe2M2Q
/4RaexDGus9dAnf15R+6nKUNHSRBVQ0oE728ounKUNFkogccPpOCiIZmlkMKndOh3fGfEyQr
qAqHhEQ6IQ7QnGxCgZCGSUGjs203sqbk4zY3TfWTlN81N41asWSnismFRqZEd2yOa0ZNk2TE
VMpJMaqbo05TnNkcxycKrhOoaVcGbxUYGkkby0XebNvKXLWVKWLWJSGLL6nZLYbm4cJjDLrt
amjWleUkpdKHJTN2jhiNWebjIXet1zcsXiuh/lePRuqfrmk6zah+8w7XYHXbdgwK+mFisnyO
FTZeLxpymLTrdiNpgNo0LVqLBAaaPsrfV5R5xwG+r0qrKwZiYnyMuu+a5jefdWQuAwm87RxN
uZ2zKiDJjJ6Hay4SLi4j65uD+47J+llcJ8jSMDsR2ucshZYcIie2LwM2I6NUiQOhhvCowLI7
4+rTLLx2l+9bPPGeeUvmzjO9VVZzCZLRd5qusWJZU9JmN2H9cZNY/YpFozjKS8aOsYGEYay0
bio740DQdxHF9RpIjVgpoZMCnA5qkHzDmOFV3zBuhcciX7Ztxnmp71b5tDdGh1w8B/qMlIPB
N0xepql4PKaZONs3ovY6ouulbDieXwazTGs0MjJuHjNlZNjZtG6bZOvTYb2jdGrIy1pVlMmy
0MLJPKSzxl5ij8TEN9YhyaJqZKdr3zqPknhOD21pvmxb3ZoYnb361rWq1Z5TJ6JjduaMmIxN
eieF+RtDxXyTHXOxHU5TINp3z6DdXY3OInUqY2dzqK2rrZRlWSHCd7U5J1DI8p1rwTqrnPWy
fCh7JSfg+jWta0vXNTKPZNNH3VVoPujBpvpq/FhmSxYLAw+6TBOTAqLLDILEWGxcfRefUupt
FLR+MTfvasxO+pwf/D+v+Iku072nB7uyWahh2HY4Nmp7Ee6vPUP0XCjxR0uIdg7TRbtjQ/A+
28g2TKrJKeesRHdZnT8u7rvimMYulReLDsHEbGiHWMoknFt2ZmLFgqwdWvPrWtL+4bnLvzPy
Fydwn/uN8yqKKzqqSxkzdHUpTsZF6v21HWZcleUvmqPTfq4T7OQaPOvvBxNlU+D4sZT3zcM3
SXv9U/Mf5O230rv9L0/VO2fjdv2337xruHzo9NbnYZYbjy+ORQG+pLXKqlrpm2udS21KmEmq
mTWYxUuLCWNm+cW4oqKXlBtJPEco+ibxcZk2PRHolRYwMFlSyuo6TU7E/S+0W/dmMWVjKWDF
em6hfsngOpjJs07KQ3Dri5H5xkTqZI3in6ih2FRzinriYO44MO5sNOYPRXEcRq7ErEtGGCoN
7hBurKq8W85E6g7EdzidjlLrquUyLIyX8BhvlKikR8hyZRhmmQ9T+Fx+tiGaLi4LFNqONf0b
JucJ5DglWzi2eMx8jfNze1TjV21k2bV/W0NKOKWJ73ucmBhR3D1P4J8qzqmxXBNVvltkRSXi
ZjratudKqqpQSWGwy9CeqV3Dbm0NwXwG02Oi8Gj97DHNGII9j3jZZG9g2dgziJtHee+TQYOg
7ToMgbDqh3ReWklf4RUWXH7I63cPPF2yeZ565TJ/EZU3F4TdVpTg9LU5nan1jSdkHZ4jMmMU
4PQwdDrYuqZOI+LzDaZOU01ZOs1LUmT+xfqmzBs5MaGw03RPTNTaGp7jfeN0cC4XCe1q4T55
2Npc3BHIZljhG5kN5JNBStaqqqs5aTCoxFQyjR1xY3Q0GRu3Nhc2OMea8FTgZD/QnLFhaemz
IMK4z301C0HGcKnAO6fjkP2OMP909E6qyYnqbmh3J5VLJDGFjKrIs5JwYZOETyZzwP4vZ7I6
nAbSSyilhpaNB8s2rSfue5gwPcNyTmOsc0mEYlh3Fwram0x8KQ3D1zzVumhpjUwfArkeqYtL
GyoyvNcK2qYMbDjFjcszMiskfYN09Et9RpZRdQ98+C6h7p/c5MYlFT9zYe9OJquR+Y0FrDKM
ow/fUrFjMzMLVb62G6cpwG6cm6aX2tF/HMMv2jL4uU65stPIObQ2L1zuZJQammNJwmw2HXZN
jHlOEvqfU5KkHmd1TeXGYYWTHWnXOjyppZTYxzWqnJqjTZHxGVvobm5dC0WiwqF4uul5yuWv
DKrLWsvdbLaMDsfFq2rIupqclskBpWkoLHCPRChzjc5Rsu8RQmklTWN4tU4znNJ1qkH4HdTA
5VbpynYOM6/XmYjU7ZpukwYMStwyKVGSiGRlKjIZIoJsawzM6aNbAbaabaaa2t13irtXTU2m
0k2ajlGsmabSLFpJu3g74ofAMJyF1EmQodaWcI0ZB8FNom6zsmLyDvc3BO4cRtSW071o2rKs
amroqQYyrZqn5rLBlgxuuqHyh1L1NmlPJf85k7rJ0sWqw1X5JaPo0eSqPEWkh4qehh2D8EwH
IYnW5TE65ipB5DxJqxk5j2Bzm+L3D3HNpmWNA9O/GYkZNLUxaWR9bVa7aLI9SkZw6LOMmb+x
qWKYtGnF+vjdlccGWDhVxu+ddXuDjeq0WFhT2FLD2SWjmN27UYhnFD8n+I41ek3FNHKY4LYu
O6eL8FFuZHMf+E2gcR4+FNpyI7dOpPM1NRU4utaM3J94ahsaLQqPfGkkTDWKYY1MlHtq0Gjh
PBd85p0W6rGTeXScVfIybYcJl31znEt5k31ZWZDGC5DTU+gNTVTdNF2jZPsYrZwalvYLGFhR
V45RNT62o1lb61LTe7mmxl/40VvMYmB4iw9qP9mcQnkbTtGsGFoOxs/pI6rq24tudyrp1gUG
WVlm3a010YYNTSWqdlNOsxx4HCDrDMYyxmMLGTBgxxtStBiYcp8XW5zbJVBvHFWxGqjhIq3H
ULQx1vKdhuG+dbHM2RfCJkyXVNFlOoaqMqaq3NnWXOYU1cJ5w2H5Z72p1p3S0E6MXuSO2daL
ZDpOwj0z5p3Vd83STfOJqam6LJg2GNNTQ3W2TvpulbTxaS2pZPIbpoOtxkuVUyDaYXJPm8nC
OKOFRqYke6l/INPA2qbDU0q9zEeYMtrm3zYcGTdNKtWKcHmLcHhfRD6ywOt+aewaOxity/IY
lqpYuMxD3TJOyLsLn8evWtaWrumaTQx0ZTdU2GVuobTUwMmw2nWW+bp1ugXOubaplJ9idrej
0Tqp1xZJsOVSfAe986pBvq4DfMaGMcRzq8G79mZmLFGPFObErBZNx3MNhqbAsVCyz43i1Rqw
do82EZDCwcYOsOE5z/gcZ+obUYjcwb6jlO2nB95ZO5zI4StDErFlWJjI9U+0dj0y6T9U9I6D
Fj1NKaDEZoXlLUyfC7arsehvau1p0H+Eym/MzMzM4NT5CNTEuyZJkyt02W6fuNp6D2uB65xG
Umc504mNJpqjOseL7F4vHteL6w4Qe6GVkm7qJrJzkPaKVPcVOJXmbT9g/EHe3vVJpqaWQYym
X0zKjB1v2SytTYOpG9rrmC2i5Dk+Daeed8l9M05ZNTdCZjqhF5kjEH1Li54I9CajMap5k7Vo
Oy2GXmPMjcNz801anwHf9Z5h5pc1L76+6pQbqe9aNNO6cJsOLjtmZZbRODK2mPCZvRsnqaGy
emW6bwfGyp3MvRMHUxdHyXO4nBY3wr6MT9swGnRwfYK/O9NXcfjeNoNowXkk4C/0FIdo9KRg
OkeuOZmPW0UiUiNV42UhvDMUjvji3b3hGGpXBfceI7FwPO4pHF6mnN6ZpNmmxWzJiuAdzjLD
fO00nShnGChNo2i0d4U4tyWiSdQ+iTc6MTnS1pzPPs6Dyql60XdO4R7Zuew2h53XV3T9k+Sa
mxaymYrGDqmpTKbTS00pbSpsmmy27dXG3Gk0000tS0yaaWncyNVk0ytSYZWMSyYfhYORhcUy
UbmGMTJxNOjZjHYhsea9I+k1S0cpWpzb1SD8s/RN1focFOU5TiPTU7w0Mmp0bVXOXblWpyep
LiVwMlvDeMrnMm4V6hmqjFhW9g0H4Humm4YW5lpYadT4LFl1tPgn1Wr20+y/7fhdDePlXhI6
MnbMmQyxYqO3KwY/c9tV66mEyrqOXUR6Zl7crMGYzMyqO9lcZk63OuRNg8yWD4sPPMlen1Ez
C4TZG9jUwu8XhMDhYr5V92e0o3SX0O2uMybVWnGaOqTUXe9d9Q/onJ9M08hs8D6czGGJaD1T
sjnhG0T1NTaLjMlUHnNTZsnmDudxgsKyZMrC76p6R0d9Nxoh/XiTwdrsbuEkPCOqCbQXHSOt
jvnjFMkbJkxldc1WpuskP6Pscm6bzBlWTBixpVjTJlDJHErVwG52UtSG+vKY0xvrEooAUABE
C+Ke4jlAz8yBDkDwDULwhESRGUDCYSHCeACIkb8jhXCBxoG4Mhn13dPUO4067vUQ8IbVTRmX
zLpde67Jzk9BdKjuTvZcuA2jbMZ2tTNeAd9T3SXimKuoXNvmiyYT/eLKI7xmnsSYjaMJoKjr
j9Q4RucEe6NYiojgamTdiMmcZDNzMRq3tMvmmpxHOeL0N3Cb6nVXNumnXKc8o2MsjNZxkssL
LSTM0GHXFGsck1ejF6sWsWsMwtWUaZjHorLzjfOE2Wpl+S3TT0zDcxHcGOj2Jod7q1bYleLF
htXKZMuY0wcWh4ihmPgOI6ReOEdY1GrsDmnFNY6NxOJK4u1ZPQVpupXid02e1Ugyj4mfeYl9
OODGBqWn1k63VMYetMyMpi0na0G04uDGB61bLUx7ayDuZNo85ekYNh5hhunKsTcSyuabm2LP
NW5piO5lXBgcbjObqmTolfwcJvOibnhbp8p7E4TfXXLe2eyXtsmrwLGNTIthdcxLGPKcHNkw
3B1TGDzyyTdN8utacKxeLKm6Sd7adUNzpKbBpwntm0todA7mmjYcxZFwetqrRvGNVaNpubIt
DUyWqyaqtGDnNJuY/1aFqsPMzHXN52ibq76Q4VphcrG+ebW6hvGKnhSybDk04TKm6canQNjs
NjaY2nhE4hiXTrTfKqVLkstaJReVXVbjXCsYtisWZi2s2xjPrZOuWGGZRweweLhN8yGFmIna
M2UeRFRYYF2IsxCYjKkXi8YkmC8C0VZUmItGxias43i7RLNY+5iSS8ss1DdwjQbt0xra1rJa
beYu4GQ2deq8bRVVVJUyYDZcLJmipGQ5DKLw0UaqWVaMji1DIU1qKjEVNUzFMxszlSI9TaPa
N871VibmOCmI/IxMpitTdJpzGTcuqc2RddLmVyDm20zQ2ab1bTZtZNvU0tq2YuRwbSxXYNzD
MWS4zU0uu1anU2ytS1MNN7YTiJuH5K1W22Zl3o8HXNypBvqm9lSYjJgnW7jsVWr/2eh4Nk5S
7ObvWw6I2aOCN8wb3kYqNziOTJlKJNkZxiOtnGsTUZusWiUUmjoLzIUWipNEvLFzLFVSZSkD
RZVdbfbBbMVyDDpXCr8s6Irnc4scx0dc4zqmxbTT8DlXBvubqGm16qWp1TgyabrhJaoYS73b
U5MjcNxXObTvti5DoOU0/c4nfDuHqbL9ofOO+aBqdhXsuQ1YODQ6VtOM3L1VsHY7h2weIsYk
4itu/MxZYpaTJPi3N1iX0u9Ok8lR9JdS7U9c2nGrc6q9Mt4sv1T1V2l+Ecp5Oyb5zlfjW455
dgfS/UxuZOY0v1rLwTqnzjxdZ0kvNbHrZVsjEd6fbZNSbxuiarV7GDS2H2rnQ5Uth65MicE3
LaZDFqvMMT00TF6DVR9ZOt78pfXknwslzGHyzF/JlXoRumi9Qyh5zvDqOhvRd0+DBymTG69i
aL3TwHSo9BOyeIGflrZTiOMbq+ap6TKWwsUYWDEYJdRDII/ujKF1J74om8OCLBhOG/MMVLYb
OLwYNDdWwc5qW9YmEyN5qL8bXk2pwcbZ8j4VXtrdO+ZS1OKmkmDeVparaOuY1bRk63U07DH0
ulaammDTks4m1/bT+6KWKwP738WlDTTSpppjVTqMgbMJwGVwnR1zzMHNN6lZNpaAcJqtm93s
XkO6E9M2DEeUmS0omYzFxlEwySl4MMlPMYaxdZcaRaLi8WmYnnFpElniUiM1xmKaSaRiMw8E
bDkK5Bzb6q0MvbLFToB9ajwDHS8qxZWGUmVkVlXgh0f+hdyRThQkPoTBwAA=
--------------050608060105090001070707
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------050608060105090001070707--
