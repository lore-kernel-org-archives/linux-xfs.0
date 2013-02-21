Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA6497F51
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 05:40:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A6C138F8037
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 03:40:32 -0800 (PST)
Received: from srv2.trombetti.net (srv2.trombetti.net [65.254.53.252]) by
	cuda.sgi.com with ESMTP id pnTdyChTcE5G1BXJ for
	<xfs@oss.sgi.com>; Thu, 21 Feb 2013 03:40:30 -0800 (PST)
Message-ID: <512607C5.9060004@shiftmail.org>
Date: Thu, 21 Feb 2013 12:40:53 +0100
From: Spelic <spelic@shiftmail.org>
MIME-Version: 1.0
Subject: Re: Ideal RAID-1 Stripe Size for IMAP Server ?
References: <D991F48F-6D86-4199-9762-698DD7A61895@fiton.is>
In-Reply-To: <D991F48F-6D86-4199-9762-698DD7A61895@fiton.is>
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
Cc: =?ISO-8859-1?Q?Svavar_=D6rn_Eysteinsson?= <svavar@fiton.is>

On 02/21/13 12:11, Svavar =D6rn Eysteinsson wrote:
> Hi there.
>
> I'm currently configuring a brand new email server(IMAP) which will run
> CentOS 6.3 x64.
>
> So lots of files on the data volume.
>
> I'm confused about stripe size for my data volume.
> I'm using 2x500GB for OS in RAID1 and 2x2TB SAS for DATA in RAID1 which is
> hosted on a HP Smart Array P420 Controller with 1GB in Cache/Battery Back=
ed Up.
> Both these array's are on the P420 controller.

Raid1 cannot have "stripes" !?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
