Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 213CB7F7E
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 10:47:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 596CB8F80A1
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 08:47:45 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jUKCI1aLVbmGqNvi for
	<xfs@oss.sgi.com>; Wed, 06 Mar 2013 08:47:44 -0800 (PST)
Message-ID: <5137732B.3010703@redhat.com>
Date: Wed, 06 Mar 2013 11:47:39 -0500
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
In-Reply-To: <CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Julien FERRERO <jferrero06@gmail.com>
Cc: xfs@oss.sgi.com

On 03/06/2013 11:16 AM, Julien FERRERO wrote:
> Hi Emmanuel
>
> 2013/3/6 Emmanuel Florac <eflorac@intellique.com>:
>> Le Wed, 6 Mar 2013 16:08:59 +0100 vous =E9criviez:
>>
>>> I am totally stuck and I really don't know how to duplicate the
>>> corruption. I only know that units are used to be power cycle by
>>> operator while the fs is still mounted (no proper shutdown / reboot).
>>> My guess is the fs journal shall handle this case and avoid such
>>> corruption.
>> Wrong guess. It may work or not, depending upon a long list of
>> parameters, but basically not turning it off properly is asking for
>> problems and corruptions. The problem will be tragically aggravated if
>> your hardware RAID doesn't have a battery backed-up cache.
>>
> OK but our server is 95% of the time reading data and 5% of the time
> writing data. We have a case of a server that did not write anything
> at the time of failure (and during all the uptime session). Moreover,
> failure occurs to files that were opened in read-only or weren't
> accessed at all at the time of failure. I don't think the H/W RAID is
> the issue since we have the same corruption with other setup without
> H/W RAID.
>
> Does the "ls" output with "???" looks like a fs corruption ?
>

Caching can hold dirty data in volatile cache for a very long time. Even if=
 you =

open a file in "read-only" mode, you still do a fair amount of writes to =

storage. You can use blktrace or similar tool to see just how much data is =
written.

As mentioned earlier, you always must unmount cleanly as a best practice. A=
n =

operator that powers off with mounted file systems need educated or let go =
:)

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
