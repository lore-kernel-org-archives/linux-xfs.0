Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Oct 2006 00:14:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9H7EhaG017704
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 00:14:45 -0700
Date: Tue, 17 Oct 2006 17:13:01 +1000
From: Tim Shimmin <tes@sgi.com>
Subject: Re: [PATCH 1/2] Make stuff static
Message-ID: <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com>
In-Reply-To: <20061017005038.GN11034@melbourne.sgi.com>
References: <20060929032856.8DA9C18001A5E@sandeen.net>
 <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local>
 <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net>
 <20061016232250.GM11034@melbourne.sgi.com>
 <1161042943.5723.117.camel@xenon.msp.redhat.com>
 <20061017005038.GN11034@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Russell Cattelan <cattelan@thebarn.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



--On 17 October 2006 10:50:38 AM +1000 David Chinner <dgc@sgi.com> wrote:

> On Mon, Oct 16, 2006 at 06:55:43PM -0500, Russell Cattelan wrote:
>> On Tue, 2006-10-17 at 09:22 +1000, David Chinner wrote:
>> > On Mon, Oct 16, 2006 at 04:34:34PM -0500, Eric Sandeen wrote:
>> > > Eric Sandeen wrote:
>> > > > Timothy Shimmin wrote:
>> > > >> Okay, started looking :-)
>> > >
>> > > One other thing, based on the bug on osdl today, some of these larger
>> > > newly-static functions should probably be marked noinline to keep gcc
>> > > from doing things we don't want it to...
>> >
>> > <grumble>
>> >
>> > This is not an obvious compiler hint (compared to, say, likely()) as
>> > the functions gcc automatically inlines changes according to
>> > compiler version, optimisation level and platform. Hence adding
>> > noinline notation will be like playing whack-a-mole and I doubt it
>> > will be consistently used or maintained moving forward. It's the
>> > wrong solution, IMO.
>> >
>> > I think we should change the definition of STATIC so we don't have
>> > to poison the code to work around some stupid compiler behaviour.
>> > That is, unless we specifically say "inline" for static functions,
>> > we really mean "noinline".
>
>> So you are proposing?
>> /* non-debug */
>> # define STATIC static inline
>> /* debug */
>> # define STATIC noinline
>
> No.
>
> Currently STATIC is defined in fs/xfs/support/debug.h as:
>
># ifndef STATIC
># define STATIC static
># endif
>
> I'm proposing that gets changed to:
>
>> # define STATIC static noinline
>
> This.
>
>> That doesn't work either ...
>> STATIC inline
>> becomes
>> static noline inline?
>
> Fix them - inline functions in header files should always be "static
> inline".  Inline functions in .c files should always be static as
> well - if they need to be accessed from different source files then
> they need to be in header files.  Hence "STATIC inline" is broken
> code and should be fixed anyway. Luckily, there are very few of
> these to fix and they are all in .c files:
>
> chook 137% grep -rIw "STATIC inline" fs/xfs | wc -l
> 21
>

So you are saying that "static inline"s should always be.
So for CONFIG_XFS_DEBUG where we define STATIC and so make static
disappear for uses of STATIC, we will no longer touch these
"static inline" functions.
I thought that for debug, we could stop them from being inline
for easier debugging. We could have a STATIC_INLINE :-)

--Tim
