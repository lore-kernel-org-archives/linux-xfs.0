Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 02:56:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2E9u2O9019283
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 02:56:04 -0700
Message-ID: <47DA44EB.8000307@redhat.com>
Date: Fri, 14 Mar 2008 10:27:07 +0100
From: Milan Broz <mbroz@redhat.com>
MIME-Version: 1.0
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com>
In-Reply-To: <20080309213441.GQ155407@sgi.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christian Kujau <lists@nerdbynature.de>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com

David Chinner wrote:
>>> Also, the iolock can be held across I/O so it's possible you've lost an 
>>> I/O. Any I/O errors in the syslog?
>> No, no I/O errors at all. See the kern.log above, I could even do dd(1) 
>> from the md1 (dm-crypt on raid1), no errors either.
> 
> Oh, dm-crypt. Well, I'd definitely start looking there. XFS has a
> history of exposing dm-crypt bugs, and these hangs appear to be I/O
> congestion/scheduling related and not XFS. Also, we haven't changed
> anything related to plug/unplug of block devices in XFS recently, so
> that also points to some other change as well...

Yes, there is bug in dm-crypt...
Please try if the patch here helps: http://lkml.org/lkml/2008/3/14/71

Thanks,
Milan
--
mbroz@redhat.com
