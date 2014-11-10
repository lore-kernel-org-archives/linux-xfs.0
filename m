Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC2DA7F60
	for <xfs@oss.sgi.com>; Sun,  9 Nov 2014 20:57:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB02D8F8033
	for <xfs@oss.sgi.com>; Sun,  9 Nov 2014 18:57:48 -0800 (PST)
Received: from BLU004-OMC2S13.hotmail.com (blu004-omc2s13.hotmail.com
	[65.55.111.88]) by cuda.sgi.com with ESMTP id F8MeHa3hFMYILocd
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 09 Nov 2014 18:57:47 -0800 (PST)
Message-ID: <BLU175-W22D101D3171CC1568812B3DF800@phx.gbl>
From: GuangYang <yguang11@outlook.com>
Subject: RE: EIO and data corruption on XFS file system
Date: Mon, 10 Nov 2014 02:57:47 +0000
In-Reply-To: <545BB62C.5020603@hardwarefreak.com>
References: <BLU175-W376F83659C1C70DE51C3D9DF840@phx.gbl>,
	<545BB62C.5020603@hardwarefreak.com>
MIME-Version: 1.0
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
To: Stan Hoeppner <stan@hardwarefreak.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks Stan. My comments inline...

----------------------------------------
> Date: Thu, 6 Nov 2014 11:55:56 -0600
> From: stan@hardwarefreak.com
> To: yguang11@outlook.com; xfs@oss.sgi.com
> Subject: Re: EIO and data corruption on XFS file system
>
> On 11/06/2014 07:03 AM, GuangYang wrote:
>> Hello,
>> While working on the storage system, I got one question in terms of the
>> XFS utilities to fix file system corruption. Basically, our storage
>> system put 3 copies of data and the system would detect data
>> inconsistency on regular basis, there are two patterns we observed so
>> far: 1) the data is corrupted which result in an EIO, 2) data is still
>> accessible but the content is changed.
>>
>> I am wondering the way to fix such issues from file system's
>> perspective, do we expect hardware failure for both cases or some xfs
>> repairing tools could help for such case?
>
> xfs_repair addresses filesystem metadata inconsistencies/corruption. It
> does not inspect file contents. If a file is corrupted xfs_repair can
> do nothing for you. If you're seeing inconsistencies in file data the
> problem is not XFS but something else, possibly hardware, as you suspect.
>
> What hardware is this? What RAID controllers?
We are using the following disk:
Disk:	sdl (hpsa0): 6.0TB (23%) RAID-0 == 1 x 6TB 7.2K SATA 300MB/s ATA-ST6000NM0024-1HT
and controller:
Disk-Control:	hpsa0: HP Smart Array P410, FW 6.40, Cache on 0B/512MB (R/W), BBU
>
> Cheers,
> Stan
>
 		 	   		  
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
