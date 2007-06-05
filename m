Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 16:20:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l55NKiWt013845
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 16:20:46 -0700
Date: Wed, 6 Jun 2007 09:20:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS with project quota under linux?
Message-ID: <20070605232033.GZ85884050@sgi.com>
References: <950DD867A5E1B04ABE82A56FCDC03A5E9CE8CF@HDHS0111.euro1.voith.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <950DD867A5E1B04ABE82A56FCDC03A5E9CE8CF@HDHS0111.euro1.voith.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jahnke, Steffen" <Steffen.Jahnke@vs-hydro.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 04, 2007 at 10:55:35AM +0200, Jahnke, Steffen wrote:
> I recently switched the quota usrquota to pquota on our Altix 4700 under
> SLES10. I then found out that the project quota is not updated if files are
> moved within the same filesystem. E.g. if I move a file from a different
> project to a new project it still belongs to the old project. The same thing
> happens if I move a file which not belongs to any project but which is on
> the filesystem mounted with pquota.

Working as designed, by the sounds of it. Moving a file around
the filesystem does not change the project it is assigned to.
Files created (i.e. moved into the filesystem) get assigned a
new project id on create which is why there is different behaviour
there.

Are you trying to use directory quotas here rather than just
plain project quotas?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
