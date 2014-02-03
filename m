Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6E907FC7
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 04:50:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6908CAC008
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 02:50:55 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id aXivEGiDeuDd5xlr
	for <xfs@oss.sgi.com>; Mon, 03 Feb 2014 02:50:54 -0800 (PST)
Message-ID: <52EF748E.3010700@hardwarefreak.com>
Date: Mon, 03 Feb 2014 04:50:54 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: relationship of nested stripe sizes, was: Question regarding
	XFS on LVM over hardware RAID.
References: <7A732267-B34F-4286-9B49-3AF8767C0B89@colorremedies.com>	<52ED4143.6090303@hardwarefreak.com>	<EDBD7355-F1EC-4773-9138-CA864CB2E84B@colorremedies.com>	<52ED6AAF.6030703@hardwarefreak.com>
	<98961D3F-769D-44A9-98A8-FC7867893138@colorremedies.com>
In-Reply-To: <98961D3F-769D-44A9-98A8-FC7867893138@colorremedies.com>
Reply-To: stan@hardwarefreak.com
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
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs <xfs@oss.sgi.com>

On 2/2/2014 12:09 PM, Chris Murphy wrote:
> =

> On Feb 1, 2014, at 2:44 PM, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> =

>> On 2/1/2014 2:55 PM, Chris Murphy wrote:
>>> =

>>> On Feb 1, 2014, at 11:47 AM, Stan Hoeppner
>>> <stan@hardwarefreak.com> wrote:
>>> =

>>>> On 1/31/2014 12:35 AM, Chris Murphy wrote:
>>>>> Hopefully this is an acceptable way to avoid thread jacking,
>>>>> by renaming the  subject=85
>>>>> =

>>>>> On Jan 30, 2014, at 10:58 PM, Stan Hoeppner =

>>>>> <stan@hardwarefreak.com> wrote:
>>>>>> =

>>>>>> RAID60 is a nested RAID level just like RAID10 and RAID50.
>>>>>> It is a stripe, or RAID0, across multiple primary array
>>>>>> types, RAID6 in this case.  The stripe width of each
>>>>>> 'inner' RAID6 becomes the stripe unit of the 'outer' RAID0
>>>>>> array:
>>>>>> =

>>>>>> RAID6 geometry	 128KB * 12 =3D 1536KB RAID0 geometry  1536KB
>>>>>> * 3 =3D 4608KB
>>>>> =

>>>>> My question is on this particular point. If this were
>>>>> hardware raid6, but I wanted to then stripe using md raid0,
>>>>> using the numbers above would I choose a raid0 chunk size of
>>>>> 1536KB? How critical is this value for, e.g. only large
>>>>> streaming read/write workloads? If it were smaller, say 256KB
>>>>> or even 32KB, would there be a significant performance
>>>>> consequence?
>>>> =

>>>> You say 'if it were smaller...256/32KB'.  What is "it" =

>>>> referencing?
>>> =

>>> it =3D chunk size for md raid0.
>>> =

>>> So chunk size 128KB * 12 disks, hardware raid6. Chunk size 32KB
>>> [1] striping the raid6's with md raid0.
>> =

>> Frankly, I don't know whether you're pulling my chain, or really
>> don't understand the concept of nested striping.  I'll assume the
>> latter.
> =

> The former would be inappropriate, and the latter is more plausible
> anyway, so this is the better assumption.
> =

> =

>> When nesting stripes, the chunk size of the outer stripe is
>> -always- equal to the stripe width of each inner striped array, as
>> I clearly demonstrated earlier:
> =

> Except when it's hardware raid6, and software raid0, and the user
> doesn't know they need to specify the chunk size in this manner. And
> instead they use the mdadm default. What you're saying makes complete
> sense, but I don't think this is widespread knowledge or well
> documented anywhere that regular end users would know this by and
> large.

This is not widespread knowledge and is not well documented.  And by
definition "regular end users" are not creating RAID60 arrays.  In the
not too distant future there will be a little more information available
about proper geometry setup for RAID60.

>> 3 RAID6 arrays =

>> RAID6  geometry	 128KB * 12 =3D 1536KB
>> RAID60 geometry	1536KB *  3 =3D 4608KB
>> =

>> mdadm allows you enough rope to hang yourself in this situation
>> because it doesn't know the geometry of the underlying hardware
>> arrays, and has no code to do sanity checking even if it did.  Thus
>> it can't save you from yourself.
> =

> That's right, and this is the exact scenario I'm suggesting.
> Depending on version, mdadm has two possible default chunk sizes,
> either 64KB or 512KB.
> =

> How bad is the resulting performance hit? Would a 64KB chunk be
> equally bad as a 512KB chunk? Or is this only quantifiable with
> testing (i.e. it could be a negligible performance hit, or it could
> be huge)?

...
>> RAID HBA and SAN controller firmware simply won't allow this.
>> They configure the RAID60 chunk size automatically equal to the
>> RAID6 stripe width.  If some vendor's firmware allows one to
>> manually enter the RAID60 chunk size with a value different from
>> the RAID6 stripe width, stay away from that vendor.
> =

> I understand that, but the scenario and question I'm posing is for
> multiple hardware raid6's striped with md raid0. The use case are
> enclosures with raid6 but not raid60, so the enclosures are striped
> using software raid. I'm trying to understand the consequence
> magnitude when choosing an md raid0 chunk size other than the correct
> one. Is this a 5% performance hit, or a 30% performance hit?

You must answer other questions before you can answer those above, as
this is entirely workload dependent, as everything always is.  It also
depends on whether or how you aligned XFS.  The wrong outer stripe chunk
size may badly hurt performance, or it may not affect it much at all.
Depends on what/how you're writing, and the demands of the workload.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
