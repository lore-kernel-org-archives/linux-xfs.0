Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34EDA7F8C
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 12:09:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1396B304032
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 10:09:16 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id Huzfbxaty5wb1Tq6
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 02 Feb 2014 10:09:14 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: relationship of nested stripe sizes,
	was: Question regarding XFS on LVM over hardware RAID.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52ED6AAF.6030703@hardwarefreak.com>
Date: Sun, 2 Feb 2014 11:09:11 -0700
Message-Id: <98961D3F-769D-44A9-98A8-FC7867893138@colorremedies.com>
References: <7A732267-B34F-4286-9B49-3AF8767C0B89@colorremedies.com>	<52ED4143.6090303@hardwarefreak.com>
	<EDBD7355-F1EC-4773-9138-CA864CB2E84B@colorremedies.com>
	<52ED6AAF.6030703@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>
Cc: xfs <xfs@oss.sgi.com>


On Feb 1, 2014, at 2:44 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 2/1/2014 2:55 PM, Chris Murphy wrote:
>> =

>> On Feb 1, 2014, at 11:47 AM, Stan Hoeppner <stan@hardwarefreak.com>
>> wrote:
>> =

>>> On 1/31/2014 12:35 AM, Chris Murphy wrote:
>>>> Hopefully this is an acceptable way to avoid thread jacking, by =

>>>> renaming the  subject=85
>>>> =

>>>> On Jan 30, 2014, at 10:58 PM, Stan Hoeppner
>>>> <stan@hardwarefreak.com> wrote:
>>>>> =

>>>>> RAID60 is a nested RAID level just like RAID10 and RAID50.  It
>>>>> is a stripe, or RAID0, across multiple primary array types,
>>>>> RAID6 in this case.  The stripe width of each 'inner' RAID6
>>>>> becomes the stripe unit of the 'outer' RAID0 array:
>>>>> =

>>>>> RAID6 geometry	 128KB * 12 =3D 1536KB RAID0 geometry  1536KB * 3
>>>>> =3D 4608KB
>>>> =

>>>> My question is on this particular point. If this were hardware
>>>> raid6, but I wanted to then stripe using md raid0, using the
>>>> numbers above would I choose a raid0 chunk size of 1536KB? How
>>>> critical is this value for, e.g. only large streaming read/write
>>>> workloads? If it were smaller, say 256KB or even 32KB, would
>>>> there be a significant performance consequence?
>>> =

>>> You say 'if it were smaller...256/32KB'.  What is "it"
>>> referencing?
>> =

>> it =3D chunk size for md raid0.
>> =

>> So chunk size 128KB * 12 disks, hardware raid6. Chunk size 32KB [1]
>> striping the raid6's with md raid0.
> =

> Frankly, I don't know whether you're pulling my chain, or really don't
> understand the concept of nested striping.  I'll assume the latter.

The former would be inappropriate, and the latter is more plausible anyway,=
 so this is the better assumption.


> When nesting stripes, the chunk size of the outer stripe is -always-
> equal to the stripe width of each inner striped array, as I clearly
> demonstrated earlier:

Except when it's hardware raid6, and software raid0, and the user doesn't k=
now they need to specify the chunk size in this manner. And instead they us=
e the mdadm default. What you're saying makes complete sense, but I don't t=
hink this is widespread knowledge or well documented anywhere that regular =
end users would know this by and large.

> =

> 3 RAID6 arrays
> RAID6  geometry	 128KB * 12 =3D 1536KB
> RAID60 geometry 1536KB *  3 =3D 4608KB
> =

> mdadm allows you enough rope to hang yourself in this situation because
> it doesn't know the geometry of the underlying hardware arrays, and has
> no code to do sanity checking even if it did.  Thus it can't save you
> from yourself.

That's right, and this is the exact scenario I'm suggesting. Depending on v=
ersion, mdadm has two possible default chunk sizes, either 64KB or 512KB.

How bad is the resulting performance hit? Would a 64KB chunk be equally bad=
 as a 512KB chunk? Or is this only quantifiable with testing (i.e. it could=
 be a negligible performance hit, or it could be huge)?


> RAID HBA and SAN controller firmware simply won't allow this.  They
> configure the RAID60 chunk size automatically equal to the RAID6 stripe
> width.  If some vendor's firmware allows one to manually enter the
> RAID60 chunk size with a value different from the RAID6 stripe width,
> stay away from that vendor.

I understand that, but the scenario and question I'm posing is for multiple=
 hardware raid6's striped with md raid0. The use case are enclosures with r=
aid6 but not raid60, so the enclosures are striped using software raid. I'm=
 trying to understand the consequence magnitude when choosing an md raid0 c=
hunk size other than the correct one. Is this a 5% performance hit, or a 30=
% performance hit?


Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
