Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E63C97CBF
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 09:59:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7C99304032
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 07:59:12 -0700 (PDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com
	[74.125.82.45]) by cuda.sgi.com with ESMTP id 0GgKrildiKm16XL6
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Mar 2013 07:59:11 -0700 (PDT)
Received: by mail-wg0-f45.google.com with SMTP id x12so1657485wgg.24
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 07:59:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
References: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
Date: Thu, 28 Mar 2013 15:59:08 +0100
Message-ID: <CAAxjCEzt4MhNL+hOW5P1zJH3uCL2wjL0t1XmQ6mLPunDbF52OA@mail.gmail.com>
Subject: Re: Help with XFS in VMs on VMFS
From: Stefan Ring <stefanrin@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Perci <jperci@gmail.com>
Cc: xfs@oss.sgi.com

> This setup is not optimal and has risks, but I must work within some
> constraints.  There are a few things I can do to increase I/O performance,
> such as distributing the VMDK files used by each LV across the 6 VMFS
> datastores.  But can XFS be tuned as well?  Do stripe unit and stripe width
> help?  Thanks for your help.

I guess you should make the number of allocation groups equal to or a
multiple of the number of concatenated VMDK files (assuming they are
equally sized). Any more fiddling is probably not worth the effort.
But I'm sure you'll get lengthy answers from other people on the list
;).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
