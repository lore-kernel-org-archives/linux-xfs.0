Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 246B229E05
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 09:35:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AFAB0AC003
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 07:35:30 -0700 (PDT)
Received: from smtp-tls.univ-nantes.fr (smtptls1-loi.cpub.univ-nantes.fr
	[193.52.103.112]) by cuda.sgi.com with ESMTP id
	KS7Q2Kmha6CzhFaz for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 07:35:29 -0700 (PDT)
Message-ID: <516EB330.8050207@univ-nantes.fr>
Date: Wed, 17 Apr 2013 16:35:28 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: kernels 3.4 slower due to allocation workqueue
References: <516BCACE.1040900@univ-nantes.fr> <516C046C.8080908@sgi.com>
	<516CFCB8.1060804@univ-nantes.fr> <516D518F.1000708@sgi.com>
	<516EA72F.3030200@univ-nantes.fr> <516EADA5.1040007@sgi.com>
In-Reply-To: <516EADA5.1040007@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Le 17/04/2013 16:11, Mark Tinguely a =E9crit :
> On 04/17/13 08:44, Yann Dupont wrote:
>> Le 16/04/2013 15:26, Mark Tinguely a =E9crit :
>>>
>>> The filesystem can hang but only if the OS cannot allocate another
>>> worker when doing certain calls.
>>>
>>> --Mark.
>>
>> Ok, any chance to see these fixes backported to 3.4 ?
>>
>> Cheers,
>>
>
> All of the patches apply to Linux 3.4 without modification.
Yes, sorry, I should have said incorporated/pushed back
>
> It does not sound like the patches will be pushed back to stable at =

> this time.
If you consider, for the moment, not pushing the patches in 3.4, =

(because of stability concerns, or you judge these patches intrusives, =

or whatever good reason), I won't do either, because I have no vision of =

the potential problems with the patched kernel. I always try to stay on =

pure vanilla kernels, longterm if possible, because stability is the =

more important.

My best bet is probably 3.8 kernels right now (even if they are not =

longterm), or maybe simply going back to 3.2.

Thanks for your answers,
Cheers

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
