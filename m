Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 17:01:19 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H01HIk012659
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 17:01:17 -0700
Message-ID: <48F7E3FA.3020400@sgi.com>
Date: Fri, 17 Oct 2008 11:01:46 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: crash with latest code drop.
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed> <20081015022948.GA20966@infradead.org> <20081015031645.GA25906@disturbed> <20081015032431.GA7426@infradead.org> <20081015035116.GB25906@disturbed> <48F584B8.8060907@sgi.com> <20081015061917.GC25906@disturbed> <48F5A104.5060506@sgi.com> <48F6AA3E.8030902@sgi.com> <20081016090030.GA31558@infradead.org>
In-Reply-To: <20081016090030.GA31558@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Leckie <pleckie@sgi.com>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Thu, Oct 16, 2008 at 12:43:10PM +1000, Peter Leckie wrote:
>> Adding the following resolved the issue however you may wish to solve it  
>> in another manner.
>>
>> @@ -102,7 +102,7 @@ xfs_sync_inodes_ag(
>>                 * in reclaim. Leave it for the reclaim code to flush.
>>                 */
>>                inode = VFS_I(ip);
>> -               if (!igrab(inode)) {
>> +               if (!inode || !igrab(inode)) {
>>                        read_unlock(&pag->pag_ici_lock);
>>                        continue;
>>                }
>>
> 
> This would be the correct fix for the current code, but can you please
> put in the Inode/XFS Inode unification patches?  At least I have only
> QAed the whole patchkit, and from the issues here it seems like Dave did
> the same.
That patchset is already in.

> 
> And with that it would also be very good if there was any chance Dave
> and me (and all others) could actually access the current tree.  The
> ptools -> CVS export has been broken for mor than two days, and there
> is no uptodate git tree eiter, so us external developers are completely
> tapping in the dark vs the current tree.
We had no idea the CVS tree was not updating.  I'll get the OSS trees
updated today.
