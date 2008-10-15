Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 19:49:32 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F2nTFT012854
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 19:49:30 -0700
Message-ID: <48F56864.7030004@sgi.com>
Date: Wed, 15 Oct 2008 13:49:56 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: TAKE 988141 - Fix build error - use VFS_I() to access linux	inode
 from xfs inode
References: <20081015021055.6B76358FA1E9@chook.melbourne.sgi.com> <20081015022106.GA22939@infradead.org> <48F5654E.3080900@sgi.com> <20081015024014.GA21790@infradead.org>
In-Reply-To: <20081015024014.GA21790@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Oct 15, 2008 at 01:36:46PM +1000, Lachlan McIlroy wrote:
>> Sorry Christoph.  I just don't have time to read all posts.
>>
>> I expect fixes to be in the same patch series that breaks the code - it
>> didn't occur to me to go looking for a fix on OSS.
> 
> Well, Daven unfortunately can't be bothered to use the same tree as
> everyone else.  But I made it pretty clear in the patch that it is
> needed for the series when using a ptools/cvs style tree, and that it's
> harmless to apply it ASAP even without those bits.

We really appreciate you using the cvs tree and keeping all the non-
mainline stuff up to date and working.  If you like I'll credit you for
the patch when I push it to OSS.
