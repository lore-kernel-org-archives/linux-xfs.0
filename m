Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Feb 2008 09:12:02 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1BHBsAs027326
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 09:11:55 -0800
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B50DCDE1979
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 09:12:17 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.175]) by cuda.sgi.com with ESMTP id LnZtcQ2qAsCrVSbm for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 09:12:17 -0800 (PST)
Received: by ug-out-1314.google.com with SMTP id o29so841501ugd.20
        for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 09:12:16 -0800 (PST)
Date: Mon, 11 Feb 2008 18:12:09 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: Data safety horror stories?
Message-ID: <20080211171209.GA7567@teal.hq.k1024.org>
References: <1202748389.28320.1236240801@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202748389.28320.1236240801@webmail.messagingengine.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Felix E. Klee" <felix.klee@inka.de>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 11, 2008 at 05:46:29PM +0100, Felix E. Klee wrote:
> I heard that, in case of a power failure, XFS may lose data, even data
> that was already existing on the disk. For example, I heard horror
> stories of files being overwritten with zeros.
> 
> Are those stories true?

No, XFS will not lose any data that the application has committed to the
disk.

Improperly written applications and/or improperly configured systems
might have issues with recently written files losing data.

FWIW: I have never lost data with XFS, neither on home computers nor in
SAN environments (in the presence of link/path failure).

Be sure the read the FAQ, especially the section about write cache on
dekstop/consumer HDDs.

Just my opinion as an XFS user, your mileage might vary.

iustin
