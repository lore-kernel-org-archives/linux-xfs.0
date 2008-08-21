Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 08:58:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7LFw65h028013
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 08:58:06 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38B933BBFCC
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 08:59:27 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Iyfd4XvKWcYAy1zq for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 08:59:27 -0700 (PDT)
Date: Fri, 22 Aug 2008 01:59:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080821155925.GI5706@disturbed>
References: <293210.50030.qm@web32606.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <293210.50030.qm@web32606.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 21, 2008 at 04:05:21AM -0700, Martin Knoblauch wrote:
>  just curious - which CCISS controller and and what kind of disk configuration are you using.

Smart Array 5300, using a single 36GB 10krpm U3SCSI disk.

Looks like most of the problems were caused by the firmware,
and are not driver related. An upgrade to a newer (2002!) firmware
appears to have fixed the worst of the problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
