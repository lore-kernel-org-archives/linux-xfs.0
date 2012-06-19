Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JBUPJT081163 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 06:30:26 -0500
Received: from blade3.isti.cnr.it (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id GG7uTnjSTtQwI82y (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 04:30:24 -0700 (PDT)
Received: from [192.168.6.232] ([155.253.6.254])
	by mx.isti.cnr.it (PMDF V6.5-x6 #31988)
	with ESMTPSA id <01OGVDYYQWV8ODSR3C@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Tue, 19 Jun 2012 13:29:19 +0200 (MEST)
Date: Tue, 19 Jun 2012 13:29:55 +0200
From: Spelic <spelic@shiftmail.org>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
In-reply-to: <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
Message-id: <4FE062B3.7080702@shiftmail.org>
MIME-version: 1.0
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
	<20120619031241.GA3884@redhat.com>
	<alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>, linux-ext4@vger.kernel.org

On 06/19/12 08:32, Luk=E1=9A Czerner wrote:
>
> So do I understand correctly that even though the discard came
> through and thinp took advantage of it it still returns EOPNOTSUPP ?
> This seems rather suboptimal. IIRC there was a discussion to add an
> option to enable/disable sending discard in thinp target down
> to the device.

I'll ask this too...
do I understand correctly that dm-thin returns EOPNOTSUPP to the =

filesystem layer even though it is using the discard to unmap blocks, =

and at that point XFS stops sending discards down there (while ext4 =

keeps sending them)?

This looks like a bug of dm-thin to me. Discards are "supported" in such =

a scenario.

Do you have a patch for dm-thin so to prevent it sending EOPTNOTSUPP ?

Thank you
S.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
