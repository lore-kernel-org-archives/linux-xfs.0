Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Sep 2006 15:41:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8MMesaG029862
	for <xfs@oss.sgi.com>; Fri, 22 Sep 2006 15:40:55 -0700
Received: from smtp113.sbc.mail.mud.yahoo.com (smtp113.sbc.mail.mud.yahoo.com [68.142.198.212])
	by cuda.sgi.com (Spam Firewall) with SMTP id 93FC4D112657
	for <xfs@oss.sgi.com>; Fri, 22 Sep 2006 14:31:17 -0700 (PDT)
Date: Fri, 22 Sep 2006 14:24:35 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Write barrier support with LVM2/md
Message-ID: <20060922212435.GA20811@tuatara.stupidest.org>
References: <20060922104417.GA4161@dezo.moloch.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060922104417.GA4161@dezo.moloch.sk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Lucina <mato@kotelna.sk>
Cc: xfs@oss.sgi.com

On Fri, Sep 22, 2006 at 12:44:17PM +0200, Martin Lucina wrote:

> Is anyone working on a fix for this?  It might be a good idea to add
> to the FAQ that write barriers are not supported on dm devices.

it's not really an XFS issue, it's that the md/dm/lvm layers don't
support write barriers (and it would in many cases be hard to support
without killing performance).
