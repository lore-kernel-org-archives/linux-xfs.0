Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2434B7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 15:04:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3565AC005
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 13:04:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HrNg66cVXpE9dVPq for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 13:04:38 -0700 (PDT)
Message-ID: <55DCCA55.4010901@sandeen.net>
Date: Tue, 25 Aug 2015 15:04:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Cant mount xfs lvm. Experimental Features?
References: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>	<20150825115412.GI714@dastard>	<5ab00519660fd5ed1b3d347658dba1f2@zbfmail.de>	<55DCB158.20505@sandeen.net>
	<accadc1d9218bdf0935af4bb1f1446f7@zbfmail.de>
In-Reply-To: <accadc1d9218bdf0935af4bb1f1446f7@zbfmail.de>
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
To: weber@zbfmail.de, Xfs <xfs@oss.sgi.com>

On 8/25/15 2:26 PM, Marko Weber|8000 wrote:

>>> pvdisplay shows:
>>>
>>> # pvdisplay
>>>   --- Physical volume ---
>>>   PV Name               /dev/md4
>>>   VG Name               VolGroup01
>>>   PV Size               2.69 TiB / not usable 1.25 MiB
>>>
>>>
>>> so what is XFS missing?
>>
>> what does blkid /dev/md4 say?
>>
>> It looks like you might have a storage problem, now, and xfs can't
>> even find a proper magic number on that device.
> 
> smartcl says all is ok.
> AND the othetr two lvm partitions get mounted well....
> 
> blkid output:
> 
> ~ # blkid /dev/md4
> /dev/md4: UUID="7LYlkp-33ro-qyal-yGkZ-pMwC-Ei1L-Viy4UJ" TYPE="LVM2_member"

Sorry, I shouldn't have asked for /dev/md4; that's your physical volume,
not a logical volume.  I meant to ask for blkid of whatever dm-2 is.

Anyway, from:

> Aug 25 18:44:01 backupserver kernel: XFS (dm-2): Invalid superblock magic number

it seems that the dm-2 device doesn't actually contain an xfs filesystem,
so this looks like a storage config problem, not an xfs problem.

-Eric

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
