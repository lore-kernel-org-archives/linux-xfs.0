Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 17:14:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l920DtFV029313
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 17:14:00 -0700
Message-ID: <47018D3C.9070409@sgi.com>
Date: Tue, 02 Oct 2007 10:13:48 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com> <alpine.LFD.0.999.0710010753500.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710010753500.3579@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Linus Torvalds wrote:
> 
> On Mon, 1 Oct 2007, Tim Shimmin wrote:
>> Lachlan's description:
>>     This fix is for a problem that has been in XFS since day one.
>>     [XFS] Avoid replaying inode buffer initialisation log items if on-disk version is newer.
> 	...
> 
> Why wasn't this in the commit logs? Now it just says it was reverted, with 
> no actual reasoning *why*. And it apparently wasn't so obvious that no 
> such reasoning is needed.
> 
> Gah. I ended up amending the commit and updating it with the comment.
> 
> 		Linus

Yeah, sorry about that.
It occurred to me later on.
I initially converted the sgi-mod (undo mod) to a git commit and
then discovered git-revert and thought, hey I'll use that
instead but then forgot to add all the text into it.
D'oh. Thanks for the fixup.

--Tim
