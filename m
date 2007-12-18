Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 20:10:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBI4AkZm019629
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 20:10:49 -0800
Message-ID: <47674892.9070506@sgi.com>
Date: Tue, 18 Dec 2007 15:12:02 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [review] Remove the xfs refcache
References: <4765EC66.5020202@sgi.com> <4765F444.8010705@sgi.com> <20071217071426.GA11462@infradead.org>
In-Reply-To: <20071217071426.GA11462@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>, gnb@sgi.com

Christoph Hellwig wrote:
> On Mon, Dec 17, 2007 at 03:00:04PM +1100, Lachlan McIlroy wrote:
>> Hey hold on there buddy!  We may need to reactivate this code to fix some
>> performance issues.  I've acttually got this code working and proven that
>> it is one way to fix some of the NAS/NFS issues we have.
>>
>> The little comment that reads "reference cache not needed for NFS in 2.6"
>> is wrong - we do need it or something like it.
> 
> Not in XFS, though.  This thing needs to be done genericly in NFSD.
> Greg has been working on an open files cache in nfsd which should be
> helping this.
> 
> Adding a cache like this back into XFS will get my veto (at least for
> mainline where I have a bit of a say :))
> 

Greg's NFS OFC will provide better performance for strictly NFS workloads
and if all we are trying to fix here is the NFS issues then I agree with
you that the OFC should not go into XFS.

Since I have been able to reproduce some of our NAS/NFS performance problems
without NFS (that is demonstrate that the problems are in XFS) it makes some
sense to fix these in XFS.  I have observed that for some non-NFS workloads
we see a significant reduction in log traffic with the OFC in XFS so for
reasons beyond NFS there may be a need to reactivate the refcache code.  For
the moment we are still analysing the pros/cons.
