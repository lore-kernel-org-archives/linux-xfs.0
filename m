Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 08:33:53 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QFXlTe008430
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 08:33:48 -0700
Message-ID: <46FA7BC2.5050903@thebarn.com>
Date: Wed, 26 Sep 2007 10:33:22 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: XFS DMAPI support for RHEL4
References: <cce360c30709260650o728bc046ic90fc0e0c726bd78@mail.gmail.com> <cce360c30709260651k17c80518k555f174af3fafb54@mail.gmail.com> <46FA7579.9090403@sandeen.net>
In-Reply-To: <46FA7579.9090403@sandeen.net>
Content-Type: multipart/mixed;
 boundary="------------040907080408040109000409"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Manoj Kumar Pradhan <manojkp80@gmail.com>, linux-xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------040907080408040109000409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eric Sandeen wrote:
> Manoj Kumar Pradhan wrote:
>   
>> Hi,
>>
>> I am running RHEL with kernel 2.6.9-42ELsmp x86_64. I got the xfs module
>> from http://sandeen.net/rhel4_xfs/ and did a rpmbuild as instructed there, I
>> got the xfs.ko and the module-xfs rpm for the running kernel too but modinfo
>> shows me that the xfs module hence created is not dmapi enabled.
>>     
>
> Right, the dmapi module isn't included in that.  As far as I can recall,
> the necessary bits to support DMAPI are not present in the RHEL4 kernel,
> so this is probably not going to work.  Perhaps the sgi guys can chime
> in if I'm off base.
>
> -Eric
>
>   
Isn't there a rhel4 patch floating around someplace? :-)

>> [root@asher RPMS]# modinfo xfs
>> filename:       /lib/modules/2.6.9-42.ELsmp/kernel/fs/xfs/xfs.ko
>> license:        GPL
>> description:    SGI XFS with ACLs, security attributes, realtime, large
>> block/inode numbers, no debug enabled
>> author:         Silicon Graphics, Inc.
>> depends:
>> vermagic:       2.6.9-42.ELsmp SMP gcc-3.4
>>
>> When I run a simple app which tries to init dmapi for XFS it fails with
>> ENOSYS.
>> Did I miss anything here? How do I enable DMAPI on this XFS module?
>>
>> Thanks,
>> Manoj
>>
>>
>> [[HTML alternate version deleted]]
>>
>>
>>     
>
>   


--------------040907080408040109000409
Content-Type: text/x-vcard; charset=utf-8;
 name="cattelan.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cattelan.vcf"

begin:vcard
fn:Russell Cattelan
n:Cattelan;Russell
email;internet:cattelan@thebarn.com
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------040907080408040109000409--
