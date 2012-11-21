Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALMKWkq102407 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 16:20:32 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fPJv8pH88mKfhbUx for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 14:22:42 -0800 (PST)
Date: Thu, 22 Nov 2012 09:22:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Oops with to traces on v3.7-rc6
Message-ID: <20121121222225.GS2591@dastard>
References: <20121121141811.665a1074@ilfaris>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121121141811.665a1074@ilfaris>
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
To: Julian Wollrath <jwollrath@web.de>
Cc: xfs@oss.sgi.com

On Wed, Nov 21, 2012 at 02:18:11PM +0100, Julian Wollrath wrote:
> Hello,
> 
> while doing a xfs_fsr or shortly after it I got the following to traces:
> [12859.936850] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> [12859.936952] IP: [<ffffffff811f2008>] xfs_trans_log_inode+0x8/0x30
> [12859.937020] PGD 101efd067 PUD 1020ac067 PMD 0 
> [12859.937075] Oops: 0000 [#1] SMP 
> [12859.937113] Modules linked in: deflate zlib_deflate des_generic ecb sha512_generic sha1_generic hmac af_key xfrm_algo acpi_cpufreq mperf loop fuse snd_hda_codec_conexant snd_hda_codec_hdmi btusb bluetooth crc16 arc4 rtl8192ce rtlwifi rtl8192c_common snd_hda_intel snd_hda_codec rts_pstor(C) snd_hwdep thinkpad_acpi mac80211 snd_pcm uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core radeon snd_page_alloc videodev psmouse cfg80211 evdev nvram pcspkr snd_timer i2c_piix4 i2c_algo_bit drm_kms_helper serio_raw ttm drm agpgart k10temp snd i2c_core rfkill soundcore video ac processor wmi battery button sha256_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod sd_mod crc_t10dif microcode ohci_hcd thermal thermal_sys ahci libahci ehci_hcd atl1c usbcore libata scsi_mod usb_common
> [12859.938008] CPU 0 
> [12859.938035] Pid: 2977, comm: xfs_fsr Tainted: G         C   3.7.0-rc6-wl+ #1 LENOVO 30515YG/30515YG
                                                           ^^^^^

You have a module loaded that is tagged as "crap". IOWs, your
using modules from the staging tree. There should be an earlier
warning in dmesg telling you what it is. Can you reproduce the
problem without a tainted kernel?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
