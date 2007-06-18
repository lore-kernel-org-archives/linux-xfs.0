Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 16:32:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5INWLdo022656
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 16:32:23 -0700
Date: Tue, 19 Jun 2007 09:32:15 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: linux dmapi support?
Message-ID: <20070618233215.GG85884050@sgi.com>
References: <9c21eeae0706181029i19fc80a2qce004c4329f0c6b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c21eeae0706181029i19fc80a2qce004c4329f0c6b2@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Brown <dmlb2000@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 18, 2007 at 10:29:50AM -0700, David Brown wrote:
> I was wondering what was going on with the dmapi support for linux? I
> see that the mount option got removed does this mean that its on by
> default now? or is the other option used to trigger when dmapi is
> enabled?

Mount option got removed?

#define MNTOPT_DMAPI    "dmapi"         /* DMI enabled (DMAPI / XDSM) */
#define MNTOPT_XDSM     "xdsm"          /* DMI enabled (DMAPI / XDSM) */
#define MNTOPT_DMI      "dmi"           /* DMI enabled (DMAPI / XDSM) */

Still there, and it still works....

> I found some of the examples in the cvs tree for xfs-cmds under the
> tests but they just don't seem to work and for some reason it can't
> initialize the dmapi.

dmapi is not in kernel.org trees, so you need to use the cvs tree.
Then you need both the CONFIG_DMAPI and CONFIG_XFS_DMAPI build
options set to build as modules.

Then you need to load the modules, and the QA tests will run
(the qa tests check for the existance of a loaded dmapi module
and don't run if it is not present).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
