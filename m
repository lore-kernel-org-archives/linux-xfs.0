Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 22:11:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P5BjRo015568
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:11:46 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH, RFC] - remove mounpoint UUID code
References: <47D20F78.7000103@sandeen.net>
	<ncc7ibavh1s.fsf@itchy.melbourne.sgi.com>
	<48894466.4020507@sandeen.net>
Date: Fri, 25 Jul 2008 15:12:46 +1000
In-Reply-To: <48894466.4020507@sandeen.net> (Eric Sandeen's message of "Thu,
	24 Jul 2008 22:11:34 -0500")
Message-ID: <nccljzqtult.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen <sandeen@sandeen.net> writes:

> Niv Sardi wrote:
>> ACK, removing it, it should be trivial to put back in if we ever need it.
>
> Ok, hch had some comments and this needs a careful eye towards any
> affected disk structures so probably should not go in immediately as-is.

Yeah, just saw that, well it's only in -dev now, so we'll audit it
carefully, and see where it goes.

I only read hch's last comment which ended in «This is really just dead
junk that should go away.».

Anyway, we now can use the awesome xfsqa infrastructure to have this
tested =)

Cheers,
-- 
Niv Sardi
