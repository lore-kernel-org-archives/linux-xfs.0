Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 19:37:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9B2boik009420
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 19:37:52 -0700
Message-ID: <470D8D91.903@sgi.com>
Date: Thu, 11 Oct 2007 12:42:25 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: review: use correct buffer flags when reading superblock
References: <470C8F5B.90705@sgi.com> <20071010112821.GI23367404@sgi.com>
In-Reply-To: <20071010112821.GI23367404@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Wed, Oct 10, 2007 at 06:37:47PM +1000, Lachlan McIlroy wrote:
>> When reading the superblock during log recovery we are not setting
>> the correct buffer flags.  Specifically we are not turning off flags
>> we do not need such as XBF_ASYNC that is causing the synchronous
>> xfs_iowait() to hang.  We should also turn off XBF_WRITE and remove
>> the buffer from the delay write queue just to be safe.
> 
> We really don't need the removal of the write flags - the XFS_bflush()
> call above the xfs_getsb() call guarantees that they won't be set....
> 

It's not obvious though.  It wasn't obvious that ASYNC was still set
and look where that got us.
