Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 18:49:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l931nLTg016868
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 18:49:24 -0700
Message-ID: <4702F517.3040502@sgi.com>
Date: Wed, 03 Oct 2007 11:49:11 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com> <4700EE2A.1020304@sandeen.net> <4701A1D0.5010709@sgi.com> <4701ED51.8050706@sgi.com> <Pine.LNX.4.64.0710020442540.24427@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0710020442540.24427@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hi Justin,

Justin Piszcz wrote:
> 
> 
> On Tue, 2 Oct 2007, Lachlan McIlroy wrote:
> 
>> Yeah that about sums it up.  In an attempt to prevent log replay of 
>> inodes
>> in cases when we shouldn't replay we also prevented log replay of 
>> inodes in
>> cases when we should replay.  We end up with directories that refer to 
>> inodes
>> that were not replayed and we read existing data off disk.  That existing
>> data is usually previous instances of inodes.  We had cases of regular 
>> files
>> turning into directories and inode version mismatches.
>>
>> Lachlan
>>
> In 2.6.23-rc8?
> 
The bad change went into rc7 and was still there in rc8.
It was backed out for rc9.

--Tim
