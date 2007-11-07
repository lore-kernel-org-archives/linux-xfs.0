Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Nov 2007 01:55:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA79tXg3028455
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2007 01:55:35 -0800
Date: Wed, 7 Nov 2007 20:55:30 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Deviation from XSDM in DM_EVENT_XXX
Message-ID: <20071107095530.GJ995458@sgi.com>
References: <cce360c30711062032w11ec966fy52f4702c2fff61db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cce360c30711062032w11ec966fy52f4702c2fff61db@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Manoj Kumar Pradhan <manojkp80@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 07, 2007 at 10:02:12AM +0530, Manoj Kumar Pradhan wrote:
> Hi,
> 
> Can someone tell me why XFS-DMAPI deviates in the enum DM_EVEN_XXX
> from the standard?


>From the spec:

(http://www.opengroup.org/onlinepubs/9657099/chap4.htm)

"
dm_eventtype_t

 REQUIREMENT

  This enumeration must contain at least the elements listed here. The DMAPI
  implementation may choose a different order for the elements. 
  
"

So as long as we have the events defined, it doesn't matter what
their value or order in the enum is. It's a very rubbery spec....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
