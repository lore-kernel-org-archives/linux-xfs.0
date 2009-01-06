Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n06IkZFO004401 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 12:46:37 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0763B17B2A15
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 10:46:34 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id BsbarRmDzV37KgKo for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2009 10:46:34 -0800 (PST)
Message-ID: <4963A706.8000500@sandeen.net>
Date: Tue, 06 Jan 2009 12:46:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: need help to repair XFS partition
References: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>	<49638190.3070803@sandeen.net>
	<b75ef8170901061004n75f52cffg7f810a51aca21ff@mail.gmail.com>
In-Reply-To: <b75ef8170901061004n75f52cffg7f810a51aca21ff@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gergely Soos <sogerc1@gmail.com>
Cc: xfs@oss.sgi.com

Gergely Soos wrote:
> In my original email there was an attachment that contained the original
> boot sector, but anyway, here comes the hexdump Eric asked for:
> =

> 00000000  91 f0 1c 43 90 01 ba bf  f7 ee 29 9a 1e 6c d5 aa
> |.=F0.C..=BA=BF=F7=EE)..l=D5=AA|
> 00000010  11 5a 12 cb 3b 29 cb ff  39 ce 4e d3 95 ec b9 39
> |.Z.=CB;)=CB=FF9=CEN=D3.=EC=B99|

... actually, you might look for occurences of "XFSB" *before*
/dev/hdd1; I'd suggest looking over /dev/hdd to see if maybe your
partition start point just got hosed.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
