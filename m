Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 146527F4E
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 09:11:46 -0500 (CDT)
Message-ID: <516EADA5.1040007@sgi.com>
Date: Wed, 17 Apr 2013 09:11:49 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: kernels 3.4 slower due to allocation workqueue
References: <516BCACE.1040900@univ-nantes.fr> <516C046C.8080908@sgi.com>
	<516CFCB8.1060804@univ-nantes.fr> <516D518F.1000708@sgi.com>
	<516EA72F.3030200@univ-nantes.fr>
In-Reply-To: <516EA72F.3030200@univ-nantes.fr>
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
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: xfs@oss.sgi.com

On 04/17/13 08:44, Yann Dupont wrote:
> Le 16/04/2013 15:26, Mark Tinguely a =E9crit :
>>
>> The filesystem can hang but only if the OS cannot allocate another
>> worker when doing certain calls.
>>
>> --Mark.
>
> Ok, any chance to see these fixes backported to 3.4 ?
>
> Cheers,
>

All of the patches apply to Linux 3.4 without modification.

It does not sound like the patches will be pushed back to stable at this =

time.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
