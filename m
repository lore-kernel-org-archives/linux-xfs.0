Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B07577F37
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 03:37:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A2628F8078
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 01:37:03 -0700 (PDT)
Received: from smtp-tls.univ-nantes.fr (smtptls1-cha.cpub.univ-nantes.fr
	[193.52.103.113]) by cuda.sgi.com with ESMTP id
	A9g1hlOBaKQBqAwQ for <xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 01:37:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id C039C403932
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 10:37:01 +0200 (CEST)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtptls1-cha.cpub.univ-nantes.fr [127.0.0.1])
	(amavisd-new, port 10024)
	with LMTP id GfpXnQ2foM1j for <xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 10:37:01 +0200 (CEST)
Received: from [IPv6:2001:660:7220:0:a0f1:f89d:e68f:47c9] (unknown
	[IPv6:2001:660:7220:0:a0f1:f89d:e68f:47c9])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id A2231403927
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 10:37:01 +0200 (CEST)
Message-ID: <516D0DAD.8080100@univ-nantes.fr>
Date: Tue, 16 Apr 2013 10:37:01 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: kernels 3.4 slower due to allocation workqueue
References: <516BCACE.1040900@univ-nantes.fr> <516C046C.8080908@sgi.com>
	<516CFCB8.1060804@univ-nantes.fr>
In-Reply-To: <516CFCB8.1060804@univ-nantes.fr>
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

Le 16/04/2013 09:24, Yann Dupont a =E9crit :
> Le 15/04/2013 15:45, Mark Tinguely a =E9crit :
>>
>> Here are the allocation worker changes.
>>
>
> Hello mark,  thanks for you answer
>
>> The biggest performance commit should be aa292847, which limits the =

>> callers to the worker.
>>
Yes. This is the case :

3.4.39 with aa292847b9fc6e187547110de833a7d3131bbddf applied gives full =

speed again, at least on this very specific test. Will try to have a =

more global view of the effects on other tests.

Thanks,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
