Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OE3YSE185141 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 09:03:35 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEB249A624
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:04:29 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id EmxbKSbZJ9prEN53 for
	<xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:04:29 -0700 (PDT)
Date: Fri, 24 Sep 2010 16:04:26 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Problem with file system on iSCSI FileIO
Message-ID: <20100924160426.3f0d1629@harpe.intellique.com>
In-Reply-To: <4C9CAC56.2020601@open-e.com>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<20100924151846.1208611c@harpe.intellique.com>
	<4C9CAC56.2020601@open-e.com>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: slawomir.nowakowski@open-e.com
Cc: Christoph Hellwig <hch@infradead.org>, Artur Piechocki <artur.piechocki@open-e.com>, =?UTF-8?Q?=C5=81ukasz?= Wittig <lukasz.wittig@open-e.com>, 'Ryszard Stawiarski' <ryszard.stawiarski@open-e.com>, xfs@oss.sgi.com

Le Fri, 24 Sep 2010 15:49:10 +0200
Slawomir Nowakowski <slawomir.nowakowski@open-e.com> =E9crivait:

> The problem is that we were able to use this LUN in the target, but =

> suddenly after a reboot we are not.
> =


That's strange indeed. I don't see why the target IO would cause this,
but I don't know much scst. Did you try this several times? Did you try
creating the file, unmounting and remounting without starting the scsi
target, to see it it's something scst does that kills the filesystem?

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
