Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FBCE7F52
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 14:55:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6C24F8F8040
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 12:55:22 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id MZfrCgwftKYUmmgh
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 01 Feb 2014 12:55:17 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: relationship of nested stripe sizes,
	was: Question regarding XFS on LVM over hardware RAID.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52ED4143.6090303@hardwarefreak.com>
Date: Sat, 1 Feb 2014 13:55:16 -0700
Message-Id: <EDBD7355-F1EC-4773-9138-CA864CB2E84B@colorremedies.com>
References: <7A732267-B34F-4286-9B49-3AF8767C0B89@colorremedies.com>
	<52ED4143.6090303@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: xfs <xfs@oss.sgi.com>


On Feb 1, 2014, at 11:47 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 1/31/2014 12:35 AM, Chris Murphy wrote:
>> Hopefully this is an acceptable way to avoid thread jacking, by
>> renaming the  subject=85
>> =

>> On Jan 30, 2014, at 10:58 PM, Stan Hoeppner <stan@hardwarefreak.com>
>> wrote:
>>> =

>>> RAID60 is a nested RAID level just like RAID10 and RAID50.  It is
>>> a stripe, or RAID0, across multiple primary array types, RAID6 in
>>> this case.  The stripe width of each 'inner' RAID6 becomes the
>>> stripe unit of the 'outer' RAID0 array:
>>> =

>>> RAID6 geometry	 128KB * 12 =3D 1536KB RAID0 geometry  1536KB * 3  =3D
>>> 4608KB
>> =

>> My question is on this particular point. If this were hardware raid6,
>> but I wanted to then stripe using md raid0, using the numbers above
>> would I choose a raid0 chunk size of 1536KB? How critical is this
>> value for, e.g. only large streaming read/write workloads? If it were
>> smaller, say 256KB or even 32KB, would there be a significant
>> performance consequence?
> =

> You say 'if it were smaller...256/32KB'.  What is "it" referencing?

it =3D chunk size for md raid0. =


So chunk size 128KB * 12 disks, hardware raid6. Chunk size 32KB [1] stripin=
g the raid6's with md raid0.


Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
