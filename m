Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Jul 2008 17:59:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6S0xWC8007332
	for <xfs@oss.sgi.com>; Sun, 27 Jul 2008 17:59:33 -0700
Message-ID: <488D1B8D.4020802@sgi.com>
Date: Mon, 28 Jul 2008 11:06:21 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: TAKE 981498 - remove mounpoint UUID code
References: <20080725033841.D689558C4C3F@chook.melbourne.sgi.com> <48894C66.5060204@sandeen.net> <20080725050149.GL5947@disturbed> <4889EAC9.5070304@sandeen.net>
In-Reply-To: <4889EAC9.5070304@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Niv Sardi-Altivanik <xaiki@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Eric Sandeen wrote:
> Dave Chinner wrote:
>> On Thu, Jul 24, 2008 at 10:45:42PM -0500, Eric Sandeen wrote:
>>> Niv Sardi-Altivanik wrote:
>>>> remove mounpoint UUID code
>>> Are you sure this didn't change any disk structures?  The patch I sent
>>> was RFC and completely untested...  (and disclosed as such...) :)
>> Looking at the original patch, it definitely does change the format
>> of log structures on disk. it removes the union of the uuid and rdev
>> in the xfs_inode_log_format[32|64] which takes that entry from 16
>> bytes down to 4 bytes. So I'd suggest that thisss should be removed
>> immediately before it hits public and people start corrupting their
>> filesystems....
> 
> Yep.  Well crud, I even knew that when I sent it, hence the
> RFC/untested/blah/blah but I suppose I shouldn't send a patch that I
> know to be busted even if it's just as a whaddya-think.  I'll pad out
> the union, check all the log structs, run qa & resend.
> 
> And despite all the talk about community & contributors running qa and
> helping with test coverage - as a general rule do sgi devels run qa too
> before committing?
Yes.  Well we are supposed to anyway.
