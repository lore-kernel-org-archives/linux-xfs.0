Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 726F67F37
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 15:09:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 633EA8F8033
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 13:09:26 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OrUGDCsam5sDGlnW for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 13:09:21 -0700 (PDT)
Date: Wed, 7 May 2014 06:09:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS tune to adaptec ASR71605
Message-ID: <20140506200917.GM5421@dastard>
References: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>
	<20140506130008.13a1a7ee@harpe.intellique.com>
	<alpine.LRH.2.02.1405061408480.24742@becks.mcs.st-and.ac.uk>
	<20140506155149.5cf056b5@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506155149.5cf056b5@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Steve Brooks <steveb@mcs.st-and.ac.uk>, xfs@oss.sgi.com

On Tue, May 06, 2014 at 03:51:49PM +0200, Emmanuel Florac wrote:
> Le Tue, 6 May 2014 14:14:35 +0100 (BST)
> Steve Brooks <steveb@mcs.st-and.ac.uk> =E9crivait:
> =

> > Thanks for the reply Emmanuel, I installed and rua bonnie++ although
> > I will need to research the results
> =

> Yup, they're... weird :) Write speed is abysmal, but random seeks very
> high. Please try my settings so that we can compare the numbers more
> directly:

Friends don't let friends use bonnie++ for benchmarking storage.
The numbers you get will be irrelevant to you application, and it's
so synthetic is doesn't reflect any real-world workload at all.

The only useful benchmark for determining if changes are going to
improve application performance is to measure your application's
performance.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
