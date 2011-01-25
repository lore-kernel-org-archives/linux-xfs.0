Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0PEJk3t023785 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 08:19:47 -0600
Received: from zixvpm01.zixvpm.davisvision.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A04381057764
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 06:22:09 -0800 (PST)
Received: from zixvpm01.zixvpm.davisvision.com
	(zixvpm01.zixvpm.davisvision.com [65.213.99.44]) by
	cuda.sgi.com with ESMTP id ZSKYa0lq3BVIHQns for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 06:22:09 -0800 (PST)
Received: from zixvpm01.zixvpm.davisvision.com (ZixVPM [127.0.0.1])
	by Outbound.davisvision.com (Proprietary) with ESMTP id 41A828CC032
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 09:22:08 -0500 (EST)
Message-ID: <12688_1295965327_4D3EDC8F_12688_221_1_4D3EDC8F.5070403@davisvision.com>
Date: Tue, 25 Jan 2011 09:22:07 -0500
From: Cory Coager <ccoager@davisvision.com>
MIME-Version: 1.0
Subject: Re: extremely slow write performance plaintext
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>	<20110113233527.6dca104d@galadriel.home>	<18993_1294964274_4D2F9632_18993_1387_1_F79CF9ADB27B2646B59221B7355263830CC143B1@NYL-EXCH1.HVHCVision.com>	<4D30A945.4060000@hardwarefreak.com>	<27616_1295038110_4D30B69E_27616_233_1_4D30B69E.4020506@davisvision.com>	<4D30C7F3.3040105@hardwarefreak.com>	<1779_1295360207_4D35A0CF_1779_747_1_4D35A0CF.9050503@davisvision.com>
	<4D36B5EA.6040603@hardwarefreak.com>
In-Reply-To: <4D36B5EA.6040603@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On 01/19/2011 04:59 AM, Stan Hoeppner wrote:
> Then, logically, there is something different about this logical volume than the
> others.  All of them reside atop the same volume group, atop the same two
> physical RAID6 arrays, correct?  Since I'm not quite tired of playing dentist (yet):
>
> 1. Were all of the LVs created with the same parameters?  If so, can you
> demonstrate verification of this to us?
Yes...
pvcreate --metadatacopies 2 /dev/cciss/c1d0p1
pvcreate --metadatacopies 2 /dev/cciss/c1d1p1
vgcreate vg0 /dev/cciss/c1d0p1 /dev/cciss/c1d1p1
lvcreate -n shared -L 2.1T /dev/vg0
lvcreate -n homes -L 810G /dev/vg0
> 2. Are all of them formatted with XFS?  Were all formatted with the same XFS
> parameters?  If so, can you demonstrate verification of this to us?
mkfs.xfs -L homes -i attr=2,size=1024 -l 
version=2,size=128m,lazy-count=1 /dev/vg0/homes
mkfs.xfs -L shared -i attr=2,size=1024 -l 
version=2,size=128m,lazy-count=1 /dev/vg0/shared
> 3. Are you encrypting, at some level, the one LV that is showing low performance?
>
> Cory:  "The two arrays were added to a volume group and multiple logical volumes
> were created."
No encryption
> 4. Was this volume group preexisting?  Are there other storage devices in this
> volume group, or _only_ the RAID6 arrays?
Everything is new, hardware, LV's, file systems...
> 5. Have you attempted deleting and recreating the LV with the performance issue?
No and I don't have the room to recreate this LV
> 6. How many total logical volumes are in this volume group?
6
> 7. What Linux distribution are you using?  What kernel version?
SLES 10 SP2, 2.6.16.60-0.21-bigsmp i686
>
> We are not magicians here Cory.  We need as much data from you as possible or we
> can't help you.  I thought I made this clear earlier.  You need to gather as
> much relevant data from that box as you can and present it here if you're
> serious about solving this issue.
>
> I get the feeling you just don't really care.  In which case, why did you even
> ask for help in the first place?  Troubleshooting this issue requires your
> _full_ participation and effort.
>
> In these situations, it is most often the OP who solves his/her own issue, after
> providing enough information here that we can point the OP in the right
> direction.  The key here is "providing enough information".
Sorry I'm not trying to withhold information.  Whatever you need to know 
just ask and I'll be happy to provide it.



------------------------------------------------------------------------
The information contained in this communication is intended
only for the use of the recipient(s) named above. It may
contain information that is privileged or confidential, and
may be protected by State and/or Federal Regulations. If
the reader of this message is not the intended recipient,
you are hereby notified that any dissemination,
distribution, or copying of this communication, or any of
its contents, is strictly prohibited. If you have received
this communication in error, please return it to the sender
immediately and delete the original message and any copy
of it from your computer system. If you have any questions
concerning this message, please contact the sender.
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
