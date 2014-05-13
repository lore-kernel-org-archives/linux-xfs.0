Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07EA87F47
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 02:07:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D21638F80DE
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 00:07:51 -0700 (PDT)
Received: from mout.web.de (mout.web.de [212.227.15.14]) by cuda.sgi.com with
	ESMTP id Vd3PdUr7cgTjyjXR (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 00:07:50 -0700 (PDT)
Message-ID: <5371C4BC.2010902@web.de>
Date: Tue, 13 May 2014 09:07:40 +0200
From: Matthias Neuer <mneuer@web.de>
MIME-Version: 1.0
Subject: Re: xfs spanning over ssd and hdd
References: <5370C592.6080402@web.de> <5370D8AA.2010003@sandeen.net>
In-Reply-To: <5370D8AA.2010003@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hi.

On 05/12/2014 04:20 PM, Eric Sandeen wrote:
> On 5/12/14, 7:58 AM, Matthias Neuer wrote:
>> Hi.
>>
>> I have a slow and big hdd and a fast but small ssd and want to test the following setup but don't know if it's possible.
>>
>> Use LVM to concatenate the ssd and the hdd linearly. Create a xfs filesystem on this device such that the sdd is filled first, i.e. data is written to the ssd as long as there is free space, otherwise the data is written to the hdd.
>>
>> I have applications which may benefit from this setup but I am not sure so I need to do some benchmarks.
>
> XFS doesn't fill from the front, so you can't configure things to fill the HDD first.
>
> Files in new directories rotor around the allocation groups on the filesystem, so all regions of the fs are filled more or less evenly.
>

Ok, thanks for the info. I fear that xfs is too intelligent because 
filling the device from front to rear seems to be a simple policy.
Maybe I should try FAT16 :)

Thanks
Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
