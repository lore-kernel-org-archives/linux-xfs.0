Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Oct 2007 18:54:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9H1sU2G021526
	for <xfs@oss.sgi.com>; Tue, 16 Oct 2007 18:54:33 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA29135; Wed, 17 Oct 2007 11:54:28 +1000
Message-ID: <47156B54.8070102@sgi.com>
Date: Wed, 17 Oct 2007 11:54:28 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: Fix dbflush panic in xfs_qm_sync
References: <4713F7D3.2090201@sgi.com> <4714498A.8090902@sgi.com> <20071016060726.GR995458@sgi.com>
In-Reply-To: <20071016060726.GR995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Tue, Oct 16, 2007 at 03:18:02PM +1000, Lachlan McIlroy wrote:
>> Could mp->m_quotainfo become NULL after this check but before we
>> lock the list with xfs_qm_mplist_lock()?  There doesn't seem to
>> be any locking to protect changes to this field?
> 
> Possible - in theory. Likely - no. We do the same unlocked check in a
> few places...
> 

The mplist lock doesnt prevent the quotainfo going away while its held.
It's just guarding a hashlist that lives in quotainfo structure.
So none of this code prevents a quotaoff race.

In the short term this change restores the original checks. But in the
longer term we should review the locking in the quota system, possibly
adding a quotaoff lock to xfs_mount_t.

Don
