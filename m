Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7U8d4vp014144 for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 03:39:14 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C926E40DCAB
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 01:39:29 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id uylPiguyhYZo50Ra for
	<xfs@oss.sgi.com>; Sun, 30 Aug 2009 01:39:29 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: zero size file after power failure with kernel 2.6.30.5
Date: Sun, 30 Aug 2009 10:39:04 +0200
References: <200908292102.21710@zmi.at>
	<alpine.DEB.2.00.0908291517350.24777@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0908291517350.24777@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908301039.05303@zmi.at>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

On Samstag 29 August 2009 Justin Piszcz wrote:
> I was curious if you could show your smartctl -a output?
>
> smartctl -a /dev/sda

Here the important parts of it:
Device Model:     WDC WD1500HLFS-01G6U0
Firmware Version: 04.04V01
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0003   190   185   021    Pre-fail  Always       -       1466
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       48
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000e   200   200   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   092   092   000    Old_age   Always       -       6282
 10 Spin_Retry_Count        0x0012   100   253   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0012   100   253   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       48
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       13
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       48
194 Temperature_Celsius     0x0022   112   102   000    Old_age   Always       -       31
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0

PNum  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      6274         -
# 2  Extended offline    Completed without error       00%      6251         -
# 3  Short offline       Completed without error       00%      6250         -
# 4  Short offline       Completed without error       00%      6226         -
# 5  Short offline       Completed without error       00%      6202         -
# 6  Short offline       Completed without error       00%      6187         -
# 7  Extended offline    Completed without error       00%      6167         -
# 8  Short offline       Completed without error       00%      6145         -
# 9  Short offline       Completed without error       00%      6121         -
#10  Short offline       Completed without error       00%      6097         -
#11  Extended offline    Completed without error       00%      6090         -
#12  Extended offline    Completed without error       00%      6024         -
#13  Short offline       Completed without error       00%      3613         -
#14  Short offline       Completed without error       00%      3589         -
#15  Extended offline    Completed without error       00%      3567         -
#16  Short offline       Completed without error       00%      3565         -
#17  Short offline       Completed without error       00%      3541         -
#18  Short offline       Completed without error       00%      3517         -
#19  Short offline       Completed without error       00%      3493         -
#20  Short offline       Completed without error       00%      3469         -
#21  Short offline       Completed without error       00%      3445         -

> The SU issue most likely resulted in the xfs file going to 0 issue
> (i see the same thing on occasion during a PSU issue or crash/reboot)

Yes, and that's annoying. I've never had that for reiserfs, so I guess it's really XFS 
to blame here. I like that filesystem, but such things really shouldn't happen.

> however I am curious to see if you see any of the issues here:
> http://forums.storagereview.net/index.php?showtopic=27303&hl=velociraptor
>
> Since you only use one drive and not a raid of the WD Velociraptors,
> you may not be affected, but I was curious, thanks.

In fact I use 3 VelociRaptor 150GB and 6 Raptors. 8 are in a single RAID-6
in a server running since about 3 years, and during this time 2 Raptors
died and were replaced by VelociRaptors. The one I use in my desktop
is a spare spart to use in case the server needs one. I just use it because
the speed is nice, and I see if it has failures.
Smartctl is running as a daemon here, so you can see the SMART self
tests. It's almost definitely not the drive.

mfg zmi
-- 
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
