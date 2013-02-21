Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 455447F50
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 07:34:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D90ABAC004
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 05:34:43 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[194.177.153.153]) by cuda.sgi.com with ESMTP id
	py8SDrEZyn9QrRok (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Feb 2013 05:34:42 -0800 (PST)
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[192.168.34.189])
	by firestarter.dermichi.com with esmtpsa
	(TLSv1:DHE-RSA-CAMELLIA256-SHA:256) (Exim 4.80.1)
	(envelope-from <mw@dermichi.com>) id 1U8WIK-0001QI-GB
	for xfs@oss.sgi.com; Thu, 21 Feb 2013 14:34:40 +0100
Message-ID: <5126226E.2070201@dermichi.com>
Date: Thu, 21 Feb 2013 14:34:38 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: Ideal RAID-1 Stripe Size for IMAP Server ?
References: <D991F48F-6D86-4199-9762-698DD7A61895@fiton.is>
	<512607C5.9060004@shiftmail.org>
	<62DA4B79-7B29-4D9E-A756-FEC6838E5106@fiton.is>
In-Reply-To: <62DA4B79-7B29-4D9E-A756-FEC6838E5106@fiton.is>
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
To: xfs@oss.sgi.com

schrieb Svavar =D6rn Eysteinsson:
> I thought so just after sending this email to the group.
> But the ACU(Array Configuration Utility) gives me the option of changing =
the stripe size
> and gives me 256 as default.
> =

> So that is irrelevant on RAID1 completely ?
> =

It should be, yes. I would guess it becomes relavant if you later decide
that you want to expand to a RAID-10 or (shrug) RAID-5.

Generally, a small stripe size (like 64k) should be beneficial for
random access patterns like on a mail server.

hth,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
