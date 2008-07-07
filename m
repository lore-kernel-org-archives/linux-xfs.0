Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 18:29:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m671TGIs008843
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 18:29:18 -0700
Message-ID: <487171A7.4070602@sgi.com>
Date: Mon, 07 Jul 2008 11:30:15 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS Recovery
References: <48715CEF.8010008@sauce.co.nz> <20080707000745.GI29319@disturbed>
In-Reply-To: <20080707000745.GI29319@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Mon, Jul 07, 2008 at 12:01:51PM +1200, Richard Scobie wrote:
>> If the following log entry appears after mounting an XFS fs, is it safe  
>> to assume that whatever issue initiated the recovery has been repaired,  
>> or is further checking/repair required?
> 
> No.
> 
>> XFS mounting filesystem md5
>> Starting XFS recovery on filesystem: md5 (logdev: /dev/md0)
>> Ending XFS recovery on filesystem: md5 (logdev: /dev/md0)
> 
> That's normal output when mounting an XFS filesystem - if
> you see more than this then there might be problems...
> 
Hmmm....I don't know if I would describe that as "normal"
unless I am misunderstanding Dave here.
There has been some recovery happening indicating that there
wasn't a clean unmount (it didn't find an unmount record in the log).
But recovery should have replayed the
outstanding metadata to a time point in the near past
and so no repair should be necessary (we have qa tests which do the
test anyway and check that there are no complaints).

--Tim
