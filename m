Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9R6woX1146304 for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 01:58:50 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69322F1A78C
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 00:15:44 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id yOLDJx27SgWhwmln
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 00:15:44 -0700 (PDT)
Message-ID: <4CC7CDF6.3080405@profihost.ag>
Date: Wed, 27 Oct 2010 09:00:06 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
References: <4CC67450.9020602@profihost.ag>
	<4CC6B56B.7020007@profihost.ag>	<20101026132505.6af29d5d@harpe.intellique.com>	<201010270124.44846@zmi.at>
	<20101027080454.31a59a3c@galadriel.home>
In-Reply-To: <20101027080454.31a59a3c@galadriel.home>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

So what values do you recommand in general for iSCSI on Serverside and =

which values on iSCSI client side?

Stefan

Am 27.10.2010 08:04, schrieb Emmanuel Florac:
> Le Wed, 27 Oct 2010 01:23:35 +0200 vous =E9criviez:
>
>> BTW: any recommendations for these tuning knobs on VM-ized servers?
>> What should be set in the VMs and what on the host?
>
>  From my experience, using iSCSI as the transport to export lvs to the
> VMs, the best performance is reach by setting scheduler to noop and
> queue depth on the target and the VM; but setting the readahead only on
> the VM side.
>
> For different configurations, as usual, YMMV.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
