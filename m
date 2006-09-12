Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Sep 2006 05:09:15 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8CC8nif007051
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 05:08:59 -0700
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k8CAqAnx002180
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 05:52:10 -0500
Received: from omx2.sgi.com ([198.149.32.25])
	by imr2.americas.sgi.com (8.12.9/8.12.10/SGI_generic_relay-1.2) with ESMTP id k8CAp9Du52978074
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 03:51:09 -0700 (PDT)
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k8CDQuPO009272
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 06:26:56 -0700
Received: from omx2.sgi.com ([198.149.32.25])
	by internal-mail-relay1.corp.sgi.com (8.12.9/8.12.10/SGI_generic_relay-1.2) with ESMTP id k8CAqA8s39440226
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 03:52:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with SMTP id k8CDQqJb009268
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 06:26:54 -0700
Message-ID: <4506831A.3000001@sgi.com>
Date: Tue, 12 Sep 2006 19:51:22 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Mounting IRIX disk on Linux
References: <45053B2D.50203@crc.dk> <4505712E.5070801@oss.sgi.com> <4506529F.9030109@crc.dk>
In-Reply-To: <4506529F.9030109@crc.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mogens Kjaer <mk@crc.dk>
Cc: linux-xfs@oss.sgi.com

Hi Mogens,

Mogens Kjaer wrote:
> linux-xfs@oss.sgi.com wrote:
>> Mogens Kjaer wrote:
>>
>>> How do I determine which of the requirements
>>> listed in:
>>>
>>> http://oss.sgi.com/projects/xfs/faq.html#useirixxfs
>>>
>>> that hasn't been fulfilled?
>>
>> # xfs_db /dev/<device>
>> xfs_db> sb 0
>> xfs_db> p
> 
> This gives me:
> 

> versionnum = 0x1084

#define XFS_SB_VERSION_DIRV2BIT         0x2000

So, yes it doesn't look like you have v2 directories
and there is no support for it in Linux.

BTW, on xfs_db on Linux you can show this using the version command
if it is recent enough.
e.g.
# xfs_db -c version -r /dev/sda6
versionnum [0x3084+0x0] = V4,ALIGN,DIRV2,EXTFLG


> 
> How do I interprete this?
above

> 
> My guess is that this fs does not have directory
> format 2, it might have been made before IRIX 6.5.5
yep, sorry.

--Tim
