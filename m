Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Nov 2006 06:10:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kASEAiaG023931
	for <xfs@oss.sgi.com>; Tue, 28 Nov 2006 06:10:46 -0800
Message-ID: <456C432E.2050601@redhat.com>
Date: Tue, 28 Nov 2006 08:09:50 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH/RFC] pass dio_complete proper offset from finished_one_bio
References: <45691753.60500@redhat.com>
In-Reply-To: <45691753.60500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, rtc@gmx.de

Eric Sandeen wrote:
> We saw problems w/ xfs doing AIO+DIO into a sparse file.
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=217098
> 
> It seemed that xfs was doing "extent conversion" at the wrong offsets, so
> written regions came up as unwritten (zeros) and stale data was exposed
> in the region after the write.  Thanks to Peter Backes for the very
> nice testcase.
> 
> This also broke xen with blktap over xfs.

Hrmph.  Zach's changes in -mm magically made this go away... I was about 
to submit a proper patch against -mm but it seem to be not needed.

So, now digging around to see why that is, and what exactly "fixed" things.

-Eric
