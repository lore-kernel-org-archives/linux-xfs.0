Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A62127F58
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 15:44:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 87C6B8F804C
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 13:44:17 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id rcNEBqfwCkCloyll
	for <xfs@oss.sgi.com>; Sat, 01 Feb 2014 13:44:16 -0800 (PST)
Message-ID: <52ED6AAF.6030703@hardwarefreak.com>
Date: Sat, 01 Feb 2014 15:44:15 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: relationship of nested stripe sizes, was: Question regarding
	XFS on LVM over hardware RAID.
References: <7A732267-B34F-4286-9B49-3AF8767C0B89@colorremedies.com>	<52ED4143.6090303@hardwarefreak.com>
	<EDBD7355-F1EC-4773-9138-CA864CB2E84B@colorremedies.com>
In-Reply-To: <EDBD7355-F1EC-4773-9138-CA864CB2E84B@colorremedies.com>
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

On 2/1/2014 2:55 PM, Chris Murphy wrote:
> =

> On Feb 1, 2014, at 11:47 AM, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> =

>> On 1/31/2014 12:35 AM, Chris Murphy wrote:
>>> Hopefully this is an acceptable way to avoid thread jacking, by =

>>> renaming the  subject=85
>>> =

>>> On Jan 30, 2014, at 10:58 PM, Stan Hoeppner
>>> <stan@hardwarefreak.com> wrote:
>>>> =

>>>> RAID60 is a nested RAID level just like RAID10 and RAID50.  It
>>>> is a stripe, or RAID0, across multiple primary array types,
>>>> RAID6 in this case.  The stripe width of each 'inner' RAID6
>>>> becomes the stripe unit of the 'outer' RAID0 array:
>>>> =

>>>> RAID6 geometry	 128KB * 12 =3D 1536KB RAID0 geometry  1536KB * 3
>>>> =3D 4608KB
>>> =

>>> My question is on this particular point. If this were hardware
>>> raid6, but I wanted to then stripe using md raid0, using the
>>> numbers above would I choose a raid0 chunk size of 1536KB? How
>>> critical is this value for, e.g. only large streaming read/write
>>> workloads? If it were smaller, say 256KB or even 32KB, would
>>> there be a significant performance consequence?
>> =

>> You say 'if it were smaller...256/32KB'.  What is "it"
>> referencing?
> =

> it =3D chunk size for md raid0.
> =

> So chunk size 128KB * 12 disks, hardware raid6. Chunk size 32KB [1]
> striping the raid6's with md raid0.

Frankly, I don't know whether you're pulling my chain, or really don't
understand the concept of nested striping.  I'll assume the latter.

When nesting stripes, the chunk size of the outer stripe is -always-
equal to the stripe width of each inner striped array, as I clearly
demonstrated earlier:

3 RAID6 arrays
RAID6  geometry	 128KB * 12 =3D 1536KB
RAID60 geometry 1536KB *  3 =3D 4608KB

mdadm allows you enough rope to hang yourself in this situation because
it doesn't know the geometry of the underlying hardware arrays, and has
no code to do sanity checking even if it did.  Thus it can't save you
from yourself.

RAID HBA and SAN controller firmware simply won't allow this.  They
configure the RAID60 chunk size automatically equal to the RAID6 stripe
width.  If some vendor's firmware allows one to manually enter the
RAID60 chunk size with a value different from the RAID6 stripe width,
stay away from that vendor.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
