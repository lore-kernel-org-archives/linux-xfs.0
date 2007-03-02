Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Mar 2007 16:13:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l220DH6p022444
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2007 16:13:18 -0800
Message-ID: <45E76C1C.4040903@sandeen.net>
Date: Thu, 01 Mar 2007 18:13:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can't mount xfs partition
References: <29a617af0703010748g51ef81b1x9c0467602d09793@mail.gmail.com>	 <45E701A2.1020304@sandeen.net> <29a617af0703011611p4ed51bb4g63b1ec0da42143bc@mail.gmail.com>
In-Reply-To: <29a617af0703011611p4ed51bb4g63b1ec0da42143bc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: M Kili <m0kili@gmail.com>, xfs@oss.sgi.com

M Kili wrote:
> On 3/1/07, Eric Sandeen <sandeen@sandeen.net> wrote:
>> M Kili wrote:
>> > xfs_check doesn't give any message, and still, the image can't be
>> > mounted, with the same error:
>> > # mount -o loop hda5.img /mnt/
>> > mount: /dev/loop0: can't read superblock
>>
>> look at dmesg output, see what it says.
> 
> [17206988.072000] SGI XFS with ACLs, security attributes, realtime,
> large block numbers, no debug enabled
> [17206988.072000] SGI XFS Quota Management subsystem
> [17206988.080000] attempt to access beyond end of device
> [17206988.080000] hda5: rw=0, want=39086080, limit=39065600
> [17206988.080000] I/O error in filesystem ("hda5") meta-data dev hda5
> block 0x25467ff       ("xfs_read_buf") error 5 buf count 512
> [17206988.080000] XFS: size check 2 failed
> 
> I guess I must repartition, am I right?

Yep, looks like your partition endpoint is just slightly too small.

-Eric

>>
>> Does "-t xfs" help?
> 
> no
> 
>>
>> -Eric
>>
>>
> 
