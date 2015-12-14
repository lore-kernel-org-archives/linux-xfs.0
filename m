Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 419AF7F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 10:40:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC13AAC004
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 08:40:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bIbD8rWFo87AP2Kp for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2015 08:39:58 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id F16446214D38
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 10:39:57 -0600 (CST)
Subject: Re: XFS and nobarrier with SSDs
References: <E127700EFE58FD45BD6298EAC813FA42020D8173@TIGER2010.xortex.local>
	<3496214.YTSKClH6pV@merkaba> <566E6524.6070401@xortex.com>
	<3911767.qVqsL1TcMv@merkaba> <20151214095823.GA30662@infradead.org>
	<566E978E.2070502@xortex.com> <20151214102750.GA29192@infradead.org>
	<566E9B36.9080509@xortex.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <566EF0DD.8000209@sandeen.net>
Date: Mon, 14 Dec 2015 10:39:57 -0600
MIME-Version: 1.0
In-Reply-To: <566E9B36.9080509@xortex.com>
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
To: xfs@oss.sgi.com



On 12/14/15 4:34 AM, Georg Sch=F6nberger wrote:
> On 2015-12-14 11:27, Christoph Hellwig wrote:
>> On Mon, Dec 14, 2015 at 10:18:54AM +0000, Georg Sch?nberger wrote:
>>>> Or to phrase it
>>>> differently:  If nobarrier makes a difference skipping it is not safe.
>>> I do not fully understand that sentence, what do you mean by "makes a
>>> difference" and "skipping is not safe"?
>> The rule of thumb is: if nobarrier makes your workload run faster you
>> should not be using it, aka: don't use it.
> OK, thanks for clarification.
> Should the XFS FAQ be updated?
> *http://xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_stor=
age_which_has_a_persistent_write_cache.3F

Yes, it should.  I've made some edits, hopefully it's up to date and clear =
now.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
