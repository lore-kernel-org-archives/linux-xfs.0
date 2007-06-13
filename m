Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 14:57:47 -0700 (PDT)
Received: from mail.dvmed.net (srv5.dvmed.net [207.36.208.214])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5DLvgWt009653
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 14:57:43 -0700
Message-ID: <4670602F.9000908@pobox.com>
Date: Wed, 13 Jun 2007 17:22:55 -0400
From: Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com> <20070607110708.GS86004887@sgi.com> <46680F5E.6070806@dgreaves.com> <20070607222813.GG85884050@sgi.com> <4669A965.20403@dgreaves.com> <alpine.LFD.0.98.0706121123550.14121@woody.linux-foundation.org> <466FD214.9070603@dgreaves.com> <alpine.LFD.0.98.0706131344550.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706131344550.14121@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Greaves <david@dgreaves.com>, David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

Linus Torvalds wrote:
> Ok, good. So the bug is apparently in the generic SCSI layer start/stop
> handling. I'm not entirely surprised, most people would never have 
> triggered it (I _think_ it's disabled by default for all devices, and that 
> the libata-scsi.c change was literally the first thing to ever enable it 
> by default for anything!)


I haven't looked at this yet, but wanted to confirm your assessment 
here:  libata was indeed the first (and still only?) user of this code path.

Since some SCSI devices may not be owned by the host computer, in the 
power management sense, we don't want to turn that on for all SCSI 
devices.  Otherwise you wind up powering off a device in another building :)

This is basically the libata suspend/resume path, even though bits touch 
generic SCSI.

	Jeff
