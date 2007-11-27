Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Nov 2007 07:28:32 -0800 (PST)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lARFSQJJ005166
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2007 07:28:28 -0800
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: XFS related Oops (suspend/resume related)
Date: Tue, 27 Nov 2007 16:46:53 +0100
References: <20071112064706.GA23595@dose.home.local> <200711262307.56742.rjw@sisk.pl> <20071127132000.GA31893@dose.home.local>
In-Reply-To: <20071127132000.GA31893@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271646.54331.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tino Keitel <tino.keitel@gmx.de>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tuesday, 27 of November 2007, Tino Keitel wrote:
> On Mon, Nov 26, 2007 at 23:07:56 +0100, Rafael J. Wysocki wrote:
> 
> [...]
> 
> > On 2.6.23.1 you can test the freezer alone by doing
> > 
> > # echo testproc > /sys/power/disk
> > # echo disk > /sys/power/state
> 
> This is suspend to RAM, not to disk.

I know. :-)

Nevertheless, this is how you can test the tasks freezer _without_ actually
doing a suspend of any kind.

Greetings,
Rafael
