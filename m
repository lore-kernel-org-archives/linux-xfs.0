Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Mar 2008 11:12:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2CIBout001558
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2008 11:11:52 -0700
Received: from mail.rfc1149.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7A1768EF26
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2008 11:12:18 -0700 (PDT)
Received: from mail.rfc1149.net (zaphod.rfc1149.net [88.191.14.223]) by cuda.sgi.com with ESMTP id Ck7EFBT5mHiaEoSv for <xfs@oss.sgi.com>; Wed, 12 Mar 2008 11:12:18 -0700 (PDT)
Resent-Message-ID: <20080312181202.GK4884@rfc1149.net>
Resent-To: xfs@oss.sgi.com, dgc@sgi.com
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de>
	<20080307224040.GV155259@sgi.com>
	<alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
	<20080309213441.GQ155407@sgi.com>
Date: Wed, 12 Mar 2008 19:03:51 +0100
In-Reply-To: <20080309213441.GQ155407@sgi.com> (David Chinner's message of "Mon\, 10 Mar 2008 08\:34\:41 +1100")
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
From: Samuel Tardieu <sam@rfc1149.net>
Message-Id: <2008-03-12-19-12-02+trackit+sam@rfc1149.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: device-mapper development <dm-devel@redhat.com>
Cc: Christian Kujau <lists@nerdbynature.de>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

>>>>> "David" == David Chinner <dgc@sgi.com> writes:

>> No, no I/O errors at all. See the kern.log above, I could even do
>> dd(1) from the md1 (dm-crypt on raid1), no errors either.

David> Oh, dm-crypt. Well, I'd definitely start looking there. XFS has
David> a history of exposing dm-crypt bugs, and these hangs appear to
David> be I/O congestion/scheduling related and not XFS. Also, we
David> haven't changed anything related to plug/unplug of block
David> devices in XFS recently, so that also points to some other
David> change as well...

For what it is worth, I notice the same error last week (with a kernel
of the day) on my laptop but was too busy at work to investigate. And
I use ext3... on dm-crypt.

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/
