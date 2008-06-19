Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 22:29:17 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5J5TFwS009020
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 22:29:16 -0700
Received: from zimbra.vpac.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 512BE17E5AD3
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 22:30:13 -0700 (PDT)
Received: from zimbra.vpac.org (zimbra.vpac.org [202.158.218.6]) by cuda.sgi.com with ESMTP id TeQoqjOOXRShOCYe for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 22:30:13 -0700 (PDT)
Message-ID: <4859EEDA.3060906@vpac.org>
Date: Thu, 19 Jun 2008 15:30:02 +1000
From: Brian May <brian@vpac.org>
MIME-Version: 1.0
Subject: Re: open sleeps
References: <4859EE54.6050801@vpac.org>
In-Reply-To: <4859EE54.6050801@vpac.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brian May <brian@vpac.org>
Cc: xfs@oss.sgi.com

Sorry, repost with the weird Followup-To header (was hoping Thunderbird 
would use Mail-Followup-To but obviously not).

Brian May wrote:
> Hello,
>
> I am having (weird) issues with XFS, in that open(...) on certain 
> files takes 45 seconds to return. After the file has been opened, the 
> next file in the same directory takes 45 seconds. If the file was 
> recently opened it returns immediately.
>
> I thought this was a low level I/O issue, so copied the files in 
> question to a completely independent RAID array  (separate LVM, RAID, 
> controllers, disks), but the problem remains.
>
> More details at thread starting from 
> <http://lists.luv.asn.au/wws/arc/luv-main/2008-06/msg00143.html>.
>
> Any ideas?
>
> Please CC me responses.
>
> Thanks.
>
> Brian May
