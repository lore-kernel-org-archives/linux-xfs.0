Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 13:46:53 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1CLkimv030260
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2008 13:46:47 -0800
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 381475CB32B
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2008 13:47:08 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id 3yo09zc0DqKeOQel for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2008 13:47:08 -0800 (PST)
Message-ID: <47B21327.3080502@tlinx.org>
Date: Tue, 12 Feb 2008 13:44:07 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs [_fsr] probs in 2.6.24.0
References: <47B0F00D.3060802@tlinx.org> <20080212085802.GA155407@sgi.com> <47B2094D.50406@tlinx.org> <47B20E84.6020707@sandeen.net>
In-Reply-To: <47B20E84.6020707@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, Linux-Xfs <linux-xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>



Eric Sandeen wrote:
> Linda Walsh wrote:
>> David Chinner wrote:
>>> Filesystem bugs rarely hang systems hard like that - more likely is
>>> a hardware or driver problem. And neither of the lockdep reports
>>> below are likely to be responsible for a system wide, no-response
>>> hang.
>> ---
>> 	"Ish", the 32-bitter, has been the only hard-hanger.
> 
> 4k stacks?
----
	But but but...almost from the day they were introduced.  And
these are more recent probs. Has stack usage increased for some reason,
:-(.  I do have the option to detect stack-overflow turned on as well
-- guess it doesn't work so well?

	If they are that problematic, maybe selecting xfs as a config
option should force 8k stacks (ugly solution, but might eliminate
some lost hair (from pulling it out) for end users....?

	Guess I should go back to 8k's for now...seems odd that it'd
pop up now, but maybe it's the xtra NFS loading?  Sigh.
