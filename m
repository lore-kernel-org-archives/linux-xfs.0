Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Aug 2007 21:31:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7G4VJbm004337
	for <xfs@oss.sgi.com>; Wed, 15 Aug 2007 21:31:22 -0700
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l7G428X1030225
	for <xfs@oss.sgi.com>; Thu, 16 Aug 2007 00:02:08 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l7G428rQ027228
	for <xfs@oss.sgi.com>; Thu, 16 Aug 2007 00:02:08 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l7G427us016409
	for <xfs@oss.sgi.com>; Thu, 16 Aug 2007 00:02:08 -0400
Message-ID: <46C3CC46.8030005@redhat.com>
Date: Wed, 15 Aug 2007 23:02:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: xfsprogs/xfsdump: what flavor of GPL...?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Fedora is making a push to clarify licensing on all packages -

GPL+, GPLv2, GPLv2+, GPLv3, GPLv3+, LGPLv2, LGPLv2+, LGPLv3, LGPLv3+

are the acceptable license tags for rpm packaging at this point. ("+"
means "or later").

Looking, for example, at mkfs/xfs_mkfs.c:

 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation.

it makes no mention of GPL _version_.

With all the ruckus lately over GPLv3, could sgi please clarify?  Since
the included COPYING file says LGPL 2.1 and GPL2, I assume that LGPLv2
and GPLv2 are appropriate for the package.

It'd be tedious, but you may wish to specify exactly which version of
the license in the actual source files...

Thanks,

-Eric
