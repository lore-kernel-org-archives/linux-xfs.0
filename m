Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 15:54:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1INs894007024
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:54:10 -0800
Message-ID: <47BA1BE1.4060102@sgi.com>
Date: Tue, 19 Feb 2008 10:59:29 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc3
References: <20080218062736.3322E58C4C11@chook.melbourne.sgi.com> <alpine.LFD.1.00.0802181547560.7833@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802181547560.7833@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Linus Torvalds wrote:
> 
> On Mon, 18 Feb 2008, Lachlan McIlroy wrote:
>> This will update the following files:
>>
>>  fs/xfs/Kbuild             |    6 --
>>  fs/xfs/Makefile           |  118 ++++++++++++++++++++++++++++++++++++++++++++-
>>  fs/xfs/Makefile-linux-2.6 |  117 --------------------------------------------
>>  3 files changed, 117 insertions(+), 124 deletions(-)
>>  delete mode 100644 fs/xfs/Kbuild
> 
> Hmm. This didn't actually remove the old Makefile-linux-2.6 file, so it 
> exists as a zero-length file still.
> 
> Was that intentional?
No, not intentional, just the result of a merge failure I didn't clean up.
It shouldn't cause any problems and I'll delete it in the next batch of changes.

> 
> 		Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
