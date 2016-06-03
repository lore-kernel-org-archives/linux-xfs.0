Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 80A1D7CA0
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 12:43:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 52F8E3040D4
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 10:43:27 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id WSmg7yU0gJ5Eu30O (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2016 10:43:24 -0700 (PDT)
Subject: Re: _xfs_buf_ioapply: no ops on block 0x188e78/0x8 on vanilla 4.4.11
References: <57503353.2050402@profihost.ag>
	<57503D33.6010000@applied-asynchrony.com>
	<575040D8.8070903@applied-asynchrony.com>
	<20160602222545.GO12670@dastard>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <5751C1B9.90709@profihost.ag>
Date: Fri, 3 Jun 2016 19:43:21 +0200
MIME-Version: 1.0
In-Reply-To: <20160602222545.GO12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>, =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 03.06.2016 um 00:25 schrieb Dave Chinner:
> On Thu, Jun 02, 2016 at 04:21:12PM +0200, Holger Hoffst=E4tte wrote:
>> On 06/02/16 16:05, Holger Hoffst=E4tte wrote:
>>> On 06/02/16 15:23, Stefan Priebe - Profihost AG wrote:
>>>> I found a bug report from redhat here
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1234586 pointing to this=
 commit:
>>>> xfs: handle dquot buffer readahead in log recovery correctly
>>>>
>>>> which isn't part of 4.4. Is it missing from linux-stable?
>>>
>>> Yes, mainline 7d6a13f02356 is missing from 4.4-stable because it applie=
s,
>>> but doesn't compile. :)
>>>
>>> I'll look into a fix.
>>
>> Well, that was easy. It also needs 233135b763 ("xfs: print name of verif=
ier
>> if it fails") which added a .name to the various xfs_buf_ops types.
>> Can someone confirm that these can both go into 4.4-stable?
> =

> You could just remove the line:
> =

> +       .name =3D "xfs_dquot_ra",
> =

> from 7d6a13f02356 and that will fix the backport problem and not
> require any other commits to be backported. I'm fine with either
> solution.
> =


Great. Should be push that one to greg?

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
