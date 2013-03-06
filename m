Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 86FA27CBF
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 10:16:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 472688F8074
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 08:16:37 -0800 (PST)
Received: from mail-bk0-f44.google.com (mail-bk0-f44.google.com
	[209.85.214.44]) by cuda.sgi.com with ESMTP id mYdwCZr0mTuNMnOF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Mar 2013 08:16:32 -0800 (PST)
Received: by mail-bk0-f44.google.com with SMTP id j4so369083bkw.17
	for <xfs@oss.sgi.com>; Wed, 06 Mar 2013 08:16:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130306161519.2c28d911@galadriel.home>
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
Date: Wed, 6 Mar 2013 17:16:31 +0100
Message-ID: <CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
Subject: Re: XFS filesystem corruption
From: Julien FERRERO <jferrero06@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Hi Emmanuel

2013/3/6 Emmanuel Florac <eflorac@intellique.com>:
> Le Wed, 6 Mar 2013 16:08:59 +0100 vous =E9criviez:
>
>> I am totally stuck and I really don't know how to duplicate the
>> corruption. I only know that units are used to be power cycle by
>> operator while the fs is still mounted (no proper shutdown / reboot).
>> My guess is the fs journal shall handle this case and avoid such
>> corruption.
>
> Wrong guess. It may work or not, depending upon a long list of
> parameters, but basically not turning it off properly is asking for
> problems and corruptions. The problem will be tragically aggravated if
> your hardware RAID doesn't have a battery backed-up cache.
>

OK but our server is 95% of the time reading data and 5% of the time
writing data. We have a case of a server that did not write anything
at the time of failure (and during all the uptime session). Moreover,
failure occurs to files that were opened in read-only or weren't
accessed at all at the time of failure. I don't think the H/W RAID is
the issue since we have the same corruption with other setup without
H/W RAID.

Does the "ls" output with "???" looks like a fs corruption ?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
