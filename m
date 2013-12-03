Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 046F07F4E
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 10:30:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8CDC8F804C
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 08:30:08 -0800 (PST)
Received: from smtp-tls.univ-nantes.fr (smtptls2-lmb.cpub.univ-nantes.fr
	[193.52.103.111]) by cuda.sgi.com with ESMTP id
	kb0EBXKPR6gbwDtc for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 08:30:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 3FBE740175B
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 17:30:06 +0100 (CET)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtptls2-lmb.cpub.univ-nantes.fr [127.0.0.1])
	(amavisd-new, port 10024)
	with LMTP id OTwn1lqvrR98 for <xfs@oss.sgi.com>;
	Tue,  3 Dec 2013 17:30:06 +0100 (CET)
Received: from [IPv6:2001:660:7220:0:1c3b:1d7b:b374:7948] (unknown
	[IPv6:2001:660:7220:0:1c3b:1d7b:b374:7948])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id F3F004016E1
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 17:30:05 +0100 (CET)
Message-ID: <529E0699.4020601@univ-nantes.fr>
Date: Tue, 03 Dec 2013 17:28:09 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
	(mode:0x250)
References: <20131128091322.GC5337@easter-eggs.com>	<20131128100521.GO10988@dastard>	<20131203095357.GC5405@easter-eggs.com>
	<20131203125057.GU10988@dastard>
In-Reply-To: <20131203125057.GU10988@dastard>
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
To: xfs@oss.sgi.com

Le 03/12/2013 13:50, Dave Chinner a =E9crit :
> On Tue, Dec 03, 2013 at 10:53:58AM +0100, Emmanuel Lacour wrote:
> OK, 32GB RAM, no obvious shortage, no dirty or writeback data. 2TB =

> SATA drives, 32AGs, only unusual setting is 64k directory block size. =

> Yup, there's your problem:

I can confirm I also saw this from times to times, in the very same =

context (ceph OSD, xfs volume with 64k directory blocks)

I never took the time to fully report the problem because it was very =

sporadic, and I suspected a specific option in my hand-made kernels, in =

which the problem seems to occurs more  often. With the 'standard' =

debian 3.10.2 (from testing) I never saw the problem (56 days uptime)

cf http://tracker.ceph.com/issues/6301

the report isn't complete here ... sometimes I just have the deadlock, =

but without oops.
can try to dig deeper inmy old logs to be sure it's really the same

Cheers,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
